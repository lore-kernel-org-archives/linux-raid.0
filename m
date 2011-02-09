From: Lennart Poettering <lennart@poettering.net>
Subject: Re: [systemd-devel] systemd kills mdmon if it was started manually
 by user
Date: Wed, 9 Feb 2011 15:01:39 +0100
Message-ID: <20110209140139.GA12063@tango.0pointer.de>
References: <AANLkTikTa8stFAcXG9jknh=RG=-Mi+xW-AD9DgZCfQ=7@mail.gmail.com>
 <20101204121413.GC11336@mother.pipebreaker.pl>
 <AANLkTi=nTSdHc55f08G9sdEK6u8eXp276VOTHHr0jmXT@mail.gmail.com>
 <20110125034434.GC7046@tango.0pointer.de>
 <AANLkTik189VTXYpzLFqP=MNBg=Nx-Yq6BOKURtiby++B@mail.gmail.com>
 <20110125042814.GA9727@tango.0pointer.de>
 <AANLkTik7dd5SHkuBVrS6LLDR9v57GsFjjxDKQKPp-YVL@mail.gmail.com>
 <20110208094843.GD11446@tango.0pointer.de>
 <AANLkTi=rFoqBwKdd0B3Xx6JrGdJdut0a2r=wFh0oSx73@mail.gmail.com>
 <20110208110730.GF23157@tango.0pointer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110208110730.GF23157@tango.0pointer.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Tomasz Torcz <tomek@pipebreaker.pl>, systemd-devel@lists.freedesktop.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 08.02.11 12:07, Lennart Poettering (lennart@poettering.net) wrote:

> > At this point we know it is container, know that it has external
> > metadata and know that we need external metadata handler (mdmon). But
> > it is too late for systemd.
> 
> Kay, do you know why this "change" event is used here? Any chance we can
> get rid of it?

So, it seems that the "change" event does make some sense here. I have
now added a new property to systemd: if you set SYSTEMD_READY=0 on a
udev device then systemd will consider it unplugged even if it shows up
in the udev tree. If this property is not set for a device, or is set to
1 we will conisder the device plugged.

To make this md stuff compatible with systemd we hence just need to set
SYSTEMD_READY=0 during the "new" event and drop it when the device is
fully set up. 

Andrey, since you are playing around with this, do you happen to know
which attribute we should check to set SYSTEMD_READY=0 properly? It
would be cool if we could come up with a default rule for inclusion in
our systemd rules file that will ensure the device only shows up when it
is ready.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
