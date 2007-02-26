From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: beginner error detection
Date: Mon, 26 Feb 2007 15:24:56 +0100
Message-ID: <eruqjo$nvi$2@sea.gmane.org>
References: <Pine.LNX.4.64.0702231301180.3550@tomka.hu>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tomka Gergely <gergely@tomka.hu> wrote:
> Can the raid1 detect and handle disk errors?

This is what it is designed for :)

> If one block goes wrong, how 
> can the raid1 driver choose which was the correct, original value?

RAID1 depends on the disk to state errors. RAID1 does not ensure data
integrity. RAID1 cannot correctly handle a disk returning wrong data
(i.e. other data than written before). Only RAID2 is designed for such.
However, since todays disks have their own data integrity detection
(i.e. ECC), they should normally not return wrong data but read-errors
instead.

And assuming a drive returns either correct data or a read-error, it is
simple to choose which was the correct, original value :)


regards
   Mario
-- 
> As Luke Leighton said once on samba-ntdom, "now, what was that about
> rebooting?   that was so long ago, i had to look it up with man -k."

