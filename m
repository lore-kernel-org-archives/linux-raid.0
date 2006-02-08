From: Richard Mittendorfer <delist@gmx.net>
Subject: Re: mdraid0 worries on 2.6
Date: Wed, 8 Feb 2006 15:26:26 +0100
Message-ID: <20060208152626.5dd2f601.delist@gmx.net>
References: <20060207011220.711e2424.delist@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060207011220.711e2424.delist@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Also sprach Richard Mittendorfer <delist@gmx.net> (Tue, 7 Feb 2006
01:12:20 +0100):
> Hi,
> 
> I do have _great_ performance troubles with software raid0 with 2.6.12
> to .15. I have not tried earlier 2.6's, but 2.4 (tested up to 2.4.24)
> do it right.
> 
> In fact, mdraid0 over 2 rather old 9G scsi disks here in my home
> server show same throughput as a single drive. I did try to tune
> readahead, tune various proc settings, used reiserfs and xfs or mdadm
> with different
> settings -- nothing helped. I'm clueless.

Looks like you're right. First, I didn't messure right: My fault was to
use to small testfiles and so messured RAM also. No wonder I came above
20MB/sec. Here are bonnie++(v1.03) results on xfs and reiserfs over a
raid0 [sda|sdb]. I did no tuning of drive/mount parameters or VM with
2.4.

hdparm -tT
2.4.32 disks:
/dev/sdb  364MB in 2.01 sec =    181 MB/sec
           44MB in 3.14 sec =  14.01 MB/sec
/dev/sdc  360MB in 2.01 sec = 179.10 MB/sec
           44MB in 3.12 sec =  14.10 MB/sec
/dev/md4  352MB in 2.01 sec = 175.12 MB/sec
           44MB in 3.02 sec =  14.57 MB/sec

2.6.15 disks: (see above)

2.4.23 mem=256M / bonnie++ -s 512M
reiserfs (no mountoptions):
cell,512M,5686,88,21261,46,7710,10,5508,79,16705,9,342.4,3,
     16,3609,92,+++++,+++,6894,99,3727,95,+++++,+++,5054,88
xfs (logbufs=8)
cell,512M,6668,96,23106,25,7807,9,5468,79,16902,9,295.7,3,
     16,1170,57,+++++,+++,1410,48,1123,54,+++++,+++,758,36

2.4.23 mem=128M / bonnie++ -s 512M
reiserfs (no mountoptions)
cell,512M,6107,95,19152,41,8097,10,5815,84,16976,10,237.9,2,
     16,5710,94,+++++,+++,6884,99,5804,97,+++++,+++,5091,88
xfs (logbufs=8)
cell,512M,6716,97,19943,21,8145,9,5809,83,17167,9,209.9,2,
     16,898,44,+++++,+++,1523,54,863,44,+++++,+++,936,38

When testing with RAM*4 files it shows that it (the HBA) can't deliver
more than 20MB/sec. While I saw 25MB/sec (like the 23MB/sec seq.read
above), it just was due to bad messurement with RAM*2 files (which
didn't show up on 2.6 btw.).

2.6.15-cks3 mem=128M / bonnie++ -s 512M
reiserfs (notail,noatime)
cell,512M,9134,98,18200,32,8924,13,10224,99,18583,17,238.1,3,
     16,5369,99,+++++,+++,6301,95,5197,100,+++++,+++,5443,100
xfs (logbufs=8)
cell,512M,9432,97,19480,25,8376,13,10914,97,18600,18,208.9,3,
     16,854,38,+++++,+++,1257,40,830,38,+++++,+++,735,30

sorry for the noise
 
ritch
