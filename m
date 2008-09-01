From: "Michael Guyver" <michael.guyver@gmail.com>
Subject: Re: Create software RAID from active partition
Date: Mon, 1 Sep 2008 23:42:50 +0100
Message-ID: <c8ce53500809011542s539e3c82t45abb467968a511c@mail.gmail.com>
References: <c8ce53500809010532h5444a8cckcb1d2cb57d3dc281@mail.gmail.com>
	 <48BC4A7D.8020907@ziu.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48BC4A7D.8020907@ziu.info>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Michal Soltys <soltys@ziu.info>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2008/9/1 Michal Soltys <soltys@ziu.info>:
> What do:
>
> mdadm -E /dev/sda1
> mdadm -E /dev/sdb1
> mdadm -E /dev/sda2
> mdadm -E /dev/sdb2
>
> show, if anything ?
>

Hi Michal,

Each device reports the same as /dev/sdb1:

# mdadm -E /dev/sdb1
mdadm: No md superblock detected on /dev/sdb1.

I think there might be a more subtle problem - the disks /dev/sda2 and
/dev/sdb2 appear to have the same UUID. I'm not sure of the
significance at present and am going to have to do a bit more
investigation, but it is enough to prevent

pvcreate /dev/sda2

from working - unless I specify the -ff flag as an additional
parameter, which I am loathe to try without understanding what might
happen. I was working towards creating an lvm-mirror following some
earlier advice in this thread, and found this problem when using
system-config-lvm. The GUI shows /dev/sda2 as uninitialised and the
error occurs when trying to initialise it. Any further advice would be
gratefully received (although I appreciate that this is the
linux-raid, not linux-lvm group)!

Best wishes and thanks for your suggestions.

Michael
