library("RSKC")
library("R.matlab")

# srcpath <- "/Users/phan/Git/CmlConfClus/src/test5/clusters/"
srcpath <- "/home/miv/phan/Git/CmlConfClus/src/test5/clusters/" # on natterer
fo <- "clu7"
res <- array(0,dim=c(9,9,16)) # intialize cer results

for(isnr in 1:8){
	fsnr <- paste("snr",toString(isnr),sep="")
	for(idiv in 1:9){
		fdiv <- paste("div",toString(idiv),sep="")
		for(it in 1:16){
			fit <- paste("T",toString(it),sep="")
			fn <- paste(srcpath,fo,fsnr,fdiv,fit,".txt",sep="")
			data <- scan(fn)
			d <- matrix(data, nrow=2,byrow=TRUE)
			res[isnr,idiv,it] <- CER(d[1,],d[2,])
		}
	}
}

# outpath <- "/Users/phan/Git/CmlConfClus/src/test5/cer/cer.mat"
outpath <- "/home/miv/phan/Git/CmlConfClus/src/test5/cer/cer.mat" # on natterer
writeMat(outpath,CER=res)
