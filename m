From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Degraded Array
Date: Sat, 4 Dec 2010 02:53:45 -0600
Message-ID: <EB.15.13137.D910AFC4@cdptpa-omtalb.mail.rr.com>
References: <20101204174457.4249ba23@notabene.brown>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101204174457.4249ba23@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: 'Neil Brown' <neilb@suse.de>, "'Majed B.'" <majedb@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Neil Brown
> Sent: Saturday, December 04, 2010 12:45 AM
> To: Majed B.
> Cc: lrhorer@satx.rr.com; linux-raid@vger.kernel.org
> Subject: Re: Degraded Array
> 
> On Sat, 4 Dec 2010 07:26:36 +0300 "Majed B." <majedb@gmail.com> wrote:
> 
> > You have a degraded array now with 1 disk down. If you proceed, more
> > disks might pop out due to errors.
> >
> > It's best to backup your data, run a check on the array, fix it then
> > try to resume the reshape.
> 
> Backups are always a good idea, but are sometimes impractical.

	I always have backups.  I have a backup system running a RAID array
always kept a bit bigger than my primary server.  Every morning at 04:00 I
run an rsync (well, the system does, of course).

 
> I don't think running a 'check' would help at all.  A 'reshape' will do
> much
> the same sort of work, and more.
> 
> It isn't strictly true that the array is '1 disk down'.  Parts of it are 1
> disk down, parts are 2 disks down.  As the reshape progresses more and
> more
> will be 2 disks down.  We don't really want that.

	Well, I'm not too fussed if there is no better option.

> This case isn't really handled well at present.  You want to do a
> 'recovery'
> and a 'reshape' at the same time.  This is quite possible, but doesn't
> currently happen when you restart a reshape in the middle (added to my
> todo
> list).
> 
> I suggest you:
>  - apply the patch below to mdadm.
>  - assemble the array with --update=revert-reshape.  You should give
>    it a --backup-file too.
>  - let the reshape complete so you are back to 13 devices.
>  - add  a spare and let it recovery
>  - then add a spare and reshape the array.
> 
> Of course you needed to be running a new enough kernel to be able decrease
> the number of devices in a raid5.

	I don't think I am.  Mdadm 2.6.7.2 and kernel 2.6.26-2-amd64.

