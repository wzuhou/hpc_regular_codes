############R
#' @return A list contain a table and a figure.
#' @examples
#' df1.path = system.file("examples", "ddct.cq.txt", package = "qPCRtools")
#' df2.path = system.file("examples", "ddct.design.txt", package = "qPCRtools")
#'
#' cq.table = read.table(df1.path, header = TRUE)
#' design.table = read.table(df2.path, header = TRUE)
#'
#' CalExp2ddCt(cq.table,
#'             design.table,
#'             ref.gene = "OsUBQ",
#'             ref.group = "CK",
#'             stat.method = "t.test",
#'             remove.outliers = TRUE,
#'             fig.type = "box",
#'             fig.nrow = NULL) -> res
#'
#' res[["table"]]
#' res[["figure"]]
#'
library(ggplot2)
MyCalExp2ddCt <- function(cq.table,
                          design.table,
                          ref.gene = "GAPDH",
                          ref.group = "MOCK",
                          stat.method = "t.test",
                          fig.type = "bar",
                          Myorder = Myorder,
                          Grouporder = Grouporder,
                          fig.nrow = 1) {
  #options(digits=5)
  # merge data
  cq.table %>%
    dplyr::left_join(design.table, by = "Position") %>%
    dplyr::rename(
      position = Position,
      cq = Cq,
      group = Group,
      gene = Gene,
      biorep = BioRep
    ) -> dfall
  
  #ref.gene = "G"
  #ref.group = "Mock"
  #stat.method = "t.test"
  # for each gene
  target.genes <- setdiff(unique(dfall$gene), ref.gene)
  timepoint <- unique(dfall$timepoint)
  
  # res
  res.all <- NULL
  #
  for (times in timepoint) {
    #times='48h'
    dfall %>%
      dplyr::filter(timepoint %in% c(times)) -> df
    
    for (genes in target.genes) {
      #gene + ref gene for this treat(subgroup)
      df.sub <- df %>%
        dplyr::filter(gene %in% c(genes, ref.gene))# when there is only one target gene, this step does not do anything
      
      # MOCK-HOUSEKEEPING
      df.sub.ck.ref.gene <- df.sub %>%
        dplyr::filter(gene == ref.gene, group == ref.group)
      mean.ck.ref.gene <- mean(df.sub.ck.ref.gene$cq)
      #MOCK-SIRT
      df.sub.ck.target.gene <- df.sub %>%
        dplyr::filter(gene != ref.gene & group == ref.group)
      mean.ck.target.gene <- mean(df.sub.ck.target.gene$cq)
      
      dct1 <- mean.ck.target.gene - mean.ck.ref.gene #MOCK delta1
      #################################
      # for each treatment
      for (groups in unique(df.sub$group)) {
        df.sub.group <-
          df.sub %>%
          dplyr::filter(group == groups) %>%
          dplyr::select(biorep, gene, cq) %>%
          dplyr::group_by(gene, biorep) %>%
          dplyr::mutate(cq = mean(cq)) %>%
          dplyr::ungroup() %>%
          dplyr::distinct_all() %>%
          tidyr::pivot_wider(
            id_cols = "biorep",
            names_from = "gene",
            values_from = "cq"
          ) %>%
          dplyr::mutate(dct1 = dct1)
        
        # including ref gene or not
        if (ncol(df.sub.group) == 3 &
            !genes %in% colnames(df.sub.group)) {
          stop(
            paste0(
              "Data of target gene ",
              genes,
              " has some problem, please check it and try again!"
            )
          )
        }
        if (colnames(df.sub.group)[3] == ref.gene) {
          df.sub.group %>%
            magrittr::set_names(c("biorep", "Target", "Reference", "ddct1")) %>%
            dplyr::mutate(
              dct = (Target - Reference),
              dct2 = (Target - Reference - dct1) ,
              expression = 2 ^ (-(Target - Reference - dct1))
            ) %>% ##? ddct1 is the MOCK
            dplyr::mutate(group = groups,
                          gene = genes,
                          time = times) %>%
            dplyr::select(group, gene, biorep, dct, dct2, expression, time) %>%
            rbind(res.all) -> res.all
        }
      }
    }
  }
  ######################################
  # group and mean and sd
  res.all %>%
    dplyr::group_by(group, gene, time) %>%
    dplyr::mutate(
      mean.expression = mean(expression),
      sd.expression = stats::sd(expression),
      n.biorep = dplyr::n(),
      se.expression = mean.expression / sqrt(n.biorep) ,
      mean.dct2 = mean(dct2),
      sd.dct2 = stats::sd(dct2),
      se.dct2 = mean.dct2 / sqrt(n.biorep)
    ) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(temp = paste0(group, time),
                  Log2FC = log2(expression)) -> res.all
  
  # statistics
  #if (stat.method == "t.test") {
  res.all %>%
    dplyr::group_by(time) %>%
    #rstatix::t_test(expression ~ group, ref.group = ref.group ) %>%
    rstatix::t_test(Log2FC ~ group, ref.group = ref.group) %>% #using logfc to text
    # print(n=30) # %>%
    dplyr::ungroup() %>%
    dplyr::select(time, group2, p) %>%
    dplyr::mutate(
      signif = dplyr::case_when(
        p <= 0.001 ~ "***",
        p > 0.001 & p <= 0.01 ~ "**",
        p > 0.01 & p <= 0.05 ~ "*",
        TRUE ~ "NS"
      )
    ) %>%
    dplyr::add_row(group2 = ref.group,
                   p = NA,
                   signif = NA) %>%
    dplyr::rename(group = group2) %>%
    dplyr::mutate(temp = paste0(group, time)) %>%
    dplyr::select(temp, signif) -> df.stat
  
  res.all <- res.all %>%
    dplyr::left_join(df.stat, by = "temp")
  # }
  #res.all %>% mutate(Log2FC = log2(expression)) ->res.all
  
  # plot
  df.plot <- res.all %>%
    dplyr::rename(
      Treatment = group,
      gene = gene,
      time = time,
      expre = expression,
      mean.expre = mean.expression,
      sd.expre = sd.expression,
      se.expre = se.expression,
      n = n.biorep
    )
  
  ##Plot##
  
  df.plot %>%
    dplyr::group_by(Treatment, time) %>%
    #dplyr::mutate(max.temp = max(expre)) %>%
    dplyr::mutate(max.temp = max(Log2FC)) %>%
    dplyr::ungroup() %>%
    ####Using FC as Y
    # ggplot2::ggplot(ggplot2::aes(Treatment, mean.expre / n, fill = Treatment)) +
    # ggplot2::geom_errorbar(ggplot2::aes(Treatment,
    #                                     ymin = mean.expre - sd.expre,
    #                                     ymax = mean.expre + sd.expre), width = 0.2)+
    # ggplot2::geom_jitter(ggplot2::aes(Treatment, expre), width = 0.1, alpha = 0.4) +
    # ggplot2::labs(y = "Relative expression",x=NULL) +
    ###Using log2 as Y
    # ggplot2::ggplot(ggplot2::aes(x= factor( Treatment,levels = Myorder), y=Log2FC/n , fill = Treatment,label=time)) + #Optional LOG2 as Y axis
    ggplot2::ggplot(ggplot2::aes(x = factor(time),y = Log2FC ,fill = temp)) + ###Why FoldFC/n??
    #ggplot2::geom_bar(stat = "identity",alpha = 0.8,width = 0.3) +
    ggplot2::geom_bar(stat = "summary", fun = "mean",alpha = 0.8,width = 0.3) + #the sum of LogFC/n (the positive ones)
    ggplot2::geom_errorbar(ggplot2::aes(time,ymin = -(mean.dct2 - sd.dct2),ymax = -(mean.dct2 + sd.dct2)), width = 0.2) +
    ggplot2::geom_jitter(ggplot2::aes(time, Log2FC),width = 0.1,alpha = 0.4) +
    ggplot2::labs(y = "Log2FoldChange",
                  #title=paste0("Plot of ",genes),
                  x = NULL) +
    #geom_hline(yintercept=c(-0.3325,0.1925,0.2375), linetype="dashed", color = "red")+
    #geom_hline(yintercept=c(-0.1108333,0.1433333), linetype="dashed", color = "green")+ 
    #ggplot2::geom_hline(ggplot2::aes(yintercept = max.temp * 1.1), color = NA) +
    ggplot2::scale_x_discrete(limits = Myorder) +
    #scale_y_continuous( expand = c(0,0))+
    ggplot2::facet_wrap(. ~ factor(Treatment, levels = Grouporder),
                        switch = "x",
                        nrow = fig.nrow) + #scales = "free_y",
    #ggplot2::geom_text(position = position_dodge(width = 1), aes(x=time, y=0)) +
    ggplot2::geom_text(ggplot2::aes(time, 1.5, label = signif),check_overlap = TRUE,color = "firebrick" ) + #,size = 5
    #ggplot2::scale_fill_brewer(palette="Set1")+
    
    ggplot2::theme_bw() +
     #ggthemes::theme_pander() +
    ggplot2::theme(
      legend.position = "none",
      #panel.grid.major.y = element_blank(),
      panel.grid.major.x = element_blank(),
      strip.background = element_rect(color = "black",fill = "aliceblue",size = 1.5,linetype = "solid"),
      strip.text.x = ggplot2::element_text(face = "italic")
    )  -> p
  
  res <- list(table = df.plot, figure = p)
  return(res)
}
