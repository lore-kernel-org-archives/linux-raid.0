From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: md failing mechanism
Date: Fri, 22 Jan 2016 20:00:02 +0000
Message-ID: <56A28A42.8060707@youngman.org.uk>
References: <56A26E11.2090703@yandex.ru> <56A28309.9080806@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56A28309.9080806@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Dark Penguin <darkpenguin@yandex.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22/01/16 19:29, Phil Turmel wrote:
> What you've described does sound like a bug, maybe.  It also sounds
> similar to traditional timeout mismatch caused by cheap desktop drives
> used in a raid array.

man smartctl

smartctl -i /dev/sd-dodgy-drive

If I run that on my drives I get

smartctl 6.4 2015-06-04 r4109 [x86_64-linux-4.1.12-gentoo] (local build)
Copyright (C) 2002-15, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda 7200.14 (AF)
Device Model:     ST3000DM001-1CH166
Serial Number:    W1F50K0F
LU WWN Device Id: 5 000c50 0737a98a4
Firmware Version: CC27
User Capacity:    3,000,592,982,016 bytes [3.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2, ACS-3 T13/2161-D revision 3b
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Fri Jan 22 19:56:47 2016 GMT
SMART support is: Available - device has SMART capability.
SMART support is: Disabled


NOTE THAT SMART SUPPORT IS DISABLED.

Yes I know I'm running with dodgy drives and a dodgy config, but smart
support should be enabled and things like ERC should be turned on. If
they're not ...

Cheers,
Wol
