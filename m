From: Sander Smeenk <ssmeenk@freshdot.net>
Subject: Re: Data corruption on software raid.
Date: Sun, 18 Mar 2007 18:38:49 +0100
Message-ID: <20070318173849.GM6063@freshdot.net>
References: <20070318131606.GJ6063@freshdot.net> <Pine.LNX.4.64.0703180959090.32397@p34.internal.lan> <45FD6DCF.3040300@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <45FD6DCF.3040300@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Quoting Bill Davidsen (davidsen@tmr.com):

> >>I'm having an odd problem with using software raid on two Western
> >>Digital disks type WD2500JD-00F (250gb) connected to a Silicon Image
> >>Sil3112 PCI SATA conroller running with Linux 2.6.20, mdadm 2.5.6
> Your comments below are thoughts on the PATA RAID1, not the one which is 
> giving trouble, the SATA.

Although your comment here is right, i was indeed questioning about the
SATA disks, Justin did make me realise i forgot to check SMART status
with smartctl.

It turns out sdb is a bit dodgy. It aparently had a read error earlier,
and during the 'long' SMART test just now, it also failed.
But this still amazes me, as i ran 'mke2fs -c -c' on the disk AND copied
about 95% of the disks capacity to it with no corruption or errors at all.

I don't know if i completely understood your comments about user buffers.
I can hardly believe the buffer to change it's contents before actually
being written to disk? Or did i misunderstand?

Regards,
Sander.
-- 
| When she saw her first strands of gray hair, she thought she'd dye.
| 1024D/08CEC94D - 34B3 3314 B146 E13C 70C8  9BDB D463 7E41 08CE C94D
