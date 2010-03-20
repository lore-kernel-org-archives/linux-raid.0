From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: OT: sas controllers/expanders and "desktop" drives?
Date: Sat, 20 Mar 2010 11:47:48 -0500
Message-ID: <20100320164748.GA31221@septictank.raw-sewage.fake>
References: <20100317143602.GA18298@septictank.raw-sewage.fake> <4BA4EAFB.1050302@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4BA4EAFB.1050302@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Mar 20, 2010 at 11:34:19AM -0400, Bill Davidsen wrote:
> Matt Garman wrote:
> >For example, from the FAQ for that SuperMicro chassis[3]:
> >
> >    Question: We want to use the new Seagate 1.5TB ST31500341AS
> >    drives in combination with a storage solution based on your
> >    846TQ chassis, is this compatible?
> >
> >    Answer: This ST31500341AS hard drive is designed to be a
> >    Desktop type hard drive, not an Enterprise hard drive which
> >    is needed in this setup.  We don't recommend this
> >    combination, so please use the Seagate 1TB ST31000340NS drive
> >    instead. This drive is an Enterprise drive and validated for
> >    our 846TQ chassis.
> >
> >In short, we want to build a server with 24 drives.  The desktop
> >drives are significantly cheaper than the enterprise drives.  But
> >getting 24 ports is cheapest with these SAS controllers +
> >expanders.
>  
> I have the feeling that what they meant is that the drives have
> firmware intended for desktop use and will not work well in RAID
> usage. This has been discussed here before, the desktop drives
> have firmware which tries repeatedly to recover data on a failed
> read, and which therefore may hang for 20-30 sec before reporting
> an error or finally returning the data without an error
> indication.

That makes sense.  For what it's worth, I found out that the
expander chip on the SuperMicro 846 case is the LSI SASx36[1].
(Note that there are several versions of this case; the E1 and E2
are the ones that have the expander.  The TQ version doesn't have
the expander chip.)

> Until/unless Neil changes his idea that timeout should be in the
> driver or the driver, these drives work poorly with RAID.

For this particular application, my requirements are a little
different---I actually just want a bunch of individual drives; I
won't be using RAID.  (But there seems to be a lot of folks on this
list with a wide range of hardware experience, and I was hoping to
catch someone with experience with this particular configuration.)

Anyway, we went ahead and ordered the hardware---LSI SAS3081E-R
card, case with the LSI SASX36 expander, and both WD Green and
Samsung EcoGreen drives (both desktop class).  I'll be able to
follow up shortly and report how well this configuration works (or
doesn't) for standalone usage.

As for RAID usage (md or hardware): just to be clear, my
understanding is that the biggest problem is that, even if the
desktop drives work fine for non-RAID use, they'll still be
"difficult" in an array.  That is, they take too long to report
errors, and thus get kicked out of the array.

From my perspective, this isn't a true hardware incompatibility;
it's a software (or firmware) "mismatch".  If this is correct, then
the "real" answer to the FAQ I copied above is more nuanced.  The
current answer should be qualified with "for use in a RAID", and
then go on to suggest that the drives should be ok for standalone
use.

-Matt

[1] http://www.lsi.com/storage_home/products_home/standard_product_ics/sas_expander_ics/lsisasx36/index.html
