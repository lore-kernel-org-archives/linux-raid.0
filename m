From: "Doug Griswold" <griswld@cio.sc.gov>
Subject: Re: md multipath and failover
Date: Thu, 11 Sep 2003 13:30:41 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <sf607904.085@gw.state.sc.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: lmb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Here is a update on my situation.  I downloaded the md-mp patch and
tried to apply it to the Red Hat kernel source 2.4.9-27enterprise
kernel, this did not patch correctly.  I then downloaded the 2.4.22
kernel and applied with success.   The box now fails over in a matter o=
f
seconds instead of minutes it still doesn't failback but that's no big
deal.  My next question is how can I apply this patch to the red hat
supplied kernel 2.4.9-27 enterprise so I will still have red hat suppor=
t
on this kernel?  Also is there away with this patch applied to get
failback? =20




Thanks,
Doug

>>> Lars Marowsky-Bree <lmb@suse.de> 09/11/03 03:43AM >>>
On 2003-09-10T18:55:41,
   Doug Griswold <griswld@cio.sc.gov> said:

> Alright I got md/multipath to failover with 2 emulex hba's on red
hat
> advanced server 2.1 kernel version 2.4.9-27enterprise.  My next new
> problem is that it took five minutes to fail over from when I yanked
one
> of the fibre channel cables.   Where could this timeout come from?=20
I
> have tried several times but each time it takes 5 minutes to
failover.=20
> Also it won't failback.  Any ideas out there. =20

The plain md multipath can't do failback automatically. People's
opinion
on whether that is a good idea do differ ;-)

The timeout is the time needed until the damn (sorry) Linux Kernel
SCSI
layers give up retrying and then pass the error code up to md for
handling. You can maybe try tuning some emulex parameters to fix that.

If you want load balancing for the md multipath, you could try
checking
out my patch at ftp://ftp.suse.com/pub/people/lmb/md-mp/ vs 2.4, it
adds
some features to md and also makes it quite a bit more robust.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering		ever tried. ever failed. no
matter.
SuSE Labs				try again. fail again. fail
better.
Research & Development, SuSE Linux AG		-- Samuel Beckett

-
To unsubscribe from this list: send the line "unsubscribe linux-raid"
in
the body of a message to majordomo@vger.kernel.org=20
More majordomo info at  http://vger.kernel.org/majordomo-info.html
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
