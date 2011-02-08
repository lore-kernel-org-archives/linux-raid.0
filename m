From: Lennart Poettering <lennart@poettering.net>
Subject: Re: [systemd-devel] systemd kills mdmon if it was started manually
 by user
Date: Tue, 8 Feb 2011 18:28:22 +0100
Message-ID: <20110208172822.GC21847@tango.0pointer.de>
References: <20101204121413.GC11336@mother.pipebreaker.pl>
 <AANLkTi=nTSdHc55f08G9sdEK6u8eXp276VOTHHr0jmXT@mail.gmail.com>
 <20110125034434.GC7046@tango.0pointer.de>
 <AANLkTik189VTXYpzLFqP=MNBg=Nx-Yq6BOKURtiby++B@mail.gmail.com>
 <20110125042814.GA9727@tango.0pointer.de>
 <AANLkTik7dd5SHkuBVrS6LLDR9v57GsFjjxDKQKPp-YVL@mail.gmail.com>
 <20110208094843.GD11446@tango.0pointer.de>
 <AANLkTi=rFoqBwKdd0B3Xx6JrGdJdut0a2r=wFh0oSx73@mail.gmail.com>
 <20110208110730.GF23157@tango.0pointer.de>
 <AANLkTinmO9gsJcwr+0bGGuVJfF2dyM5rDJqqSkmh_hqs@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTinmO9gsJcwr+0bGGuVJfF2dyM5rDJqqSkmh_hqs@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Tomasz Torcz <tomek@pipebreaker.pl>, systemd-devel@lists.freedesktop.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 08.02.11 16:54, Andrey Borzenkov (arvidjaar@mail.ru) wrote:

> >> a) mdmon is perfectly capable of restarting, it is already used to
> >> take over mdmon launched in initrd. The problem is to know when to
> >> restart - i.e. when respective libraries are changed. This is a job
> >> for package management in distribution. It is already employed for
> >> glibc, systemd and some others and can just as well be employed for
> >> mdmon. And this is totally unrelated to systemd :)
> >
> > Really, you are sying there is a synchronous way to make mdmon reexec
> > itself? How does that work?
> >
> 
> I am not sure whether it qualifies as synchronous, but "mdmon
> --takeover" will kill any existing mdmon for this and start monitoring
> itself.

I wonder if this is really fully synchronous, i.e. that a) there is no
point in time where mdmon is not running during this restart and b) the
mdmom --takeover command returns when the new daemon is fully up, and
not right-away.

> > Well, the root file systems cannot be unmounted, only remounted.
> >
> > So, is there a way to invoke mdmon so that it flushes all metadata
> > changes to disk and immediately terminates then this should be all we
> > need for a clean solution. We'd then shutdown the normal instances of
> > mdmon down like any other daemon and simply invoke this metadata
> > flushing command as part of late shutdown.
> 
> 
> Hmm ... it looks like you just need to
> 
> start mdmon
> do mdadm --wait-clean
> 
> After this you can kill mdmon again (assuming decide is no more in
> use).


Well, it would be nice if the md utils would offer something doing this
without spawning multiple processes and killing them again. 

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
