From: Mike Hardy <mhardy@h3c.com>
Subject: Re: Migrating from SINGLE DISK to RAID1
Date: Tue, 01 Feb 2005 11:34:31 -0800
Message-ID: <41FFD9C7.2090208@h3c.com>
References: <41FFD1F8.3010101@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <41FFD1F8.3010101@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Heinzmann <Robert.Heinzmann@gmx.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Robert Heinzmann wrote:
> Hello,
> 
> can someone verify if the following statements are true ?
> 
> - It's not possible to simply  convert a existing partition with a 
> filesystem on it to a raid1 mirror set.

I believe you're right, but I'm not totally sure on this one. I'd take 
the second disk, create a new RAID1 with the first drive "missing" on 
the mdadm --create commandline, copy everything over to it, put grub on 
it, then test that it boots correctly by pulling the first drive out.

Only once the RAID1 is working (in degraded mode) add the original first 
drive back in, but booting off the RAID1, then add it to the RAID set to 
complete the pair. With that process, the question is somewhat moot, 
although I'm interested in the real answer too

> - Using a former disk of a raid1 array as a usual disk (not mounted as 
> degrated /dev/mdX, but instead mounted as /dev/sdX or /dev/hdX) is 
> successfull.
> 
> This is because the MD device layer reports the device size as size of 
> disk - superblock offset during the creation of a filesystem on the MD 
> device. Thus the used size of the disk, when mounting it as /dev/sdX 
> /dev/hdX, is some KB smaller than it could be, but no data is lost.

This matches my experience, although autodiscovery can get in your way, 
as you mention yourself

-Mike
