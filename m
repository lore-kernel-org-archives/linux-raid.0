From: Tobias McNulty <tobias@caktusgroup.com>
Subject: Re: HBA Adaptor advice
Date: Fri, 20 May 2011 16:58:52 -0400
Message-ID: <BANLkTimBX-oCoOT2+GSSzAbs0U_MNv2Mpw@mail.gmail.com>
References: <4DD50C89.8060006@wildgooses.com> <4DD5867A.2090102@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD5867A.2090102@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, May 19, 2011 at 5:07 PM, Brad Campbell
<lists2009@fnarfbargle.com> wrote:
>
> On 19/05/11 20:26, Ed W wrote:
>
>> Please add suggestions for good value, reliable controllers known to
>> work well with linux
>
> I have three of these :
>
> http://www.startech.com/product/PEXSATA24E-2-Port-eSATA-4-Port-SATA-P=
CI-Express-x4-SATA-Controller-Adapter-Card-PCIe
>
> and 4 of these :
>
> http://www.ebay.com.au/itm/IBM-M1015-46M0861-ServeRAID-M1015-SAS-SATA=
-Controller-/280655527117?pt=3DAU_Server_Accessories_Parts&hash=3Ditem4=
1585f7ccd
>
> All of which I can't recommend highly enough.
>
> I got the Startech ones cheap from a dodgy shop about 4 years ago. Th=
ey cost me about $30 each.
> I got the IBM (really LSI) ones cheap from ebay at about $110 each at=
 Christmas.
>
> The Startech cards use the sata_mv driver and are solid, the LSI card=
s use the megaraid_sas driver and are solid. As a bonus of having SAS p=
orts, I picked up 4 Seagate Cheetah 15k.5 SAS drives for a wicked fast =
RAID10 array.

So, I've been through 3 cards in my current NAS, all of which didn't
fit my needs for one reason or another, and I had given up until this
thread reignited my interest in having more than 6 available SATA
ports in the box. The cards I've tried are:

* SYBA SD-PEX40031 (Pericom PI7C9X111 + Silicone Image Sil3124
chipset) - lots of errors during heavy I/O such as resyc'ing
* 3ware 9650SE-8LPML-Sgl - I thought money would solve the problem,
but I didn't realize that you can't use an expensive RAID card to
access existing data on the disk
* Supermicro AOC-Saslp-MV8 - I thought it would be a perfect match
given my Supermicro motherboard, but also gave me lots of errors
during heavy I/O and this experience seems to be confirmed by other
users in this thread

In all cases switching back to the onboard SATA ports resulted in
seamless operation (same drives, cables, etc.).

In light of what I've learned in this thread I just ordered the
Rosewill RC-218 SATA card, which has the same=A0Marvell 88SX7042 chipse=
t
as the Startech link above, but runs only $80 on Newegg [1] and seems
to have good reviews from a few Linux users.  I'll report back after I
get it installed next week.

Cheers,
Tobias

[1]=A0http://www.newegg.com/Product/Product.aspx?Item=3DN82E16816132018
--
Tobias McNulty, Managing Member
Caktus Consulting Group, LLC
http://www.caktusgroup.com
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
