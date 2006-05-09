From: Luca Berra <bluca@comedia.it>
Subject: Re: strange RAID5 problem
Date: Tue, 9 May 2006 07:58:25 +0200
Message-ID: <20060509055824.GB22085@percy.comedia.it>
References: <4460290C.50202@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4460290C.50202@harddata.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, May 08, 2006 at 11:30:52PM -0600, Maurice Hilarius wrote:
>[root@box ~]# mdadm /dev/md3 -a /dev/sdw1
>
>But, I get this error message:
>mdadm: hot add failed for /dev/sdw1: No such device
>
>What? We just made the partition on sdw a moment ago in fdisk. It IS there!

I don't believe you, prove it (/proc/partitions)

>So. we look around a bit:
># /cat/proc/mdstat
>
>md3 : inactive sdq1[0] sdaf1[15] sdae1[14] sdad1[13] sdac1[12] sdab1[11]
>sdaa1[10] sdz1[9] sdy1[8] sdx1[7] sdv1[5] sdu1[4] sdt1[3] sds1[2]
>sdr1[1]
>      5860631040 blocks
>
>Yup, that looks correct, missing sdw1[6]

no, it does not, it is 'inactive'

>[root@box ~]# cat /proc/mdstat
>Personalities : [raid1] [raid5]
...
>md3 : inactive sdq1[0] sdaf1[15] sdae1[14] sdad1[13] sdac1[12] sdab1[11]
>sdaa1[10] sdz1[9] sdy1[8] sdx1[7] sdv1[5] sdu1[4] sdt1[3] sds1[2]
>sdr1[1]
>      5860631040 blocks
...
>[root@box ~]# mdadm /dev/md3 -a /dev/sdw1
>mdadm: hot add failed for /dev/sdw1: No such device
>
>OK, let's mount the degraded RAID and try to copy the files to somewhere
>else, so we can make it from scratch:
>
>[root@box ~]# mount /dev/md3 /all/boxw16/
>/dev/md3: Invalid argument
>mount: /dev/md3: can't read superblock
>
it is still inactive, no wonder you cannot access it.

try running the array, or really stop it before assembling.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
