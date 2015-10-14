From: "Daniel J. R. May" <daniel.may@kada-media.com>
Subject: Re: mdadm RAID 5 reshape not working
Date: Wed, 14 Oct 2015 21:37:13 +0100
Message-ID: <1444855033.3967.23.camel@kada-media.com>
References: <1444850463.3967.19.camel@kada-media.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1444850463.3967.19.camel@kada-media.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2015-10-14 at 20:21 +0100, Daniel J. R. May wrote:
> I attempted to add a disk to an mdadm RAID 5 array with the
> following:
> 
> mdadm --manage /dev/md1 --add /dev/sdf1
> mdadm --grow --raid-devices=5 --backup-file=/root/md1-grow.bak
> /dev/md1
> 
> These command gave no errors, but although mdadm reports that the
> array
> is reshaping it does not seem to have done anything after a couple of
> hours:

Having hunted around on this mailing list I see that this is a pretty
common problem. I was able to get my reshape going by issuing:

mdadm --grow --continue --backup-file=/root/md1-grow.bak /dev/md1

So we're now off and running!

[root@sulphur ~]# cat /proc/mdstat 
Personalities : [raid6] [raid5] [raid4] 
md1 : active raid5 sdf1[5] sde1[4] sdb1[0] sdd1[2] sdc1[1]
      11720656896 blocks super 1.2 level 5, 512k chunk, algorithm 2
[5/5] [UUUUU]
      [>....................]  reshape =  0.3% (15161292/3906885632)
finish=1270.9min speed=51032K/sec
      bitmap: 0/30 pages [0KB], 65536KB chunk

Best wishes,

Dan
