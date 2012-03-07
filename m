From: Danilo Godec <danilo.godec@agenda.si>
Subject: Re: Raid failure - drives or controller?
Date: Wed, 07 Mar 2012 22:08:32 +0100
Message-ID: <4F57CE50.2000203@agenda.si>
References: <4F57A05E.6000204@agenda.si> <20120307133349.1a1fb307@bettercgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120307133349.1a1fb307@bettercgi.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Ray Morris <support@bettercgi.com>
List-Id: linux-raid.ids

On 7.3.2012 20:33, Ray Morris wrote:
>> drives or controller?
> Don't forget cables and loose connections. 
> We've had more cable problems than anything else.

Sorry, I should've probably mention the hardware specs in the first place:

The server is an Intel SR2612UR with 12-drive SAS/SATA backplane with an
Attotech ExpressSAS H608 (PCIe) SAS controller and a single Mini-SAS
SFF-8087 cable between controller and backplane.

Drives are 'WD1002FBYS' (WD RE3 'enterprise' models), 7 of them (6 RAID5
+ 1 spare).

The OS (OpenSuSE 11.4 x86_64) is installed on a separate SATA SSD,
connected to on-board SATA controller. The driver for the controller is
'esas2hba' version 1.65, supplied by Attotech.

   D.

