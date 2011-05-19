From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: HBA Adaptor advice
Date: Fri, 20 May 2011 05:07:06 +0800
Message-ID: <4DD5867A.2090102@fnarfbargle.com>
References: <4DD50C89.8060006@wildgooses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD50C89.8060006@wildgooses.com>
Sender: linux-raid-owner@vger.kernel.org
To: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 19/05/11 20:26, Ed W wrote:

> Please add suggestions for good value, reliable controllers known to
> work well with linux

I have three of these :

http://www.startech.com/product/PEXSATA24E-2-Port-eSATA-4-Port-SATA-PCI-Express-x4-SATA-Controller-Adapter-Card-PCIe

and 4 of these :

http://www.ebay.com.au/itm/IBM-M1015-46M0861-ServeRAID-M1015-SAS-SATA-Controller-/280655527117?pt=AU_Server_Accessories_Parts&hash=item41585f7ccd

All of which I can't recommend highly enough.

I got the Startech ones cheap from a dodgy shop about 4 years ago. They cost me about $30 each.
I got the IBM (really LSI) ones cheap from ebay at about $110 each at Christmas.

The Startech cards use the sata_mv driver and are solid, the LSI cards use the megaraid_sas driver 
and are solid. As a bonus of having SAS ports, I picked up 4 Seagate Cheetah 15k.5 SAS drives for a 
wicked fast RAID10 array.

Regards,
Brad
