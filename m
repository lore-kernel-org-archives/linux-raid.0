From: Neil Brown <neilb@suse.de>
Subject: Re: with the latest mdadm
Date: Tue, 7 Feb 2006 20:23:46 +1100
Message-ID: <17384.26402.724978.284042@cse.unsw.edu.au>
References: <43E86468.8030508@bppiac.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Farkas Levente on Tuesday February 7
Sender: linux-raid-owner@vger.kernel.org
To: Farkas Levente <lfarkas@bppiac.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday February 7, lfarkas@bppiac.hu wrote:
> hi,
> with the latest mdadm-2.3.1 we've got the following message:
> -------------------------------------
> md: md4: sync done.
> RAID1 conf printout:
>  --- wd:2 rd:2
>  disk 0, wo:0, o:1, dev:sda2
>  disk 1, wo:0, o:1, dev:sdb2
> md: mdadm(pid 8003) used obsolete MD ioctl, upgrade your software to use
> new ictls.
> -------------------------------------
> this is just a warning or some kind of problem with mdadm?

This is with a 2.4 kernel, isn't it.

The md driver is incorrectly interpreting an ioctl that it doesn't
recognise as an obsolete ioctl.  In fact it is a new ioctl that 2.4
doesn't know about (I suspect it is GET_BITMAP_FILE).

The message should probably be removed from 2.4, but as 2.4 is in
deep-maintenance mode, I suspect that is unlikely....

NeilBrown

