From: "G, Sushma" <Sushma.G@lsi.com>
Subject: Boot from degraded MD array
Date: Thu, 18 Nov 2010 20:55:38 +0530
Message-ID: <9181E99F41C081478B455A70FC1D01CB0A4C3E6B@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I wanted to know if there is a way to activate a degraded array be default.

 In a scenario where OS is installed on a MD R1 array, with no spares configured, if a physical drive fails is there a way to still boot in to OS, without having to configure a hot spare?
Also, is R5 different in any way, in the same scenario mentioned above ( R5 in degraded mode)?"

Setup: 
Create a R1 using 2 sata disks, using mdadm with SLES 11 SP1 Operating system.
Once OS is installed, shut down the system and fail a drive.  now try to boot up the OS.

OS boot fails because the RAID is inactive as the VD is degraded.


Regards,

Sushma Govind



