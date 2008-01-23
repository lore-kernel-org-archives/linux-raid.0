From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Fwd: Error on /dev/sda, but takes down RAID-1
Date: Wed, 23 Jan 2008 21:35:32 +0300
Message-ID: <479788F4.6090308@msgid.tls.msk.ru>
References: <15672009.1331201100742126.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15672009.1331201100742126.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Seebach <mail@martinseebach.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Martin Seebach wrote:
> Hi, 
> 
> I'm not sure this is completely linux-raid related, but I can't figure out where to start: 
> 
> A few days ago, my server died. I was able to log in and salvage this content of dmesg: 
> http://pastebin.com/m4af616df 
> 
> I talked to my hosting-people and they said it was an io-error on /dev/sda, and replaced that drive. 
> After this, I was able to boot into a PXE-image and re-build the two RAID-1 devices with no problems - indicating that sdb was fine. 
> 
> I expected RAID-1 to be able to stomach exactly this kind of error - one drive dying. What did I do wrong? 

from that pastebin page.

First, sdb has failed for whatever reason:

ata2.00: qc timeout (cmd 0xec)
ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
ata2.00: revalidation failed (errno=-5)
ata2.00: disabled
ata2: EH complete
sd 1:0:0:0: SCSI error: return code = 0x00040000
end_request: I/O error, dev sdb, sector 80324865
raid1: Disk failure on sdb1, disabling device.
        Operation continuing on 1 devices
RAID1 conf printout:
 --- wd:1 rd:2
 disk 0, wo:0, o:1, dev:sda1
 disk 1, wo:1, o:0, dev:sdb1
RAID1 conf printout:
 --- wd:1 rd:2
 disk 0, wo:0, o:1, dev:sda1

At this time, it started to (re)sync other(?) arrays for
some reason:

md: syncing RAID array md0
md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for reconstruction.
md: using 128k window, over a total of 40162432 blocks.
md: md0: sync done.
RAID1 conf printout:
 --- wd:1 rd:2
 disk 0, wo:0, o:1, dev:sda1
md: syncing RAID array md1
md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for reconstruction.
md: using 128k window, over a total of 100060736 blocks.

Note again, errors on sdb:

sd 1:0:0:0: SCSI error: return code = 0x00040000
end_request: I/O error, dev sdb, sector 112455000
sd 1:0:0:0: SCSI error: return code = 0x00040000
end_request: I/O error, dev sdb, sector 112455256
sd 1:0:0:0: SCSI error: return code = 0x00040000
end_request: I/O error, dev sdb, sector 112455512
...

raid1: Disk failure on sdb3, disabling device.
        Operation continuing on 1 devices

so another md array detected sdb failure.  So we're
with sda only.  And volia, sda fails too, some time
later:

ata1: EH complete
sd 0:0:0:0: SCSI error: return code = 0x00040000
end_request: I/O error, dev sda, sector 80324865
sd 0:0:0:0: SCSI error: return code = 0x00040000
end_request: I/O error, dev sda, sector 115481
...

At this point, the arrays are hosed - all disks
of each array has failed, there's no data any
more to read/write from/to.

Since later sda has been replaced, and sdb recovered
from the errors (it contains still-valid superblocks
but with somewhat stale information), everything
went ok.

But the original problem is that you had BOTH disks
failed, not only one.  What caused THIS problem is
another question.  Maybe some overheating or power
unit problem or somesuch, -- I don't know...  But
md code worked the best it can here.

/mjt
