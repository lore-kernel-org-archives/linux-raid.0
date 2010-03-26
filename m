From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: Use of WD20EARS with MDADM
Date: Fri, 26 Mar 2010 17:50:18 -0500
Message-ID: <bdd6985b1003261550y6ba8b283q6c998930bd36f237@mail.gmail.com>
References: <4BAB8D41.4010801@gmail.com> <4BAD18A5.1080905@kieser.ca>
	 <5bdc1c8b1003261359i2f6f1bdai3261aec30bb663bf@mail.gmail.com>
	 <4BAD20A2.20606@kieser.ca>
	 <5bdc1c8b1003261406m2ae66154u55a70aada56a91c1@mail.gmail.com>
	 <5bdc1c8b1003261416xdc883a4qdba1cdf049cca437@mail.gmail.com>
	 <4BAD24EB.4020606@sauce.co.nz>
	 <5bdc1c8b1003261538y751a3089p284bee0ee1b28b63@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5bdc1c8b1003261538y751a3089p284bee0ee1b28b63@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Richard Scobie <richard@sauce.co.nz>, Peter Kieser <peter@kieser.ca>, Andrew Dunn <andrew.g.dunn@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Mar 26, 2010 at 5:38 PM, Mark Knecht <markknecht@gmail.com> wrote:
> I wonder if I'm seeing something like Matt is seeing with the drive
> continually being woken up. I know most of the time it just sits idle
> from a user's perspective, but I've done nothing to stop daemons or
> anything like that. It runs screen savers, gets used every day for an
> hour or two, but is always powered up so that I can administer it from
> 350 miles away.

In my case, I want to emphasize the following: my WD Green drives are
strictly a data store.  The system runs from a compact flash card.
Though I disabled them anyway, many daemons, such as syslog, sshd,
cron, fetchmail, etc, should only affect the *system* drive.

However, daemons like nfs and smbd can obviously affect the data
store.  Even so, I wouldn't expect them to cause a disk access unless
a request is made.

The point is, in my opinion, a non-system partition should be that
much easier to make "truly" idle... still, I can't figure out how to
do it.

-Matt
