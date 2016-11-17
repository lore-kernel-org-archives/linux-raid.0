From: Andy Smith <andy@strugglers.net>
Subject: Re: Newly-created arrays don't auto-assemble - related to hostname
 change?
Date: Thu, 17 Nov 2016 15:09:54 +0000
Message-ID: <20161117150954.GH21587@bitfolk.com>
References: <20161117035230.GG21587@bitfolk.com>
 <87lgwihc2v.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87lgwihc2v.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

On Thu, Nov 17, 2016 at 05:09:28PM +1100, NeilBrown wrote:
> On Thu, Nov 17 2016, Andy Smith wrote:
> > After install the name of the server was changed from "tbd" to
> > "jfd". Another array was then created (md5), added to
> > /etc/mdadm/mdadm.conf and the initramfs was rebuilt
> > (update-initramfs -u).
> >
> > md5 does not auto-assemble. It can be started fine after boot with:
> >
> >     # mdadm --assemble /dev/md5
> >
> > or:
> >
> >     # mdadm --incremental /dev/sdc
> >     # mdadm --incremental /dev/sdd
> 
> This is almost exactly what udev does when the devices are discovered,
> so if it works here, it should work when udev does it.

Indeed. So confusing. :(

> My only guess is that maybe the "DEVICE /dev/sd*" line in the mdadm.conf
> is causing confusion.  udev might be using a different name, though that
> would be odd.
> 
> Can you try removing that line and see if it makes a difference?

I've now tried that and it hasn't made a difference.

I don't know anything about udev but I guess that assembly is
handled by /lib/udev/rules.d/64-md-raid-assembly.rules whose only
relevant ACTION lines are:

# remember you can limit what gets auto/incrementally assembled by
# mdadm.conf(5)'s 'AUTO' and selectively whitelist using 'ARRAY'
ACTION=="add|change", IMPORT{program}="/sbin/mdadm --incremental --export $tempnode --offroot ${DEVLINKS}"
ACTION=="add|change", ENV{MD_STARTED}=="*unsafe*", ENV{MD_FOREIGN}=="no", ENV{SYSTEMD_WANTS}+="mdadm-last-resort@$env{MD_DEVICE}.timer"

…but I can't work out why they wouldn't be working here.

Time for a Debian bug report?

Cheers,
Andy
