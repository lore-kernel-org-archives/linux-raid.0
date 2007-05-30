From: Nix <nix@esperi.org.uk>
Subject: Re: RAID SB 1.x autodetection
Date: Wed, 30 May 2007 21:10:17 +0100
Message-ID: <877iqqul7a.fsf@hades.wkstn.nix>
References: <Pine.LNX.4.61.0705292036400.11140@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0705292036400.11140@yvahk01.tjqt.qr> (Jan Engelhardt's message of "29 May 2007 20:15:45 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 29 May 2007, Jan Engelhardt uttered the following:

> from your post at 
> http://www.mail-archive.com/linux-raid@vger.kernel.org/msg07384.html I 
> read that autodetecting arrays with a 1.x superblock is currently 
> impossible. Does it at least work to force the kernel to always assume a 
> 1.x sb? There are some 'broken' distros out there that still don't use 
> mdadm in initramfs, and recreating the initramfs each time is a bit 
> cumbersome...

The kernel build system should be able to do that for you, shouldn't it?

-- 
`On a scale of one to ten of usefulness, BBC BASIC was several points ahead
 of the competition, scoring a relatively respectable zero.' --- Peter Corlett
