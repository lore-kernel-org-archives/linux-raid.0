From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: HBA Adaptor advice
Date: Fri, 20 May 2011 05:21:19 -0500
Message-ID: <4DD6409F.9070904@hardwarefreak.com>
References: <4DD50C89.8060006@wildgooses.com> <20110520020853.GC4759@bitfolk.com> <4DD61948.8050302@wildgooses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD61948.8050302@wildgooses.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ed W <lists@wildgooses.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/20/2011 2:33 AM, Ed W wrote:
> On 20/05/2011 03:08, Andy Smith wrote:
>> Are there actually any HBAs that have BBU without using their RAID
>> features?
>>
>> I'd like to stop using hardware RAID but I can't give up the BBU and
>> write cache.

I'm curious why you are convinced that you need BBWC, or even simply WC,
on an HBA used for md RAID.  I'm also curious as to why you are so
adamant about _not_ using the RAID ASIC on an HBA, given that it will
take much greater advantage of the BBWC than md RAID will.  You may be
interested to know:

1.  When BBWC is enabled, all internal drive caches must be disabled.
    Otherwise you eliminate the design benefit of the BBU, and may as
    well not have one.
2.  w/md RAID on an HBA, if you have a good UPS and don't suffer
    kernel panics, crashes, etc, you can disable barrier support in
    your FS and you can use the drive caches.
3.  The elevator will perform well directly on drives with large cache

Most good higher end RAID cards have 512MB to 1GB or cache.  w/12 2TB
drives you'll have a combined cache of 768MB, as most drives of this
size have a 64MB cache.  So there's not much difference in total cache
size.  And the drive firmware will usually make better decisions WRT
cache use optimization than an upstream RAID card BIOS that has disabled
the drive caches.

For a stable system with good UPS and auto shutdown configured, BBWC is
totally overrated.  If the system never takes a nose dive from power
drop, and doesn't crash due to software or hardware failure, then BBWC
is a useless $200-1000 option.  Some hardware RAID cards require a
functional BBU before they will allow you to enable write caching.  In
that case BBU is needed.  In most other cases it's not.

If your current reasoning for wanting write cache on the HBA is
performance, then forget about the write cache as you don't need it with
md RAID.  If you want the BBWC combo for safety as your system isn't
stable or you have a crappy or no UPS, then forgo md RAID and use the
hardware RAID and BBWC combo.

One last point:  If you're bargain hunting, especially if looking at
used gear on Ebay, that mindset is antithetical to proper system
integration, especially when talking about a RAID card BBU.  If you buy
a use card, the first thing you muse do is chuck the BBU and order a new
one, because the used battery can't be trusted--you have no idea how
much life is left in it.  For you data to be safe, you need a new
battery.  Buying a brand new card w/bundled BBU may cost you the same or
less than a used card and a new battery from the manufacturer.

The following would be a darn good fit for your md RAID office server
setup, given your criteria, WRT the HBA, hot swap cages, drives, and
cables.  Drop the LSI SAS HBA into a PCIe 2.0 x8 slot.  Drop the Intel
24 port SAS expander into an x4/x8 slot, or mount it to the side or
floor of the chassis and power it via the 4 pin Molex plug.  Connect the
8087/8087 cable from the LSI card to the first port on the Intel SAS
Expander.  Mount the 5 IcyDock 4 x 2.5" SAS hot swap backplane cages in
5 x 5.25" externally accessible drive bays.  Connect each of the five
8087 breakout cables from the remaining 5 ports on the Intel Expander to
each of the hot swap backplanes--one cable per backplane--label which
drive connects to which port on the Intel expander so you can properly
identify failed drives!  Mount each Seagate Enterprise 2.5" 1TB drive in
a tray and insert the trays into the backplanes--fill each quad bay
before putting drives in the next bay.  After booting the machine hop
into the LSI BIOS and configure for JBOD.  You should know how to do the
read.

This setup gives you 12 enterprise 2.5" SAS 7.2K RPM 1TB drives--not
cheap SATA drives not fit for RAID--12TB raw total, in only three 5.25"
bays, and drawing much less power than equivalent 3.5" drives.  You will
have 8 free hot swap bays for future expansion, 20TB total if acquiring
the same drives.  Controller to drive aggregate bandwidth is 2.4GB/s,
4.8GB/s full duplex, HBA to host b/w is 4/8 GB/s, likely far more than
you need.

The parts list.  Total cost from NewEgg in the US is ~$3800 with ~$3000
of that being the 12 drives at $250 each.  The HBA + expander are only $470.

Buy 1:
http://www.lsi.com/channel/products/megaraid/sassata/9240-4i/index.html

Buy 1:
http://www.intel.com/Products/Server/RAID-controllers/re-res2sv240/RES2SV240-Overview.htm

Buy 5:
http://www.icydock.com/goods.php?id=114

Buy 12:
http://www.seagate.com/ww/v/index.jsp?name=st91000640ss-constellation2-6gbs-sas-1-tb-hd&vgnextoid=ff13c5b2933d9210VgnVCM1000001a48090aRCRD&vgnextchannel=f424072516d8c010VgnVCM100000dd04090aRCRD&locale=en-US&reqPage=Support#tTabContentSpecifications

Buy 5 (or local equivalent):
http://www.newegg.com/Product/Product.aspx?Item=N82E16816116098&cm_re=cable-_-16-116-098-_-Product

Buy 1 (or local equivalent):
http://www.newegg.com/Product/Product.aspx?Item=N82E16816116093&cm_re=cable-_-16-116-093-_-Product

Food for thought.  Hope it's useful as I killed over an hour putting
this together for you. :)

-- 
Stan
