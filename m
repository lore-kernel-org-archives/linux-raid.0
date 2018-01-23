From: Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>
Subject: USB-to-SATA and RAID
Date: Tue, 23 Jan 2018 21:16:14 +0100
Message-ID: <20180123201614.GI23784@otheros>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

By chance I found this statement in the Linux RAID Wiki:

"Do NOT use [USB devices] as part of your array. They have
 a timeout/disconnect mechanism which interacts very
 badly with the raid code." [0]

Could someone elaborate further on this? Does "interacts very
badly" mean that there will be potential data loss / data
corruption? Or does "very badly" just mean short, temporary
performance issues / lags upon a disk failure?

Regards, Linus

[0]: https://raid.wiki.kernel.org/index.php/Choosing_your_hardware,_and_what_is_a_device%3F#USB_devices
