From: maurice <mhilarius@gmail.com>
Subject: Re: SSD - TRIM command
Date: Tue, 08 Feb 2011 10:37:19 -0700
Message-ID: <4D517F4F.4060003@gmail.com>
References: <AANLkTikfeH_n04iJ=5e=_G4a_GrxiWyZNJ1oCYyiBhNO@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikfeH_n04iJ=5e=_G4a_GrxiWyZNJ1oCYyiBhNO@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2/7/2011 1:07 PM, Roberto Spadim wrote:
> hi guys, could md send TRIM command to ssd? using ext4 discart mount option?
> if i mix ssd and hd, could this TRIM be rewrite to non TRIM compatible disks?
>
I have read that using md with SSDs is not a great idea:
Form the Fedora 14 documentation:

"Take note as well that software RAID levels 1, 4, 5, and 6 are not 
recommended for use on SSDs.
During the initialization stage of these RAID levels, some RAID 
management utilities (such as mdadm)
write to all of the blocks on the storage device to ensure that 
checksums operate properly.
This will cause the performance of the SSD to degrade quickly. "

https://docs.fedoraproject.org/en-US/Fedora/14/html/Storage_Administration_Guide/newmds-ssdtuning.html


-- 
Cheers,
Maurice Hilarius
eMail: /mhilarius@gmail.com/
