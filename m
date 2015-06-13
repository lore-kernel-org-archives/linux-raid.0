From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: seagate-"archive"-disks with raid6?
Date: Sat, 13 Jun 2015 17:20:03 +0100
Message-ID: <557C5833.40708@youngman.org.uk>
References: <557C5330.1090605@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <557C5330.1090605@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: wiebittewas <wiebittewas@googlemail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 13/06/15 16:58, wiebittewas wrote:
> hi.
> 
> for a larger archive, we're thinking about buying six 8TB-Archive-Disks from Seagate to build a 4+2 Raid6-Array.
> 
> now we've seen, that these disks are told not-recommended for raid, because they lack ERC/TLER (like many desktop-disks)
> 
> unfortunately we didn't found any real actual information about behaviour of linux-raid with such disks.
> 
> so our first questions is, if anyone here already has disks (without ERC/TLER) with linux-raid running and can say something about?
> 
I'm running two Seagate Barracuda disks in Raid-1. That, I believe is
okay. I've never had any problem, but the disks are pretty new...
> 
> other item is, - as we understand - ERC leads to a limited timeout on read-errors, so the wanted data of that read-access may recovered by the redundant data and marks that disk for soon replace (or a sync to an existant spare is started).
> 
> but this is also done, if that disk does not timeout and will be dropped by the controller, or is this wrong?
> 
This is right. 6 by 8TB is 48TB of disk. If the disk spec is standard,
it says "expect one soft error per 10TB read", so a rebuild will get
FIVE errors.

If you don't do anything special, each error will kick a disk out of the
array ... OOPS !!!

> so the only benefit seems to be, that with ERC the disk is not dropped immediately, so errors on two further disks won't lead to a data-loss before sync (as long the additional errors are not corresponding raid-sectors)
> 
> but: how likely is it, that three disks have permamnent errors during the sync? (we already had two disks in the past, but never three at a time...)
> 
> how is your experience with multiple disk-errors?
> 
No experience here, but I'm planning to upgrade to raid 5 or 6, so I've
been mugging up on it.

You need to increase the raid timeout, so the disk times out before the
raid does. That's why you really need ERC, so you can make the disk time
out before the raid does.

Cheers,
Wol

