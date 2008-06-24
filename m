From: Arthur Britto <ahbritto@iat.com>
Subject: Re: End to end SMART to RAID repair
Date: Mon, 23 Jun 2008 17:05:44 -0700
Message-ID: <1214265944.31695.25.camel@loss.redstem.com>
References: <1214199855.4296.8.camel@loss.redstem.com>
	 <18528.10923.329740.465179@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18528.10923.329740.465179@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2008-06-24 at 08:58 +1000, Neil Brown wrote:
> On Sunday June 22, ahbritto@iat.com wrote:
> > smartmontools (http://smartmontools.sourceforge.net/) can be config=
ured
> > to passively scan hard drives for defects in the background.  The b=
lock
> > numbers of pending unreadable sectors are logged via syslog.  These
> > sectors will be remapped when written too.
> >=20
> > It would be great if this worked end to end with linux software rai=
d to
> > automatically repair the bad sector.
>=20
> Well, you can just get md to do a scan (echo check >
> /sys/block/mdXX/md/sync_action) and it will find any read errors and
> correct them.

True.  However, a SMART on disk check requires no main board
resources. =EF=BB=BFSome drives, when idle, may do background checking =
anyway.
This would provide a way to correct the error without needing to scan
the whole volume and other components with an md check.  Error checking
may be less intrusive (vs retries to the exclusion of other work) than
normal for an attempted sector read.  At least manufactures have the
option to give priority to actual read requests over background defect
checking.

> Extracting numbers from syslog is a fairly messy thing to try to do.
> Maybe if smartmontools could report these in some other way -
> e.g. run a program giving device and block number, we could write a
> script that feeds that info to md.
> We would need to map the device+offset to partition+offset, then find
> out if that is a member of an md array, then request a limited-range
> 'check', which I think is possible with current code...
>=20
> Do you know if smartmontools can provide this info in a more
> controlled way?

I was thinking, a non-smartmontools specific method would be best.  Tha=
t
is: (1) some way for the md driver to request notification about pendin=
g
uncorrected read errors from a region of a block device and (2) some wa=
y
for a trusted application to inform the kernel about pending uncorrecte=
d
read errors (e.g. echo "start-stop > /sys/...").

-Arthur

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
