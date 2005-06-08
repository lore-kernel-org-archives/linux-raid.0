From: Konstantin Olchanski <olchansk@sam.triumf.ca>
Subject: Re: 3Ware on 64bit Linux.
Date: Wed, 8 Jun 2005 14:36:15 -0700
Message-ID: <20050608213615.GC14944@sam.triumf.ca>
References: <602f2f2b050608100938ddad81@mail.gmail.com> <200506081156.31051.hjm@tacgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200506081156.31051.hjm@tacgi.com>
Sender: linux-raid-owner@vger.kernel.org
To: Harry Mangalam <hjm@tacgi.com>
Cc: Jason Leach <jason.leach@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 08, 2005 at 11:56:30AM -0700, Harry Mangalam wrote:
> I have what is probably a relatively common setup for a medium high end, 
> stand-alone, PC-based server:
> 
> - dual opteron IWILL Mobo, Gb ethernet
> - 3ware 9500S 8 port card running 8x250GB WD 2500SD disks in RAID5.  
> - Disks are in 2x 4slot Chenbro hotswap RAID cages. 
> - running kubuntu Linux in pure 64bit mode
> - OS is running from a separate 200GB IDE disk 
> - on an APC UPS (runnning apcupsd w/ a usb cable)

I have a 3ware 8506-12 SATA controller with 12 WD 250 GByte SATA disks,
on an old dual opteron-242 Tyan mobo. The system disk is a
separate 80 GB IDE disk. The SATA disks are confugured into 2
striped (one hardware raid, one software raid) logical volumes (1.5 TB
each). The box and the hot-swap disk enclosure is el-cheapo stuff
from Hard Data in Edmonton, AB (works great!).

This system has been rock solid from day one, running RedHat 9 (32-bit),
then Fedora 1 (32-bit), than Fedora 2 and 3 (64-bit).

I use the 3ware driver that comes with the Red Hat kernels, the
additional monitoring tools from 3ware do not work. SMART monitoring
works via "smartctl -a -d 3ware,0 /dev/twe0".

-- 
Konstantin Olchanski
Data Acquisition Systems: The Bytes Must Flow!
Email: olchansk-at-triumf-dot-ca
Snail mail: 4004 Wesbrook Mall, TRIUMF, Vancouver, B.C., V6T 2A3, Canada
