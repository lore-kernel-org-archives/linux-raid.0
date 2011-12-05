From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Is this stupid?
Date: Mon, 5 Dec 2011 02:01:10 -0600
Message-ID: <CD.9B.23309.74A7CDE4@cdptpa-omtalb.mail.rr.com>
References: <CAFx4rwRzUM3kh5vTmqoiH84s7kGD54cjqGAcrdhRxYEm03NVsw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFx4rwRzUM3kh5vTmqoiH84s7kGD54cjqGAcrdhRxYEm03NVsw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: doug@easyco.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: dougdumitruredirect@gmail.com [mailto:dougdumitruredirect@gmail.com]
> On Behalf Of Doug Dumitru
> Sent: Monday, December 05, 2011 12:18 AM
> To: Leslie Rhorer
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Is this stupid?
> 
> Mr. Rhorer,
> 
> Don't work too hard over-thinking this in terms of wearing the stick
> out.  Current USB sticks are built with dirt cheap, often three bits
> per cell flash with lousy endurance and minimal wear leveling.  Even
> so, if you have an 8GB stick that writes at 5 MB/sec and 600
> endurance, it still takes 11 days of 100% busy writes to kill it.

I'm thinking more like 3 years or so.

> The real issue with booting from a USB stick (and the same rules apply
> to CF cards), is that some operations like syslogd sync writes can
> take forever and then some.

Yeah, that seems to be the main concern, along with the fact there is more
than one asynchronous process doing the writing.

> One other trick is to either use a more "flash friendly" file system,

Such as?  Of course both tmpfs and the hard drive are both 100% flash
friendly, which is the point.

> or at least turn off atime tracking.

Yeah, I've done that.  The writes to /var/log, /var/run, /var/lock, and /tmp
are 100% flash friendly at the moment.  They just aren't RAM friendly.  Of
course, with 512M of real memory and 512M of RAID array based swap, maybe
I'm just being a mother hen.  At the moment, only 71M of RAM is in use, and
none on the RAID array.  With the Ethernet interfaces set to use static IPs,
rsyslog is hardly putting out anything at all.  I have logrotate running
every hour, and all the logs limited to rather small sizes.  The biggest
offender is SAMBA, who has over 500K of files open in /var/run.

