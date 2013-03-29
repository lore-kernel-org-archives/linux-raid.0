From: Phil Turmel <philip@turmel.org>
Subject: Re: Degraded Raid 5 Assembles incorrectly(maybe), will not mount
Date: Thu, 28 Mar 2013 22:55:47 -0400
Message-ID: <515502B3.4060301@turmel.org>
References: <W9578124347167971364495965@atl4webmail34>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <W9578124347167971364495965@atl4webmail34>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Macica <macica@prospecteng.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Steve,

On 03/28/2013 02:39 PM, Steve Macica wrote:
> Hello Linux-Raid,
> 
> I have a degraded Raid 5 that I can't mount. I think it may be
> assembling in the wrong order. I've tryed stopping the array and
> reassembling but it does not work. The data presented below is taken
> after a system reboot. I'm at the point where I think I need use the
> creat command on a dregraded system(which I assume will preserve the
> data) but I'm hoping there may be less drastick things that can be
> tried first. Any suggestions??

Do *not* use mdadm --create.  See below.

> Thanks in advance.
> 
> History:

> Had an Ubuntu 8.10 system working with a Raid 5 system consisting of
> four HDDs and comfigured with mdadm. I lost one of the drives in the
> Raid. The system continued to work in degraded mode.  I had not
> recovered or added a new drive to the Raid5 yet and lost the OS
> drive(which in this case is a completely different HDD). I loaded
> Ubuntu 12.10 on a new drive and  I can not mount the degraded Raid 5
> array(missing one drive).

> sudo mount /dev/md0 raidmount
> mount: wrong fs type, bad option, bad superblock on /dev/md0,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so

Please show your "dmesg" output.  I don't see any indication you
followed mount's suggestion here.  (If you don't see anything obviously
useful, repeat your "mount" attempt then send the entire dmesg.)

> /proc/mdstat
> Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0]
[raid1] [raid10]
> md0 : active raid5 sdc1[2] sdb1[3] sda1[0]
>       1465151808 blocks level 5, 32k chunk, algorithm 2 [4/3] [U_UU]

Your array, while degraded, is running.  Any attempt to use "mdadm
--create" cannot do any better.  You need to find out what happened to
your filesystem, or your filesystem driver.

In addition to your dmesg, please also show the output of "blkid" and/or
"lsdrv" [1]

Phil

[1] http://github.com/pturmel/lsdrv
