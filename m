From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: Hardware advice for software raid
Date: Tue, 1 Apr 2014 14:28:26 -0500
Message-ID: <CAJvUf-AWGWXuqjpPPqA99RLG2DNiGoba3eP1AG5UPwpsUMecig@mail.gmail.com>
References: <CAPSPcXjo5J-Omj+94RkKPXSNUwBHT4GWKmkYuWV9htniZNf+sw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPSPcXjo5J-Omj+94RkKPXSNUwBHT4GWKmkYuWV9htniZNf+sw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Barrett Lewis <barrett.lewis.mitsi@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Apr 1, 2014 at 2:09 PM, Barrett Lewis
<barrett.lewis.mitsi@gmail.com> wrote:
> I'm guessing that the motherboard has some problem (perhaps
> originating from the bad PSU?), and I want to switch to a dedicated
> HBA card to make this more modular.

I had a problem with a different motherboard: my system would randomly
reboot from time to time.  The motherboard was a Biostar nm70i-847,
and I found other people were having the problem too:
    http://ubuntuforums.org/showthread.php?t=2094859
The solution was trivial, just add "i915.i915_enable_rc6=0" to the
kernel commandline.  Now that system appears to be completely stable.

I mention this only to suggest that maybe there is some other, easily
fixable problem with your motherboard.  IOW, maybe there is a cheaper
solution that doesn't require new hardware.

You might also play with things like AHCI vs IDE mode in your BIOS...
these days, I think AHCI is generally the way to go, but it seems some
boards still ship with SATA mode set to "native" or "IDE", rather than
AHCI.

> Stan had suggested the LSI SATA/SAS 9211-8i in many threads in the
> archives.  If I use this card as my HBA, is there any particular
> motherboard which would be better suited than others?

For home use, I use the IBM ServeRAID m1050, which I believe is a
re-branded LSI 9220-8i.  I use this because they can be purchased
fairly cheap on eBay.  In fact, I flash mine to "IT" mode (as opposed
to "IR" mode; IT mode removes all RAID features, and they become a
truly dumb, non-bootable HBA).

If you care about power consumption at all, note that this card will
add about five to 10 watts of power draw to your system (depending on
your PSU's efficiency).  It will also add a little bit of heat
(possibly if you have a small case, bad airflow, or live in a hot
climate with no air conditioning).

With Linux software RAID, I think you're already "modular"; that is,
your array is already "portable" across other Linux systems with
different hardware, regardless of HBA or onboard SATA.

The other thing I'd look out for: *some* cheap consumer motherboards
have crippled PCIe slots that only allow graphics cards to be
installed in them.  I haven't seen this in a long time, but many years
ago, I found out the hard way that my non-graphics cards wouldn't work
in a (supposedly standard) PCIe slot.  Hopefully the situation has
improved, as even that cheap Biostar Celeron board accepts the IBM
m1050.  But, if in doubt, confirm with the manufacturer before
purchasing.
