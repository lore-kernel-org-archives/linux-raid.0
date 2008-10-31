From: "David Lethe" <david@santools.com>
Subject: Re: Adaptec raid congtrollers for SATA disks under software raid
Date: Fri, 31 Oct 2008 0:21:00 -0500
Message-ID: <0cbb01c93b18$993ffb16$0501a8c0@exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Myers <mikesm559@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

so you are basically asking if manufacturer A is faster than manufacturer L?   

-----Original Message-----

From:  "Mike Myers" <mikesm559@yahoo.com>
Subj:  Adaptec raid congtrollers for SATA disks under software raid
Date:  Thu Oct 30, 2008 11:45 pm
Size:  1K
To:  "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>

Hi.  I'm moving my NAS to a new motherboard and disk controller to increase the number of ports.  Right now I feed a couple PMP's worth of SATA disks with a marvell '7042 based controller, but am migrating to a supermicro 775 motherboard that has a few PCI-X slots.  I can get a couple adaptec 16 port SATA  PCI-X controllers on the cheap, but want to migrate my existing software raid arrays to the new ports, so I don't want to use the adaptec RAID software (software raid should be faster in any case). 
 
I believe if I configure the adaptec's BIOS to use JBOD mode instead of the card's RAID that each of the attached disks looks like a normal SATA port in linux that will allow them to be used with software raid in the normal way.  The question I have for the group is how good is the performance of these controllers when used as "dumb" ports in software raid mode?   
 
Are the LSI megaraid cards better? 
 
I'm curious as to what people think the best SATA controller is these days that has 8 or 16 ports per card driving software raid? 
 
thanks much! 
mike 
 
 
       
-- 
To unsubscribe from this list: send the line "unsubscribe linux-raid" in 
the body of a message to majordomo@vger.kernel.org 
More majordomo info at  http://vger.kernel.org/majordomo-info.html 
 


