From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: RAID SB 1.x autodetection
Date: Wed, 30 May 2007 22:55:46 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0705302254210.11140@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0705292036400.11140@yvahk01.tjqt.qr>
 <877iqqul7a.fsf@hades.wkstn.nix> <465DE009.7060202@tmr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <465DE009.7060202@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Nix <nix@esperi.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On May 30 2007 16:35, Bill Davidsen wrote:
>> On 29 May 2007, Jan Engelhardt uttered the following:
>> > from your post at
>> > http://www.mail-archive.com/linux-raid@vger.kernel.org/msg07384.html I
>> > read that autodetecting arrays with a 1.x superblock is currently
>> > impossible. Does it at least work to force the kernel to always assume
>> > a 1.x sb? There are some 'broken' distros out there that still don't
>> > use mdadm in initramfs, and recreating the initramfs each time is a
>> > bit cumbersome...
>> 
>> The kernel build system should be able to do that for you, shouldn't it?
>> 
> That would be an improvement, yes.

Hardly, with all the Fedora specific cruft. Anyway, there was a
simple patch posted in RH bugzilla, so I've gone with that.


	Jan
-- 
