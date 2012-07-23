From: Jaromir Capik <jcapik@redhat.com>
Subject: Re: [RFE] Please, add optional RAID1 feature (= chunk checksums) to
 make it more robust
Date: Mon, 23 Jul 2012 05:34:17 -0400 (EDT)
Message-ID: <542194327.593466.1343036057599.JavaMail.root@redhat.com>
References: <500CD32E.4000800@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <500CD32E.4000800@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello Stan.

I received your reply without having the Linux RAID list in Cc
and thus I was unsure if you wanna discuss that privately or not.
I always choose reply to all unless I really want to remove
some of the recipients :]

Cheers,
Jaromir.

> 
> Please keep discussion on list.  This is probably an MUA issue.
>  Happens
> to me on occasion when I hit "reply to list" instead of "reply to
> all".
>  vger doesn't provide a List-Post: header so "reply to list" doesn't
> work and you end up replying to the sender.
> 
> On 7/22/2012 5:11 PM, Jaromir Capik wrote:
> >>> I admit, that the problem could lie elsewhere ... but that
> >>> doesn't
> >>> change anything on the fact, that the data became corrupted
> >>> without
> >>> me noticing that.
> >>
> >> The key here I think is "without me noticing that".  Drives
> >> normally
> >> cry
> >> out in the night, spitting errors to logs, when they encounter
> >> problems.
> >>  You may not receive an immediate error in your application,
> >>  especially
> >> when the drive is a RAID member and the data can be shipped
> >> regardless
> >> of the drive error.  If you never check your logs, or simply don't
> >> see
> >> these disk errors, how will you know there's a problem?
> > 
> > Hello Stan.
> > 
> > I used to periodically check logs as well as S.M.A.R.T. attributes.
> > And I believe I've already mentioned two of the cases and how
> > I finally discovered the issues. Moreover I switched from manual
> > checking to receiving emails from monitoring daemons. And even
> > if you receive such email, it usually takes some time to replace
> > the failing drive. That time window might be fatal for your data
> > if junk is read from one of the drives and when it's followed
> > by a write. Such write would destroy the second correct copy ...
> > 
> >>
> >> Likewise, if the checksumming you request is implemented in
> >> md/RAID1,
> >> and your application never sees a problem when a drive heads
> >> South,
> >> and
> >> you never check your logs and thus don't see the checksum
> >> errors...
> > 
> > You wouldn't have to ... because the corrupted chunks would be
> > immediately resynced with good data and you'll REALLY get some
> > errors
> > in the logs if the harddrive or controller or it's driver doesn't
> > produce them for whatever reason.
> > 
> >>
> >> How is this new checksumming any better than the current
> >> situation?
> >>  The
> >> drive is still failing and you're still unaware of it.
> > 
> > Do you believe, that other reasons of silent data corruptions
> > simply
> > do not exist? Try to imagine a case, when the correct data aren't
> > written at all to one of the drives due to a bug in the drive's
> > firmware
> > or due to a bug in the controller design or due to a bug in the
> > controller driver or due to other reasons. Such bug could be
> > tiggered
> > by anything ... it could be a delay in the read operation when the
> > sector is not well readable or any race condition, etc. Especially
> > new devices and their very first versions are expected to be buggy.
> > Checksuming would prevent them all and would make the whole
> > I/O really bulletproof.
> 
> 
