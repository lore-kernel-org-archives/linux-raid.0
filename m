From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 00/18] Assorted md patches headed for 2.6.30
Date: Fri, 13 Mar 2009 12:00:41 +1100
Message-ID: <18873.45113.361716.757996@notabene.brown>
References: <7554605.886551236670855947.JavaMail.coremail@bj163app40.163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from linux-jay on Tuesday March 10
Sender: linux-raid-owner@vger.kernel.org
To: linux-jay <linux-jay@163.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Yuri Tikhonov <yur@emcraft.com>, Wolfgang Denk <wd@denx.de>, dzu@denx.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> hi neil:
> I get your the latest patches (v2.6.29-rc5-335-g0ac4ee7) from git://neil.brown.name/md.
> I want to test the function that switch raid from raid5 to raid6.
> But find some problem.
> I create a raid6 which has 4 disks,and write some files to this raid6 ,next,i remove two of them.
> if this raid6 is ok,now i can read the files that i have written correctly.
> but in fact that i can't read the files ok.maybe there is some error about raid6 in v2.6.29-rc5-335-g0ac4ee7.
> 
> 
> Steps i have done are as follows
> 1, mdadm -C /dev/md6 -l 6 -n 4 /dev/sda /dev/sdb /dev/sdc /dev/sdd --metadata=1.0 --size=1000000 -f
> 2, pvcreate /dev/md6
> 3, vgcreate md6vg /dev/md6
> 4, lvcreate -L 200M -n md6lv md6vg
> 5, mkfs.xfs /dev/mapper/md6vg-md6lv
> 6, mount /dev/mapper/md6vg-md6lv /tmp     (is ok)
> 
> 7, mdadm -f /dev/md6 /dev/sda /dev/sdb  (faulty two disks)
> 8, mount /dev/mapper/md6vg-md6lv /tmp   (now can't read the filesystem information correctly)
> (mount: Structure needs cleaning) (print this )
>  
> thanks neil ,right here waiting for your help !

Thanks for reporting this.  There must be something broken in the
changes to raid6 to support hardware-offload of the calculations.

If you try my 'md-scratch' branch it might work better.  It has all
the code for raid level conversion, but none of the raid6 rework.

NeilBrown
