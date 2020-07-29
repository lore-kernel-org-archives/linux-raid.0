From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Linux RAID with btrfs stuck and consume 100 % CPU
Date: Wed, 29 Jul 2020 15:48:41 -0600
Message-ID: <CAJCQCtQAHr91wEwvFmh_-UB3Cd3UecSjjy6w7nOeqUktrn4UzQ@mail.gmail.com>
References: <d3fced3f-6c2b-5ffa-fd24-b24ec6e7d4be@xmyslivec.cz> <a070c45a-0509-e900-e3f3-98d20267c8c9@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a070c45a-0509-e900-e3f3-98d20267c8c9@cloud.ionos.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Cc: Vojtech Myslivec <vojtech@xmyslivec.cz>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Linux-RAID <linux-raid@vger.kernel.org>, Michal Moravec <michal.moravec@logicworks.cz>, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

On Wed, Jul 29, 2020 at 3:06 PM Guoqing Jiang
<guoqing.jiang@cloud.ionos.com> wrote:
>
> Hi,
>
> On 7/22/20 10:47 PM, Vojtech Myslivec wrote:
> > 1. What should be the cause of this problem?
>
> Just a quick glance based on the stacks which you attached, I guess it
> could be
> a deadlock issue of raid5 cache super write.
>
> Maybe the commit 8e018c21da3f ("raid5-cache: fix a deadlock in superblock
> write") didn't fix the problem completely.  Cc Song.

That references discards, and it make me relook at mdadm -D which
shows a journal device:

       0     253        2        -      journal   /dev/dm-2

Vojtech, can you confirm this device is an SSD? There are a couple
SSDs that show up in the dmesg if I recall correctly.

What is the default discard hinting for this SSD when it's used as a
journal device for mdadm? And what is the write behavior of the
journal? I'm not familiar with this feature at all, whether it's
treated as a raw block device for the journal or if the journal
resides on a file system. So I get kinda curious what might happen
long term if this is a very busy file system, very busy raid5/6
journal on this SSD, without any discard hints? Is it possible the SSD
runs out of ready-to-write erase blocks, and the firmware has become
super slow doing erasure/garbage collection on demand? And the journal
is now having a hard time flushing?


-- 
Chris Murphy
