From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: md extension to support booting from raid whole disks.
Date: Fri, 15 May 2009 09:13:30 -0700
Message-ID: <4A0D94AA.8020803@zytor.com>
References: <20090503013342770.VMBT19475@cdptpa-omta01.mail.rr.com>	<e13f0e541934a0966f213f6da13d83da.squirrel@neil.brown.name>	<1241406283.17240.26.camel@ezra>	<87fxff462s.fsf@frosties.localdomain>	<21cdc7a16fbdd42979d52331db97c737.squirrel@neil.brown.name>	<87ws8r2pqf.fsf@frosties.localdomain>	<18953.2936.212863.158003@notabene.brown>	<1242157469.18958.13.camel@ezra> <18954.43834.53155.793587@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18954.43834.53155.793587@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Daniel Reurich <daniel@centurion.net.nz>, Goswin von Brederlow <goswin-v-b@web.de>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:
> 
> Having a replicated boot loader and having a raid1 are conceptually
> quite different things.
> A raid1 says "keep N (typically 2) copies of the data somewhere for
> me".
> A replicated boot loader says "store this boot loader on every
> bootable device".
> One is more abstract, the other is more concrete.
> 
> Maybe it is a very subtle distinction, but I think it is worth
> maintaining.  Get your boot-loader-installer to install at the front
> of every drive - don't bother having a raid1 there that is never read
> and hardly ever written..
> 

I think it is an unfortunate distinction (although I see why you want to
make it), and one which goes in the wrong direction.

As I've stated many times (and not just in this debate), I believe using
the RAID-1 mechanism to replicate /boot across the entire span of
devices is the right thing to do.  Not just the boot loader, but all of
/boot.

Once you do that, you do want to write it on a regular basis, and using
the RAID-1 code is the obvious way to do it.  You can argue that it is
an accidental effect of the way the current Linux RAID-1 code does it,
but it's nevertheless extremely useful, widely deployed, and extremely
resilient.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

