From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: No response?
Date: Thu, 20 Jan 2005 20:24:47 +0100
Message-ID: <v4d5c2-2sq.ln1@news.it.uc3m.es>
References: <Pine.LNX.4.58.0501201052240.19586@lewis.et.byu.edu> <csotcs$oma$1@sea.gmane.org> <Pine.LNX.4.58.0501201142140.19586@lewis.et.byu.edu>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Dougall <davidd@et.byu.edu> wrote:
> Jan 10 11:56:06 linux-sg2 kernel: SCSI disk error : host 0 channel 0 id 0
> lun 47
>  return code = 8000002

That is sda.

> Jan 10 11:56:08 linux-sg2 kernel:  I/O error: dev 08:10, sector 343219280

Well, I don't really understand - that is sdb, no? No? (or sda10 if the
numbers are in decimal instead of hex).

I don't know why sda and sdb seem to be confused! The "lun 47" also has
me wondering!

> Jan 10 11:56:08 linux-sg2 kernel: Info fld=0xc7c0181, Current sd08:10:
> sense key
>  Hardware Error
> Jan 10 11:56:08 linux-sg2 kernel:  I/O error: dev 08:10, sector 392

sdb, very insistently, at a completely different sector. Looks belly
up.

> Jan 10 11:56:08 linux-sg2 kernel: SCSI disk error : host 0 channel 0 id 0
> lun 47
>  return code = 8000002

But 0:0:0 should be sda!

> Jan 10 11:56:08 linux-sg2 kernel:  I/O error: dev 08:10, sector 209453441
> Jan 10 11:56:08 linux-sg2 kernel: I/O error in filesystem
> ("device-mapper(254,1)
> ") meta-data dev device-mapper(254,1) block 0x18fa318f
> ("xlog_iodone") err
> or 5 buf count 2048
> Jan 10 11:56:08 linux-sg2 kernel:
> xfs_force_shutdown(device-mapper(254,1),0x2) c
> alled from line 966 of file xfs_log.c.  Return address = 0xc0246d9b
> Jan 10 11:56:08 linux-sg2 kernel: Filesystem "device-mapper(254,1)": Log
> I/O Err
> or Detected.  Shutting down filesystem: device-mapper(254,1)
> Jan 10 11:56:08 linux-sg2 kernel: Please umount the filesystem, and
> rectify the
> problem(s)
> 
> 
> I don't see any error messages from md in any of these logs.

Why is the device mapper implicated? Doesn't that mean that you are
using LVM and not raid? 2.4.26, you said? Hmm.

Peter

