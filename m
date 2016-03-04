From: Another Sillyname <anothersname@googlemail.com>
Subject: Re: Fwd: RAID6 Array crash during reshape.....now will not re-assemble.
Date: Fri, 4 Mar 2016 19:01:32 +0000
Message-ID: <CAOS+5GEeGapxE1_GUhxD6F2BCabso-M=h-HQYjZ0hvNxh04Hug@mail.gmail.com>
References: <CAOS+5GEd4E2wzYhw0rPdrZnjK6UwAUdKCQLLTxXrdPO8d7hS7w@mail.gmail.com>
	<56D6E883.50801@youngman.org.uk>
	<CAOS+5GHof=F94x58SKqFojV26hGpDSLF85dFfm8Xc6M43sN6jA@mail.gmail.com>
	<CAOS+5GEfQ2p0xguguKC3uXW8GYBDCxt2vk=-Ci6+nTKwkcWtdQ@mail.gmail.com>
	<CAOS+5GGX8QBo3=s+Mcj=Kd6VSmZyatfZ30NXBy8E=4WJE6z0sA@mail.gmail.com>
	<CAOS+5GGB5gVSFJbYwwJu+z0C0oyYPzsLRhnjD6FkmLEWFFquFA@mail.gmail.com>
	<56D8348E.9070802@youngman.org.uk>
	<CAOS+5GH1Rcu8zGk1dQ+aSNmVzjo=irH65KfPuq1ZGruzqX_=vg@mail.gmail.com>
	<CAOS+5GHUKD63M90zWfiv14QkJunj2QF+gYqDMrg208-S4oXE2Q@mail.gmail.com>
	<56D878E8.1060409@prgmr.com>
	<CAOS+5GEnvtPMUqorddDNUvkNr2+K2S=0N76i3f0AkAOE-7U4Pg@mail.gmail.com>
	<22232.41693.691818.451316@quad.stoffel.home>
	<CAOS+5GFfNdeYrfw6j_LowkW+g69h2fEOikHN1=-VQ98ZF9Jtpg@mail.gmail.com>
	<22232.48582.65930.822795@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22232.48582.65930.822795@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi John

Yes I had already tried the revert-reshape option with no effect.  It
was when I found that option I also found the comment suggesting it
only applied to reshapes that are growing rather then shrinking.

Thanks for the suggestion but I'm still stuck and there is no bug
tracker on the mdadm git website so I have to wait here.

Ho Huum





On 3 March 2016 at 22:42, John Stoffel <john@stoffel.org> wrote:
>
> Another> Thanks for the suggestion but that's still 'trying' things
> Another> rather then an analytical approach.
>
> Well... since Neil is the guy who knows the code, and I've been
> several emails in the past about re-shapes gone wrong, and pulling
> down Neil's latest version was the solution.  So that's what I'd go
> with.
>
> Another> I also do not want to reboot this machine until I absolutely
> Another> have to incase I need to capture any data needed to identify
> Another> and thereby resolve the problem.
>
> Reboot won't make a difference, all the data is on the disks.
>
> Another> Given I'm not getting much joy here I think I'll have to post
> Another> a bug tomorrow and see where that goes.
>
> I'd also argue that removing a disk from a RAID6 of 30Tb in size is
> crazy, but you know the risks I'm sure.
>
> It might have been better to just fail one disk, then zero it's
> super-block and use that new disk formatted by hand into a plain xfs
> or ext4 filesystem for you travels.  Then when done, you'd just re-add
> the disk into the array and let it rebuild the second parity stripes.
>
> Also, I jsut dug into my archives, have you tried:
>
>        --assemble --update=revert-reshape
>
> on your array?
>
> John
