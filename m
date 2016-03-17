From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Raid server Motherboard recommendation.
Date: Thu, 17 Mar 2016 10:52:52 +0100
Message-ID: <20160317095252.GA3822@EIS>
References: <5643FD4A.4070709@gmail.com>
 <20151112122908.0406d170@natsu>
 <56449EE5.3010002@gmail.com>
 <20151112151105.GA32385@EIS>
 <56E9E056.7000204@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56E9E056.7000204@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ram Ramesh <rramesh2400@gmail.com>
Cc: Roman Mamedov <rm@romanrm.net>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Mar 16, 2016 at 05:38:14PM -0500, Ram Ramesh wrote:
> If you don't mind, could you share with me the standalone card that you 
> use?

I think this is the same I use:

http://www.ebay.com/itm/PCI-E-Express-SATA3-SATA3-0-6Gb-s-eSATA-SATA-III-Card-ASMEDIA1061-/231378681315

It has two ports, and you can choose between internal and external via 4 jumpers per port.

You also find this Asmedia chipset on a lot of Asus/Asrock mainboards that have two additional SATA ports.

> BTW, have you stressed your card through a rebuild/checkarray?

I run checkarray every day (each day a different part of disk so entire disk is covered in a week or so) with no issue.

I also mirror my single SSD disk to the HDD RAID once a week.

I can run a mkfs.ext4 -c -c on a LVM partition at a later time, but so far no issues whatsoever.

Regards
Andreas Klauer
