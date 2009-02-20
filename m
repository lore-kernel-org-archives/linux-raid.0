From: Vladimir Ivashchenko <hazard@francoudi.com>
Subject: Re: sun x4500 soft lockup during raid creation
Date: Fri, 20 Feb 2009 20:57:39 +0200
Message-ID: <1235156259.14251.12.camel@hazard2.francoudi.com>
References: <1233174633.7008.34.camel@hazard2.francoudi.com>
	 <1233850207.13374.35.camel@hazard2.francoudi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1233850207.13374.35.camel@hazard2.francoudi.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Mark Lord <mlord@pobox.com>
List-Id: linux-raid.ids

Hi All,

Final update. I have contacted Mark Lord who gave me one patch for
2.6.29 and advised that hotplug should be stable. From my tests so far,
it is indeed so. We removed and added HDDs on our Sun X4500 during I/O
and seek activity without any errors or crashes.

On Thu, 2009-02-05 at 18:10 +0200, Vladimir Ivashchenko wrote: 
> Ok, further updates:
> 
> I have installed a 64-bit CentOS5 and put x86_64  2.6.26.8-57.fc8 Fedora
> kernel on it.
> 
> The RAID creation was mostly quiet, apart from a few softluckups as
> described below.
> 
> Then we tried inserting and removing a HDD. As expected, it didn't fully
> work properly, but at least the machine have not crashed. The arrays
> didn't have any load though. From being /dev/sdat the disk
> became /dev/sdax. For some reason mdadm was reporting the array and the
> disk itself to be healthy, but the device entry for the removed hard
> drive #19 was empty with wrong major/minor numbers.
> 
> Reading about sata_mv driver, it seems that hotplug is known to be
> problematic, so we're going to try OpenSolaris. However I have another
> X4500 for a few days, and if any developers would like me to check
> something, I will try to do it.

-- 
Best Regards,
Vladimir Ivashchenko
Chief Technology Officer
PrimeTel PLC, Cyprus - www.prime-tel.com
Tel: +357 25 100100 Fax: +357 2210 2211



