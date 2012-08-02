From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: OT: silent data corruption reading from hard drives
Date: Thu, 02 Aug 2012 02:51:08 -0500
Message-ID: <501A316C.3020305@hardwarefreak.com>
References: <50191ADE.10809@fastmail.fm> <5019D052.4000409@hardwarefreak.com> <20120802091917.32fb0ca5@natsu>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120802091917.32fb0ca5@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: matt <listy@fastmail.fm>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 8/1/2012 10:19 PM, Roman Mamedov wrote:
> On Wed, 01 Aug 2012 19:56:50 -0500
> Stan Hoeppner <stan@hardwarefreak.com> wrote:
> 
>> On 8/1/2012 7:02 AM, matt wrote:
>>> Is silent data corruption like this simply to be expected when using cheap
>>> commodity hardware?
>>
>> When you pay less than 1/4th the price of one drive for the controller
>> card directing all your drives, is it really necessary to ask this question?
>>
>> Two large pizzas cost more than a Syba/Rosewill/Koutech/etc SATA card.
>> The pizza is consumed in one night, maybe some for breakfast.  Would you
>> trust a day worth of pizza with your RAID?  With your data?
>>
>> One tank of gas for the average car today costs $50, the same as two of
>> these SATA cards.  The gas is gone in a week or two.  You want the cards
>> to run for 2-4 years.
>>
>> Your drives cost anywhere from $400-$1000, yet your controller maybe
>> $50.  Do I really need to say any more?  Spend $150-250 on a decent
>> SAS/SATA controller such as an LSI or Adaptec and you won't have to
>> worry about this kind of thing.
> 
> While you're at it also don't forget to get yourself some quality
> Ethernet cabling, you don't want any data corruption on your LAN, do you
> http://www.amazon.com/Denon-AKDL1-Dedicated-Link-Cable/dp/tech-data/B000I1X6PM/ref=de_a_smtd

The hyperbole isn't necessary Roman, and detracts from your argument.

> It's not a matter of "just pay more and all your problems will be solved".

I didn't say, nor imply such a thing.  You missed my point entirely
about dollar amount.  It had two aspects:

1.  Some people are willing to spend hundreds or thousands on drives,
then hook them to $15 controllers without giving that ratio a thought,
no reflection upon the sanity of it.

2.  $150-250 is the price range of about a dozen high quality HBAs on
the market.  I don't have the time to go out and identify and then list
them all here.  Mentioning the price range simply makes sure people will
be looking at the right cards.

> There are some really crappy controllers even in the "enterprise" range
> (e.g. those using the mv_sas driver). 

First, there are not "enterprise" controllers that use the Marvell SAS
chip, period.  It's a low/mid cost, entry level 8 port SAS ASIC.  The
cards based on it a not crappy, but actually pretty decent.  They run
very well with Windows, *BSD, SCO, NetWare, and other OSes.  It just
happens that the Linux driver, yes mv_sas, totally sucks, despite
continuous development.  In fact, hop on the linux-scsi mailing list and
you can chat with who I believe is the primary developer of that driver,
Xiangliang Yu.  He works for Marvell.

> And there's a lot of $15 models giving
> zero problems whatsoever (e.g. the ahci-compliant Marvell 88SE912x, JMicron
> JMB36x). 

You're confusing SATA controller ASICs, which may be of high quality and
have quality drivers, with HBAs, which are the finished products that
incorporate these ASICs.  The HBAs also incorporate many other ICs and
analog parts, which are often of questionable quality in the $15-30
range of HBAs.  You're buying an HBA, not just the SATA ASIC.  QC/QA in
the manufacture of HBAs that retail for these prices is very low
compared to more expensive models.  And you can't get support from the
manufacturer.  Call Syba, Rosewill, Koutech, etc, and see how helpful
they are--if you can get a hold of anyone that is.  Then call LSI.

> Also, if you only use the mdadm software RAID, getting an enterprise hardware
> RAID controller is truly a waste of money, unless you really need the extra
> port density.

That logic is flawed.  If you have an enterprise hardware RAID
controller you're not going to use md/RAID, unless you're stitching LUNs
together with linear or RAID0, as I often do.  In fact that's my most
frequent use of md/RAID--concatenation of hardware RAID or SAN LUNs.

If you're talking about enterprise class HBAs, your logic is still
flawed.  Not only are they higher quality and performance, but you can
daisy chain multiple expanders to them.  The $175 LSI 9211-4i is a
4-port (single 8087) enterprise HBA that can attach up to 256 SAS/SATA
drives using fanned or daisy chained expanders.  You simply can't do
this with SATA port multipliers, which still tend to have compat issues
quite often.

The most you can get is 5 downstream SATA links per PMP.  And the PMPs,
the SiI based models, are almost $100 a pop.  So a 4 port SiI HBA with 4
SiI PMPs gets you 20 drives connected for ~$450 at PCIe 1.0 x1, for
250MB/s one way.  Or you can buy the LSI 9211-4i and the Intel 24-port
SAS expander for ~$400 at PCIe 2.0 x4, for 2GB/s one way.

In this case not only is the "enterprise" HBA solution cheaper, it's
also without compatibility issues or bugs, has excellent support, and
has an 8x faster bus, and a much faster ASIC able to handle over 20x the
IOPS.  Sure, there are Marvell based PCIe x4 cheapo HBAs, Rosewill makes
a 4 port model, but the Marvell SATA chips don't work with the SiI PMPs
very well, if at all, and AFAIK nobody offers a standalone Marvell PMP,
nor any other PMP.  SiI pretty much has the PMP market to itself.

-- 
Stan

