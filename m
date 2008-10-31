From: Mike Myers <mikesm559@yahoo.com>
Subject: Re: Adaptec raid congtrollers for SATA disks under software raid
Date: Fri, 31 Oct 2008 11:09:23 -0700 (PDT)
Message-ID: <39398.82011.qm@web30802.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Well, actually if the chips that manufacturer A uses are faster in software raid than manufacturer L...  :-)  

thx
mike




----- Original Message ----
From: David Lethe <david@santools.com>
To: Mike Myers <mikesm559@yahoo.com>; linux-raid@vger.kernel.org
Sent: Thursday, October 30, 2008 10:21:00 PM
Subject: Re: Adaptec raid congtrollers for SATA disks under software raid

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



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



      
