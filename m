From: Gerd Knops <gerti@bitart.com>
Subject: Re: RAID5 drive failure, please verify my commands
Date: Sun, 16 Jan 2005 16:14:20 -0600
Message-ID: <F856C764-680B-11D9-9A87-00039363AEBE@bitart.com>
References: <7C8198B3-67EA-11D9-9A87-00039363AEBE@bitart.com> <41EADBAE.6070400@h3c.com>
Mime-Version: 1.0 (Apple Message framework v619)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41EADBAE.6070400@h3c.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hardy <mhardy@h3c.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Jan 16, 2005, at 3:25 PM, Mike Hardy wrote:

>
>
> Gerd Knops wrote:
>> Hello all,
>> One of the dreaded Maxtor SATA drives in my RAID5 failed, after just 
>> 3 months of light use. Anyhow I neither have the disk capacity nor 
>> the money to buy it to make a backup. To make sure I do it correctly, 
>> could you folks please double-check my intended course of action? I 
>> would really appreciate that.
>
> Failed how? I have tons and tons of Maxtor drives in service, and only 
> one actually had a complete failure (verified by their utility, which 
> is present on some bootable CD I got called "UltimateBootDisk").
>
> Most of the time its just a bad sector causing a single unreadable 
> sector error, which causes the RAID code to kick the drive out. You 
> can see what the problem is by using the SMART utilities 
> (http://smartmontools.sf.net) - run a long self test 'smartctl -t long 
> /dev/sda' to verify things.
>
Seems to be a whole slew of bad sectors, here is what the log says:

scsi0: ERROR on channel 0, id 0, lun 0, CDB: Read (10) 00 15 65 40 3f 
00 00 08 00
Current sda: sense key Medium Error
Additional sense: Unrecovered read error - auto reallocate failed
end_request: I/O error, dev sda, sector 358957119
scsi0: ERROR on channel 0, id 0, lun 0, CDB: Read (10) 00 15 65 40 40 
00 00 07 00
Current sda: sense key Medium Error
Additional sense: Unrecovered read error - auto reallocate failed
end_request: I/O error, dev sda, sector 358957120
scsi0: ERROR on channel 0, id 0, lun 0, CDB: Read (10) 00 15 65 40 41 
00 00 06 00
Current sda: sense key Medium Error
Additional sense: Unrecovered read error - auto reallocate failed
end_request: I/O error, dev sda, sector 358957121
scsi0: ERROR on channel 0, id 0, lun 0, CDB: Read (10) 00 15 65 40 42 
00 00 05 00
Current sda: sense key Medium Error
Additional sense: Unrecovered read error - auto reallocate failed
end_request: I/O error, dev sda, sector 358957122
scsi0: ERROR on channel 0, id 0, lun 0, CDB: Read (10) 00 15 65 40 43 
00 00 04 00
Current sda: sense key Medium Error
Additional sense: Unrecovered read error - auto reallocate failed
end_request: I/O error, dev sda, sector 358957123
scsi0: ERROR on channel 0, id 0, lun 0, CDB: Read (10) 00 15 65 40 44 
00 00 03 00
Current sda: sense key Medium Error
Additional sense: Unrecovered read error - auto reallocate failed
end_request: I/O error, dev sda, sector 358957124
scsi0: ERROR on channel 0, id 0, lun 0, CDB: Read (10) 00 15 65 40 45 
00 00 02 00
Current sda: sense key Medium Error
Additional sense: Unrecovered read error - auto reallocate failed
end_request: I/O error, dev sda, sector 358957125
scsi0: ERROR on channel 0, id 0, lun 0, CDB: Read (10) 00 15 65 40 46 
00 00 01 00
Current sda: sense key Medium Error
Additional sense: Unrecovered read error - auto reallocate failed
end_request: I/O error, dev sda, sector 358957126
raid5: Disk failure on sda1, disabling device. Operation continuing on 
2 devices

That looks to me to be more severe than a single bad sector.

Thanks much for all your other remarks, cut to keep this post 
reasonably short. Much appreciated!

Gerd

