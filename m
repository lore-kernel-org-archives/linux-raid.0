From: Arshavir Grigorian <ag@m-cam.com>
Subject: Re: RAID0+1
Date: Wed, 16 Mar 2005 15:31:09 -0500
Message-ID: <4238978D.5090809@m-cam.com>
References: <4238879D.7040608@m-cam.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <4238879D.7040608@m-cam.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Arshavir Grigorian wrote:
> Hi,
> 
> I have a RAID1+0 array. During boot time, RAID1 arrays get correctly 
> detected and activated. But RAID0 fails to come up. I am guessing the 
> reason the RAID0 cannot be autodetected is that it's built on other md 
> devices and not a physical disk. Anyone knows how to get around this?
> 
> I am using Debian Sarge with mdadm -v1.9.0 running a custom compiled 
> 2.4.27 kernel.

Fixed. The RAID1 devices need to be listed in mdadm.conf as DEVICES in 
addition to the physical disks/partitions.
