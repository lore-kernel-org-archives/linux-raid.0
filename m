From: NeilBrown <neilb@suse.de>
Subject: Re: Bug#597563: grub-common: grub-probe segfaults scanning lvm
 devices
Date: Mon, 10 Jan 2011 09:29:17 +1100
Message-ID: <20110110092917.6c230326@notabene.brown>
References: <20100920202854.27101.8288.reportbug@cheetah.fastcat.org>
	<4D274FF9.8010004@gmail.com>
	<alpine.DEB.2.00.1101072241560.25170@cheetah.fastcat.org>
	<4D285B79.9040100@gmail.com>
	<alpine.DEB.2.00.1101081739500.14736@cheetah.fastcat.org>
	<20110110075543.4969998e@notabene.brown>
	<4D2A2951.5020902@gmail.com>
	<20110110085735.1c68e425@notabene.brown>
	<4D2A32F6.4050304@fastcat.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D2A32F6.4050304@fastcat.org>
Sender: linux-raid-owner@vger.kernel.org
To: Matthew Gabeler-Lee <cheetah@fastcat.org>
Cc: Vladimir =?UTF-8?B?J8+GLWNvZGVyL3BoY29kZXIn?= Serbinenko <phcoder@gmail.com>, 597563@bugs.debian.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 09 Jan 2011 17:13:10 -0500 Matthew Gabeler-Lee <cheetah@fastcat.org>
wrote:

> On 1/9/2011 16:57, NeilBrown wrote:
> > Simply running
> >     mdadm --zero-superblock /dev/sdb
> >
> > should fix it.
> Well, that doesn't work very well: "mdadm: Couldn't open /dev/sdb for write 
> - not zeroing" ... strace reveals that mdadm is trying to open it O_EXCL, 
> which I presume is why it's not working ... I presume I'd have to reboot to 
> single user mode and stop the LVM and possibly MD stuff in order for that to 
> work, which might then require booting from a rescue cd to do it.

Sorry, I forgot that the device would be in use.
In that case

   mdadm --zero-superblock --force /dev/sdb

would have done the trick.  But you found another way which worked just as
well.

NeilBrown

