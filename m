From: Arshavir Grigorian <ag@m-cam.com>
Subject: RAID0+1
Date: Wed, 16 Mar 2005 14:23:09 -0500
Message-ID: <4238879D.7040608@m-cam.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have a RAID1+0 array. During boot time, RAID1 arrays get correctly 
detected and activated. But RAID0 fails to come up. I am guessing the 
reason the RAID0 cannot be autodetected is that it's built on other md 
devices and not a physical disk. Anyone knows how to get around this?

I am using Debian Sarge with mdadm -v1.9.0 running a custom compiled 
2.4.27 kernel.

TIA.


-- 
Arshavir Grigorian
Systems Administrator/Engineer
M-CAM, Inc.
