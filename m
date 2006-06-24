From: Adam Talbot <talbotx@comcast.net>
Subject: Re: Large single raid and XFS or two small ones and EXT3?
Date: Sat, 24 Jun 2006 00:59:12 -0700
Message-ID: <449CF0D0.9080006@comcast.net>
References: <449AEB7C.6040108@cjx.com>	<op.tblclqd3cigqcu@apollo13>	<fd8d0180606230226w10b1982ay2916805d9aa0e3bb@mail.gmail.com>	<449BE381.6070000@cjx.com>	<fd8d0180606230630x3f6b1ab7g444716cf8d5ab2c2@mail.gmail.com>	<68c491a60606230746m5c1f0301g8e00fdd4f0e0739b@mail.gmail.com>	<449C0505.8000601@tmr.com>	<fd8d0180606230834t18427168jd776d33980f516b2@mail.gmail.com> <17564.52087.651968.635043@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17564.52087.651968.635043@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Francois Barre <francois.barre@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

OK, this topic I relay need to get in on.
I have spent the last few week bench marking my new 1.2TB, 6 disk, RAID6
array. I wanted real numbers, not "This FS is faster because..." I have
moved over 100TB of data on my new array running the bench mark
testing.  I have yet to have any major problems with ReiserFS, EXT2/3,
JFS, or XFS.  I have done extensive testing on all, including just
trying to break the file system with billions of 1k files, or a 1TB
file. Was able to cause some problems with EXT3 and RiserFS with the 1KB
and 1TB tests, respectively. but both were fixed with a fsck. My basic
test is to move all data from my old server to my new server
(whitequeen2) and clock the transfer time.  Whitequeen2 has very little
storage.  The NAS's 1.2TB of storage is attached via iSCSI and a cross
over cable to the back of whitequeen2.  The data is 100GB of user's
files(1KB~2MB), 50GB of MP3's (1MB~5MB) and the rest is movies and
system backups 600MB~2GB.  Here is a copy of my current data sheet,
including specs on the servers and copy times, my numbers are not
perfect, but they should give you a clue about speeds...  XFS wins.

The computer: whitequeen2
AMD Athlon64 3200 (2.0GHz)
1GB Corsair DDR 400 (2X 512MB's running in dual DDR mode)
Foxconn 6150K8MA-8EKRS motherboard
Off brand case/power supply
2X os disks, software raid array, RAID 1, Maxtor 51369U3, FW DA620CQ0
Intel pro/1000 NIC
CentOS 4.3 X86_64 2.6.9
    Main app server, Apache, Samba, NFS, NIS

The computer: nas
AMD Athlon64 3000 (1.8GHz)
256MB Corsair DDR 400 (2X 128MB's running in dual DDR mode)
Foxconn 6150K8MA-8EKRS motherboard
Off brand case/power supply and drive cages
2X os disks, software raid array, RAID 1, Maxtor 51369U3, FW DA620CQ0
6X software raid array, RAID 6, Maxtor 7V300F0, FW VA111900
Gentoo linux. X86_64 2.6.16-gentoo-r9
   System built very lite, only built as an iSCSI based NAS.

NFS mount from whitequeen (old server) goes to /mnt/tmp
Target iSCSI to NAS, or when running on local NAS, is /data

Raw dump /dev/null (Speed mark, how fast is the old whitequeen, Read test)
Config=APP+NFS-->/dev/null
[root@whitequeen2 tmp]# time tar cf - . | cat - > /dev/null
real    216m30.621s
user    1m24.222s
sys     15m20.031s
3.6 hours @ 105371M/hour or 1756M/min or *29.27M/sec*

XFS
Config=APP+NFS-->NAS+iSCSI
RAID6 64K chunk
[root@whitequeen2 tmp]# time tar cf - . | (cd /data ; tar xf - )
real    323m9.990s
user    1m28.556s
sys     31m6.405s
/dev/sdb1             1.1T  371G  748G  34% /data
5.399 hours @ 70,260M/hour or 1171M/min or 19.52M/sec

    Pass 2 of XFS  (are my number repeatable?  Yes)
    real    320m11.615s
    user    1m26.997s
    sys     31m11.987s

XFS (Direct NFS connection, no app server, max "real world" speed of my
array?)
Config=NAS+NFS
RAID6 64K chunk
nas tmp # time tar cf - . | (cd /data ; tar xf - )
real    241m8.698s
user    1m2.760s
sys     25m9.770s
/dev/md/0             1.1T  371G  748G  34% /data
4.417 hours @ 85,880M/hour or 1.431M/min or *23.86M/sec*


EXT3
Config=APP+NFS-->NAS+iSCSI
RAID6 64K chunk
[root@whitequeen2 tmp]# time tar cf - . | (cd /data ; tar xf - )
real    371m29.802s
user    1m28.492s
sys     46m48.947s
/dev/sdb1             1.1T  371G  674G  36% /data
6.192 hours @ 61,262M/hour or 1021M/min or 17.02M/sec


EXT2
Config=APP+NFS-->NAS+iSCSI
RAID6 64K chunk
[root@whitequeen2 tmp]# time tar cf - . | ( cd /data/ ; tar xf - )
real    401m48.702s
user    1m25.599s
sys     30m22.620s
/dev/sdb1             1.1T  371G  674G  36% /data
6.692 hours @ 56,684M/hour or 945M/min or 15.75M/sec


JFS
Config=APP+NFS-->NAS+iSCSI
RAID6 64K chunk
[root@whitequeen2 tmp]# time tar cf - . | (cd /data ; tar xf - )
real    337m52.125s
user    1m26.526s
sys     32m33.983s
/dev/sdb1             1.1T  371G  748G  34% /data
5.625 hours @ 67,438M/hour or 1124M/min or 18.73M/sec


ReiserFS
Config=APP+NFS-->NAS+iSCSI
RAID6 64K chunk
[root@whitequeen2 tmp]# time tar cf - . | (cd /data ; tar xf - )
real    334m33.615s
user    1m31.098s
sys     48m41.193s
/dev/sdb1             1.1T  371G  748G  34% /data
5.572 hours @ 68,078M/hour or 1135M/min or 18.91M/sec


Word count
[root@whitequeen2 tmp]# ls | wc
66612  301527 5237755

Actule size = 379,336M
