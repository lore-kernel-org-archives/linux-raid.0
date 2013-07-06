From: Kai Stian Olstad <kai.stian.olstad@gmail.com>
Subject: Re: Aren't 2TB+ disk sizes supposed to be standardized?
Date: Sat, 06 Jul 2013 09:50:25 +0200
Message-ID: <51D7CC41.1090105@gmail.com>
References: <51D65778.9010502@smartguide.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51D65778.9010502@smartguide.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Tudor Holton <tudor@smartguide.com.au>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/05/2013 07:19 AM, Tudor Holton wrote:
> $ sudo fdisk -l
> Disk /dev/sdc: 2000.4 GB, 2000397852160 bytes
> 255 heads, 63 sectors/track, 243201 cylinders, total 3907027055 sectors
> 
> $ sudo smartctl -a /dev/sdc
> Model Family:     Seagate Barracuda (SATA 3Gb/s, 4K Sectors)
> Device Model:     ST2000DM001-1CH164
> Firmware Version: CC43
> User Capacity:    2,000,397,852,160 bytes [2.00 TB]

According to the product manual this disk has guaranteed sectors count
of 3,907,029,168 (one sector counts as 512 bytes).

3,907,029,168 * 512 = 2,000,398,934,016 bytes

As Mikael wrote is probably your controller.

-- 
Kai Stian Olstad
