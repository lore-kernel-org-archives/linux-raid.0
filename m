From: Daniel Pittman <daniel@rimspace.net>
Subject: Re: Starting point of the actual RAID data area
Date: Sun, 08 Oct 2006 10:49:13 +1000
Message-ID: <87hcyfpr7a.fsf@rimspace.net>
References: <2341BC7C-A023-4E59-8D2E-773EC9AF031E@dataprey.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jyri Hovila <jyri.hovila@dataprey.fi> writes:

> I'm experimenting with Linux software RAID recovery. My target is to
> be able to recover RAID 5 from individual drives without using the
> Linux RAID tools - I mean mdadm and the others. I know it's not the
> easiest way, but I *do* need to figure out a way to recover Linux RAID
> using Windows... Sorry... ;)

Well, sure, you need to recover the data under Windows -- but why hurt
yourself by doing it without the appropriate tools?

The "Services For Unix" package, which is free-as-in-beer, provides an
enhanced POSIX layer for Windows.  You should be able to port mdadm and
other tools as appropriate to Windows using those services, which may
make life easier.

> What I'd like to know is how can I find where the actual RAID data
> area starts on disks participating in a RAID 5 set. I know most of the
> RAID configuration information is stored on all of the drives, but I'm
> not geek enough to learn how it's stored from the RAID source code.

...if you can't extract that information yourself then I would suggest
you are in for a world of pain trying to build tools to recover the data
within Windows.

Are you sure it wouldn't be easier to install VMWare on the system, then
Linux into that, and use Linux to do the recovery?  A LiveCD image could
be used, so you don't need to write the OS anywhere to disk...

> I would appreciate it a lot if somebody could give me a hand here. All
> I need to understand right now is how I can find out the first sector
> of the actual RAID data. I'm starting with a simple configuration,
> where there are three identical drives, all of them used fully for one
> RAID 5 set. And no LVM at this point.

It would start on the first sector of the first disk.

Regards,
        Daniel
-- 
Digital Infrastructure Solutions -- making IT simple, stable and secure
Phone: 0401 155 707        email: contact@digital-infrastructure.com.au
                 http://digital-infrastructure.com.au/

