From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Low cost PCI-E unRAID - Supermicro AOC-SASLP-MV8 Driver/LBA questions
 for HW owners/users
Date: Sat, 22 Jan 2011 18:49:48 -0600
Message-ID: <4D3B7B2C.5040003@hardwarefreak.com>
References: <AANLkTimp7xxQTv419oL7x6L-sbrhv1ZcEqLq+CfY6gs5@mail.gmail.com> <4D39D8B5.1090901@hardwarefreak.com> <AANLkTin2UZJc8yP6DGf2fgcDemQHznch5rGozmnL+V_u@mail.gmail.com> <4D3B0009.6020006@hardwarefreak.com> <AANLkTimqNjq6H5X5dPnM8Aw5W3NWtdY7ptGqQJ3ogJmO@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimqNjq6H5X5dPnM8Aw5W3NWtdY7ptGqQJ3ogJmO@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Michael Evans put forth on 1/22/2011 2:36 PM:

> Also, you are half right about this being a 'dream' system.  For years
> I've been using a carefully selected 6 port motherboard, and 3 PCI-e
> 1x cards to get a total of 12 ports.  However I'm looking to rebuild
> that aging system and now that I have the proper funds want to do it
> with more reliable hardware.  I wanted to buy an adapter that would
> last until whatever standard comes out in another decade or so and
> handle any drives that might come on the market within that time.

The LSI based Intel SAS HBA I mentioned, the  SASUC8I, will directly support 8
SAS/SATA drives, but using multiple SAS/SATA expanders it will support over 100
drives.  The following Intel SAS expander card is a matched partner to the SASUC8I.

http://www.newegg.com/Product/Product.aspx?Item=N82E16816117207
$280

To maximize drive count, you would directly connect 4 drives to the lower
numbered SFF8087 4 port connector with either a straight 8087 cable if you're
using a hot swap backplane with an 8087 style connector, or you'd use an 8087 to
4 SATA breakout cable if directly connecting to the drives or individual hot
swap cages.

The fun part:  You'd connect an 8087 cable from the other port on the HBA to one
of the 6 8087 connectors on the SAS expander card.  You would then connect the
remaining 5 SFF8087 ports to *20* SAS or SATA drive using the appropriate
cables.  This would give you 24 drives total.  Your aggregate bandwidth to/from
the set of 20 drives on the expander would be 1.2 GB/s full duplex or 2.4 GB/s
total.  It will be the same for the 4 direct connected drives but 4 drives
simply can't push that much data.

If you want symmetrical bandwidth for all drives, you'd simply connect both HBA
connectors to the expander, which would give you 2.4/4.8 GB/s aggregate, but
would limit you to 'only' 16 drives.  Here a are a couple rack chassis with hot
swap bays perfect for such a setup:

Inexpensive:
http://www.newegg.com/Product/Product.aspx?Item=N82E16811219039
http://www.norcotek.com/RPC-4116.php

Better quality, includes redundant PSU, twice the price:
http://www.newegg.com/Product/Product.aspx?Item=N82E16811123135
http://usa.chenbro.com/corporatesite/products_detail.php?sku=144

I've built quite a few servers over the years with Chenbro cases.  They are
excellent quality.  One of my personal servers resides in an old double wide
Chenbro pedestal chassis with 12x3.5" hot swap SCSI bays.  Been using it since
1999, not a bit of trouble with it, and it has survived 5 moves.  I've never
used the Norco products.

-- 
Stan
