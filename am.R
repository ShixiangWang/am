#!/usr/bin/env Rscript

if (!requireNamespace("ps")) {
  cat("install required packages 'ps'\n", file = "~/.am.log", append = TRUE)
  install.packages("ps")
}

args = commandArgs(trailingOnly = TRUE)

percent = ps::ps_system_memory()$percent

if (length(args) > 0) {
  th = as.numeric(args)[1]
  if (percent > th) {
    pn = ps::ps()
    pid = pn$pid[which.max(pn$rss)]
    cat("try kill the process with maximum memory use\n", file = "~/.am.log", append = TRUE)
    tryCatch(
      ps::ps_kill(ps::ps_handle(pid = pid)),
      error = function(e) {
        cat("Error: kill failed due to following reason\n", file = "~/.am.log", append = TRUE)
        cat(e$message, "\n", file = "~/.am.log", append = TRUE)
      }
    )
  } else {
    cat("done nothing in this check\n", file = "~/.am.log", append = TRUE)
  }

} else {
  cat("Error: no memory limit has been set\n", file = "~/.am.log", append = TRUE)
}
