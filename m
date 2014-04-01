From: "Scott D'Vileskis" <sdvileskis@gmail.com>
Subject: Re: Hardware advice for software raid
Date: Tue, 1 Apr 2014 15:43:42 -0400
Message-ID: <CAK_KU4ZLajOgujhPxfo-sVYh97oW0ZanktMFC9_0NScR+wT-Rw@mail.gmail.com>
References: <CAPSPcXjo5J-Omj+94RkKPXSNUwBHT4GWKmkYuWV9htniZNf+sw@mail.gmail.com>
	<CAJvUf-AWGWXuqjpPPqA99RLG2DNiGoba3eP1AG5UPwpsUMecig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJvUf-AWGWXuqjpPPqA99RLG2DNiGoba3eP1AG5UPwpsUMecig@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: Barrett Lewis <barrett.lewis.mitsi@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I would take a close look at your motherboard's capacitors and make
sure none are bulging.

Additionally, it might be worth running a memtest overnight, although
bad memory would only be responsible if you heavy IO also came with
heavy memory usage.

I run an Intel i7 desktop board  (Model number doesn't come to mind)
w/ 6 SATA ports/drives and bought a $40 SATA3 PCIe card for my SSD and
Blueray Burner. All of this runs pretty well with a ~500W power supply

Recently I purchased a Lenovo IX4-300D NAS appliance for under $200 at
Amazon and migrated 4 drives and a bunch of data to it. It runs a
flavor of Debian on ARM and uses linux md, is pretty quiet, and only
uses a few watts. The nicest part is that if the hardware quits I know
I can stick the disks in my PC.

On Tue, Apr 1, 2014 at 3:28 PM, Matt Garman <matthew.garman@gmail.com> wrote:
> On Tue, Apr 1, 2014 at 2:09 PM, Barrett Lewis
> <barrett.lewis.mitsi@gmail.com> wrote:
>> I'm guessing that the motherboard has some problem (perhaps
>> originating from the bad PSU?), and I want to switch to a dedicated
>> HBA card to make this more modular.
>
> I had a problem with a different motherboard: my system would randomly
> reboot from time to time.  The motherboard was a Biostar nm70i-847,
> and I found other people were having the problem too:
>     http://ubuntuforums.org/showthread.php?t=2094859
> The solution was trivial, just add "i915.i915_enable_rc6=0" to the
> kernel commandline.  Now that system appears to be completely stable.
>
> I mention this only to suggest that maybe there is some other, easily
> fixable problem with your motherboard.  IOW, maybe there is a cheaper
> solution that doesn't require new hardware.
>
> You might also play with things like AHCI vs IDE mode in your BIOS...
> these days, I think AHCI is generally the way to go, but it seems some
> boards still ship with SATA mode set to "native" or "IDE", rather than
> AHCI.
>
>> Stan had suggested the LSI SATA/SAS 9211-8i in many threads in the
>> archives.  If I use this card as my HBA, is there any particular
>> motherboard which would be better suited than others?
>
> For home use, I use the IBM ServeRAID m1050, which I believe is a
> re-branded LSI 9220-8i.  I use this because they can be purchased
> fairly cheap on eBay.  In fact, I flash mine to "IT" mode (as opposed
> to "IR" mode; IT mode removes all RAID features, and they become a
> truly dumb, non-bootable HBA).
>
> If you care about power consumption at all, note that this card will
> add about five to 10 watts of power draw to your system (depending on
> your PSU's efficiency).  It will also add a little bit of heat
> (possibly if you have a small case, bad airflow, or live in a hot
> climate with no air conditioning).
>
> With Linux software RAID, I think you're already "modular"; that is,
> your array is already "portable" across other Linux systems with
> different hardware, regardless of HBA or onboard SATA.
>
> The other thing I'd look out for: *some* cheap consumer motherboards
> have crippled PCIe slots that only allow graphics cards to be
> installed in them.  I haven't seen this in a long time, but many years
> ago, I found out the hard way that my non-graphics cards wouldn't work
> in a (supposedly standard) PCIe slot.  Hopefully the situation has
> improved, as even that cheap Biostar Celeron board accepts the IBM
> m1050.  But, if in doubt, confirm with the manufacturer before
> purchasing.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
