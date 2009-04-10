From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID halting
Date: Thu, 9 Apr 2009 22:02:47 -0500
Message-ID: <20090410030252.RSAN6222.cdptpa-omta03.mail.rr.com@Leslie>
References: <1239208193.27764.9.camel@cichlid.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1239208193.27764.9.camel@cichlid.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> > I think the only way to switch schedulers is to reboot.  You invoke
> > the noop scheduler via a command line arg to the kernel at boot time.
> 
> This can be done at any time, no reboot required:
> 
>  for f in /sys/block/*/queue/scheduler; do
>     echo noop > $f
>     echo $f "$(cat $f)"
>   done

OK, I did this.  Two questions:

1.  The system responded in each case with this: "/sys/block/<block
device>/queue/scheduler [noop] anticipatory deadline cfq".  Is this as
expected?

2.  To switch back to the default scheduler, which I take it is CFQ, do I
simply issue the command above, replacing the string "noop" with "cfq"?


> Just FYI, I don't think ionice and friends will work when using noop.
> 
> Leslie: I still think finding out what the kernel is doing during the
> stall would be a HUGE hint to the problem. Did you look into oprofile or
> ftrace?

I couldn't find a Debian source for ftrace, but I did download oprofile.  I
am going to require some guidance, however.  I understand in general terms
what oprofile does, and vaguely what is involved with setup and
configuration, but it's quite a powerful and flexible tool, and I have
little or no idea of where to head with specifics.  If someone would care to
send a little guidance on what parameters I need to employ for setup and
configuration, and what processes I need to profile, I would be most
grateful.

Not knowing what to expect for an output, I may also require some help with
analysis.  If anyone wishes to help, but would prefer to take it offline,
please feel free to e-mail me directly.  Otherwise, please respond here.

