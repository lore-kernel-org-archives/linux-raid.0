From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Advice for recovering array containing LUKS encrypted LVM volumes
Date: Thu, 08 Aug 2013 18:09:57 -0500
Message-ID: <52042545.7020500@hardwarefreak.com>
References: <CAC38o7ScozDqspEH-FSyoa_W5W8s+VfYd1RTAitz574wMYqhkA@mail.gmail.com> <51FE529C.6000502@hardwarefreak.com> <CAC38o7TqO9m=6LDHxDiV=XYcfAdbnpa=GZuft-TAqFDvdqvJ4A@mail.gmail.com> <52015093.3040100@hardwarefreak.com> <CAC38o7SZ=mGnKCOTrhi7zny3ajOF3BEmfouthN0XqVgXXANe4g@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC38o7SZ=mGnKCOTrhi7zny3ajOF3BEmfouthN0XqVgXXANe4g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: P Orrifolius <porrifolius@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 8/7/2013 2:34 AM, P Orrifolius wrote:
> On 7 August 2013 07:37, Stan Hoeppner <stan@hardwarefreak.com> wrote:
>> It makes more sense to spend 50% more, $75, for the native 8 port LSI
>> enterprise SAS/SATA HBA for guaranteed stability/reliability and the
>> available 4GB/s aggregate drive bandwidth.
> 
> Do you have any opinion on the suitability of a
> 
> FUJITSU MEGARAID LSI 2008 DUAL MINI SAS D2607-a21
> 
> similar to those listed at
> http://www.ebay.com/itm/181152217999?_trksid=p2048036#shId ?
> 
> Looks pretty similar to me... maybe identical if I'm not using any
> hardware raid capabilities?  Possibly can be got for half the cost of
> the LSI 9211-8i.

I have no experience with the Fujitsu models.  I can tell you that this
one is not an OEM LSI 9211-8i, but looks close at first glance.  It's
Fujitsu's own design.  It may use custom Fujitsu firmware instead of
LSI's which means you may not be able to flash standard LSI firmware
onto it if it needs it.  It mentions nothing of HBA mode, only RAID
mode.  Too many unknowns, and not enough documentation available.  I'd
steer clear.

This is probably your best current option, at 1/2 the Fujitsu price:

http://www.ebay.com/itm/Intel-SASUC8I-SAS-SATA-3Gb-s-PCIe-x8-Low-Profile-RAID-Controller-Refurbished/181108158926?_trksid=p2045573.m2042&_trkparms=aid%3D111000%26algo%3DREC.CURRENT%26ao%3D1%26asc%3D27%26meid%3D431256662585357660%26pid%3D100033%26prg%3D1011%26rk%3D2%26rkt%3D4%26sd%3D171093850996%26

This 3Gb/s Intel is/was a very popular LSISAS1068e based board, takes
standard LSI firmware.  Decent performer with md.  Discontinued, as the
SAS1068 series chips were discontinued.  The 9211 series (SAS2008 chip)
supersedes it.  Newegg was selling this exact Intel board new up to a
few months ago for $149.  The 1068 chip is limited to max individual
drive capacity of 2TB.  So you'll peak at 12TB net w/md RAID6 and 8x2TB
drives.  Hard to beat at $75 USD.  Uses same cables I listed previously.
 In NH, USA, ships worldwide.  Seller has 99.8% on 17k+ sales.  If in
your shoes this is the one I'd buy.

Here's an OEM Dell that I'm pretty sure is the 9240-8i and it already
has the IT firmware, which is what you'd want.  Better card than the
Intel above, but this sale ships to USA only apparently.

http://www.ebay.com/itm/NEW-Dell-SAS-SATA-2-0-6Gb-s-8-Port-2x4-PCI-e-HBA-LSISAS2008-IT-/171093850996?pt=US_Server_Disk_Controllers_RAID_Cards&hash=item27d5fcfb74

> Case-wise a http://www.bitfenix.com/global/en/products/chassis/shinobi
> looks the best/cheapest option availble to me.  Hopefully the 2 front
> fans will cool the main array enough, and I can jury-rig another fan
> for the extra drives mounted in the 5.25" bays.

I didn't recommend the Shinobi because it has restricted and unbalanced
airflow characteristics.  The 2 front air intake slits are too small to
optimally cool 8 drives in the cage without significant pressure,
requiring many, or stronger, fans to do the job.  It has large intakes
on the chassis floor for mounting fans, which when left open will
disrupt front intake and rear exhaust flows.  It can mount two front
fans and top fans but they are not included.  After buying these fans
its cost is higher than the Enermax.  But since the Enermax and others
are not available to you, if you go with this Shinobi chassis, I
recommend the following:

1.  Affix strips of 2" wide or wider clear box packing tape, or full
sheet letter size contact paper, to the inside of both the bottom and
top intake grills.  This will seal them and prevent airflow, and will be
invisible from the outside.  I've done this many times, works great.
This forces all intake air to come through the drive cages and out the
rear fans.

2.  Use a PSU with a 120mm fan.

3.  Toss out the included el cheapo rear 120mm fan and replace it with
one of these, or a similar high quality model with 80-100 CFM flow rate
and ~40 dB SPL:

http://www.frozencpu.com/products/5642/fan-285/Panaflo_H1A_120mm_Hi-Speed_Fan_BX_w_RPM_Sensor_FBA12G12H1BX.html?tl=g36c15s562

http://www.frozencpu.com/products/17229/fan-1059/Sanyo_Denki_120mm_x_38mm_High-Speed_Fan_-_1025_CFM_109R1212H1011.html?tl=g36c15s562

http://www.frozencpu.com/products/15715/fan-986/Delta_120mm_x_25mm_Fan_-_827_CFM_AFB1212H-R00_Bare_Wire.html?tl=g36c15s60

With one of these and a PSU fan you won't need any fans in front cage
locations.  If you find it's too loud get a generic self adhesive foam
damping kick.  They're quite effective.  If still too loud, use a fan
controller, but don't turn it down to far.

-- 
Stan

