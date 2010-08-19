From: "Jiang, Dave" <dave.jiang@intel.com>
Subject: RE: getting a linux boot loader (preferably grub) installed on an
 intel imsm raid
Date: Thu, 19 Aug 2010 10:49:08 -0700
Message-ID: <D010E79907AF0D4E90B603DE907837D504666ADB3D@azsmsx504.amr.corp.intel.com>
References: <4C6CB965.7000905@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C6CB965.7000905@gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "K. Posern" <quickhelp@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of K. Posern
> Sent: Wednesday, August 18, 2010 9:56 PM
> To: linux-raid@vger.kernel.org
> Subject: getting a linux boot loader (preferably grub) installed on an
> intel imsm raid
> 
> 	b) based on mdadm-imsm. Just there seems really /no/
> documentation out
> there on how to do it (or I successfully managed to google around it
> since days now ;).

There is a section in regards to external metadata
https://raid.wiki.kernel.org/index.php/RAID_setup#External_Metadata

But I guess I need to update with additional information on how to install to it. 

Do you have Intel MSM Option ROM on your system? If so, then you create a RAID volume in the RAID optionROM and then when you do a install say for example Fedora 12, you specifiy you have "advanced storage device" (I think?) and you will see the RAID volume available for installation. I had issues with Fedora 13. There is a bug that causes crash when you attempt to install to an IMSM volume. And yes you install to the volume. The container can have 2 different RAID volumes. 
 
> P.S.: I would be still interested to hear how the two solutions that
> support an intel BIOS-supported (mdadm-imsm >=v3 and dmraid >=v1) raid
> compare to each other in terms of: speed (throughput), load/overhead
> (cpu/ram), stability, features.

Just FYI Intel is moving forward with MDRAID. 
