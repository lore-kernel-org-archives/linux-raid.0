From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID5 with 2 drive failure at the same time
Date: Sat, 02 Feb 2013 20:22:01 -0500
Message-ID: <510DBBB9.5030300@turmel.org>
References: <510A4AAE.6000009@evilazrael.de> <20130131113820.GA20536@cthulhu.home.robinhill.me.uk> <510A6E54.5050001@evilazrael.de> <CAF3D534-D907-4A88-AFAF-EA9B97C1D8BF@colorremedies.com> <20130131221007.GA1447@cthulhu.home.robinhill.me.uk> <88758108-9333-4224-9006-8E44E717AB29@colorremedies.com> <20130201133455.GA24375@cthulhu.home.robinhill.me.uk> <9F0E4AF3-4358-425F-8078-C068D5BB9487@colorremedies.com> <20130201195734.GA16573@cthulhu.home.robinhill.me.uk> <510C5E3F.8090807@evilazrael.de> <510C6AB6.8040900@turmel.org> <510D36D7.5050704@evilazrael.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <510D36D7.5050704@evilazrael.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Nelles <evilazrael@evilazrael.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/02/2013 10:55 AM, Christoph Nelles wrote:

[trim /]

> You are right, the Hitachis support that. I thought disabled means not
> possible. My fault.
> Nevertheless I put the smartctl -x -a logs at
> http://evilazrael.net/bilder2/logs/smart_xa_20130202.tar.gz

Very good.

> I am currently reading about TLER, and i am wondering why I haven't
> heard of that before. Looks like the lower power consumption is not the
> only advantage of the WDC Red Edition. Most reviews do not go so deep
> into detail.

"TLER" == "Time Limited Error Recovery", which is WD's name for "SCTERC"
== "Sata Command Transport, Error Recovery Control".  Same purpose.

> sdg is a new WDC Red I bought today so all drives from sdg moved one
> letter down.
> 
> Spent the last three hours analysing why the second onboard controller
> does not detect the new HDD. In the end it's a Marvell, IOMMU and linux
> driver problem:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1005226
> https://bugzilla.kernel.org/show_bug.cgi?id=42679

That sucks.

> Marvell = PITA :(

Indeed.

[trim /]

>> If you did destroy that drive's contents, you need to clean up the UREs
>> on the other drives with dd_rescue, then "--assemble --force" with the
>> remaining drives.
> 
> ddrescue is running, this will take some hours.

Ok.

>> I think it would be useful to provide a fresh set of "mdadm --examine"
>> reports for all member disks, along with a partial listing of
>> /dev/disk/by-id/ that shows what serial numbers are assigned to what
>> device names.
> 
> How do the serial numbers help?

It is vital to keep track of raid device number (logical position in the
array) versus drive serial numbers, as device names are not guaranteed
to be consistent between boots (and certainly not when mucking around
with cables and connectors).

> I attached both to this mail.

Ok.

Summarizing:

ata-SAMSUNG_SSD_830_Series_S0XYNEAC504407 -> ../../sda
ata-ST3000DM001-9YN166_Z1F0D9AW -> ../../sdb
ata-WDC_WD30EZRX-00MMMB0_WD-WMAWZ0236402 -> ../../sdc
ata-WDC_WD30EZRS-00J99B0_WD-WCAWZ0319650 -> ../../sdd
ata-WDC_WD30EFRX-68AX9N0_WD-WMC1T1267036 -> ../../sde
ata-WDC_WD30EURS-63R8UY0_WD-WCAWZ2236938 -> ../../sdf
ata-WDC_WD30EFRX-68AX9N0_WD-WMC1T2001070 -> ../../sdg
ata-Hitachi_HDS723030ALA640_MK0311YHG6DS3A -> ../../sdh
ata-Hitachi_HDS723030ALA640_MK0311YHG32VNA -> ../../sdi
ata-Hitachi_HDS723030ALA640_MK0311YHG248EA -> ../../sdj
ata-WDC_WD30EZRX-00MMMB0_WD-WCAWZ1394037 -> ../../sdk

and

/dev/sdb1:
   Device Role : Active device 6
/dev/sdc1:
   Device Role : Active device 0
/dev/sdd1:
   Device Role : Active device 3
/dev/sde1:
   Device Role : Active device 8
/dev/sdf1:
   Device Role : Active device 7
/dev/sdh1:
   Device Role : spare
/dev/sdi1:
   Device Role : Active device 2
/dev/sdj1:
   Device Role : Active device 4
/dev/sdk1:
   Device Role : Active device 5

When you are done with dd_rescue, make sure of the mapping again.
lsdrv[1] gives you both pieces of information in one utility, you might
find it easier than mapping by hand.

Phil

[1] http://github.com/pturmel/lsdrv


