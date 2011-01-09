From: Matthew Gabeler-Lee <cheetah@fastcat.org>
Subject: Re: Bug#597563: grub-common: grub-probe segfaults scanning lvm devices
Date: Sun, 09 Jan 2011 17:13:10 -0500
Message-ID: <4D2A32F6.4050304@fastcat.org>
References: <20100920202854.27101.8288.reportbug@cheetah.fastcat.org>	<4D274FF9.8010004@gmail.com>	<alpine.DEB.2.00.1101072241560.25170@cheetah.fastcat.org>	<4D285B79.9040100@gmail.com>	<alpine.DEB.2.00.1101081739500.14736@cheetah.fastcat.org>	<20110110075543.4969998e@notabene.brown>	<4D2A2951.5020902@gmail.com> <20110110085735.1c68e425@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110110085735.1c68e425@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= <phcoder@gmail.com>, 597563@bugs.debian.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/9/2011 16:57, NeilBrown wrote:
> Simply running
>     mdadm --zero-superblock /dev/sdb
>
> should fix it.
Well, that doesn't work very well: "mdadm: Couldn't open /dev/sdb for write 
- not zeroing" ... strace reveals that mdadm is trying to open it O_EXCL, 
which I presume is why it's not working ... I presume I'd have to reboot to 
single user mode and stop the LVM and possibly MD stuff in order for that to 
work, which might then require booting from a rescue cd to do it.

So I backed up the contents of the end of the disk in case I screwed up, and 
then zerro'd it with dd (nervous nervous).  I double-checked things with 
mdadm --examine to double-check I had cleared the stray superblock and not 
damaged the one in sdb3, and that looks OK

After doing that, the version of grub-probe that was crashing before appears 
to work properly, and the trunk version of grub-probe no longer spits out 
the warning/error.  I then upgraded the debian package to the latest version 
in testing (since I'd been using an old version where I could work around 
the problems), and let it run the grub-install on all 4 disks, and that 
proceeded without errors.  Hooray :)

Thank you folks for your help solving this!

-- 
	-Matt
"Reality is that which, when you stop believing in it, doesn't go away".
                 -- Philip K. Dick
GPG pubkey fingerprint: A57F B354 FD30 A502 795B 9637 3EF1 3F22 A85E 2AD1

