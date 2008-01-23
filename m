From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: identifying failed disk/s in an array.
Date: Wed, 23 Jan 2008 07:56:41 +0100
Message-ID: <4796E529.7030502@wpkg.org>
References: <479765CF.A931.0080.0@ems.rmit.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <479765CF.A931.0080.0@ems.rmit.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Harris <michael.harris@rmit.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Harris schrieb:
> Hi,
> 
> I have just built a Raid 5 array  using mdadm and while it is running fine I have a question, about identifying the order of disks in the array.
> 
> In the pre sata days you would connect your drives as follows:
> 
> Primary Master - HDA
> Primary Slave - HDB
> Secondary - Master - HDC
> Secondary - Slave -HDD
> 
> So if disk HDC failed i would know it was the primary disk on the secondary controller and would replace that drive.
> 
> My current setup is as follows
> 
> MB Primary Master (PATA) Primary Master - Operating System
> 
> The array disks are attached to:
> 
> MB Sata port 1 
> MB Sata port 2
> PCI card Sata port 1
> 
> When i setup the array the OS drive was SDA and the other SDB,SDC,SDD.
> 
> Now the problem is everytime i reboot, the drives are sometimes detected in a different order, now because i mount root via the UUID of the OS disk and the kernel looks at the superblocks of the raided drives everything comes up fine, but I'm worried that if i move the array to another machine and need to do a mdadm --assemble that i won't know the correct order of the disks and what is more worrying if i have a disk fail say HDC for example, i wont know which disk HDC is as it could be any of the 5 disks in the PC. Is there anyway to make it easier to identify which disk is which?.

If the drives have any LEDs, the most reliable way would be:

dd if=/dev/drive of=/dev/null

Then look which LED is the one which blinks the most.


-- 
Tomasz Chmielewski
http://wpkg.org


