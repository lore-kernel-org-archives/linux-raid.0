From: antlists <antlists@youngman.org.uk>
Subject: Re: Restoring a raid0 for data rescue
Date: Sun, 2 Aug 2020 20:01:44 +0100
Message-ID: <7437ab4d-9cd1-fe53-a17a-fc9e966ccd92@youngman.org.uk>
References: <S1726630AbgHBR6v/20200802175851Z+2001@vger.kernel.org>
 <68c39e83-1155-0c8d-96a9-0418bdaf850d@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <68c39e83-1155-0c8d-96a9-0418bdaf850d@gmx.de>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: tyranastrasz@gmx.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/08/2020 19:09, tyranastrasz@gmx.de wrote:
> Hello
> 
> I've a problem with my raid0.
> The probelmatic disks (2x 1TB wdred) were in usage in my server, now
> they got replaced with 3x 4TB seagate in a raid5.
> 
> Before I turned them off, I made a backup on an external drive (normal
> hdd via USB) via rsync -avx /source /mnt/external/
> 
> Whatever happens in the night, the backup isn't complete and I miss files.
> So I put the old raid again into the server and wanted to start, but the
> Intel Raid Controller said that one of the disks are no member of a raid.
> 
> My server mainboard is from Gigabyte a MX11-PC0.
> 
> Well I made some mdadm examines, smartctl, mdstat, lsdrv logfiles and
> attached them to the mail.
> 
Ow...

This is still the same linux on the server? Because mdstat says no raid 
personalities are installed. Either linux has changed or you've got 
hardware raid. in which case you'll need to read up on the motherboard 
manual.

I'm not sure what they're called, but try "insmod raid1x" I think it is. 
Could be raid0x. If that loads the raid0 driver, cat /proc/mdstat should 
list raid0 as a personality. Once that's there, mdadm may be able to 
start the array.

Until you've got a working raid driver in the kernel, I certainly can't 
help any further. But hopefully reading the mobo manual might help. The 
other thing to try is an up-to-date rescue disk and see if that can read 
the array.

Cheers,
Wol
