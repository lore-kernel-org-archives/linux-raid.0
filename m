From: Mikko Saukkoriipi <msaukkor@msaukkor.cjb.net>
Subject: Re: powersupply for 16disks +dual xeon
Date: Sun, 02 Feb 2003 17:51:08 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E3D3E6C.1060602@msaukkor.cjb.net>
References: <Pine.LNX.4.53.0302011823430.6789@ddx.a2000.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.53.0302011823430.6789@ddx.a2000.nu>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Stephan van Hienen wrote:

>today tried to put 16 disks (15*ide7200 +1*scsi7200) in a intel sc5200
>case
>(which has an 450W powersupply)
>
>when i try to powerup the system, the powersupply goes off after 3 seconds
>i think this is because off the spinupp for the disks
>
>any tips how to fix this ?
>(as far as i know there is no spinup delay for ide disks)
>maximum powersupply i found is 550W, not much more than i have in my
>system
>
>(i need an 24pin xeon powersupply)
>
>(disks are WD180GB (which asks 15W for spinup)
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  
>
More important than getting larger wattage powersupply is to find one 
that can provide enough power on the 12V rail. All powersupplies are 
really not built the same. I have a cheap and shitty 450W Q-tec 
powersupply in my server with 7 harddrives. It kept crashing when 
copying between harddrives. I found Firingsquad's powersupply guide(1) 
and calculated that my server requires 20A on the 12V rail, but the 
powersupply could only deliver 12A/15A Max. Now I have 2 AT 
powersupplies for the harddrives, but this is not a good solution. My 
friend recently bought a 465W Enermax that can provide 33A in the 12V 
rail. What I've seen, Enermax PSUs provide most power to the 12V rail. 
Fortron-Source top-end models would be another possibility, like 
FSP550-60PLG.

Miksa

