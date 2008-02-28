From: Michal Soltys <soltys@ziu.info>
Subject: Re: how to use mkfs.ext3 "stride=" on LVM on RAID correctly?
Date: Thu, 28 Feb 2008 20:23:51 +0100
Message-ID: <47C70A47.3090907@ziu.info>
References: <47C68101.4020406@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47C68101.4020406@wpkg.org>
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: Linux-Raid <linux-raid@vger.kernel.org>, LVM general discussion and development <linux-lvm@redhat.com>
List-Id: linux-raid.ids

Tomasz Chmielewski wrote:

> Although the fine mkfs.ext3 manual gives some basic information on how 
> to do it if you place the whole filesystem on a RAID array, it is not 
> clear to me how it should be done correctly if I want to create a ext3 
> filesystem on LVM on RAID-5.
> 
> Any helpful hints?

You should be careful with all the alignemnts. Extents should be properly 
aligned with - at the very least - stripes, and preferably with whole stripe 
width (not always possible though). To check where lvm extents, you can use 
i.e.:

dmsetup table
pvs -o+pe_start --units s
losetup and hexedit experiments (silly, but I used to do it like that in the 
past, before I realised about other options :o )

If you don't need default 4M granularity, it's nice to increase it (vgcreate 
-s option ; I use 256M and 512M sized extents). You can alter the beginning 
of the extents with --metadatasize option of pvcreate (overally it always 
rounds up to the next 64K multiple). Be sure to verify with one of the 
commands above.

Moreover - if you use partitionable raid and create lvm in one of the 
partitions, make sure partition is properly aligned as well.

