From: Tyler <pml@dtbb.net>
Subject: Re: Any way to Increase MD_SB_DISKS=27 ? I need 31 devices
Date: Tue, 03 May 2005 04:22:33 -0700
Message-ID: <42775EF9.7030009@dtbb.net>
References: <427583FA.7030704@dtbb.net> <42764014.5060909@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42764014.5060909@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Paul,

Isn't the superblock still limited to 27 drives though? .. is there 
maybe a patch for version 1 superblocks that i don't have in 
2.6.12-rc3-mm2, that changes the max drives in the md_p.h and md.c 
driver?  There is only 4096 bytes earmarked for superblocks, and within 
that amount, there isn't enough room to list more than 27 drives that 
may be part of the same array.

Do I need some more patches for this to work, that aren't in the -mm 
tree yet?  I was under the impression (from the mdadm v2.0 announce 
file, that anything *after* 2.6.11-rc3 in the -mm tree would have the 
required patches.

Also, where can I disable the check in mdadm?

Thanks,
Tyler.

Paul Clements wrote:

> Tyler wrote:
>
>> PS - I've tryed the latest 2.6.12-rc3-mm2 kernel, with mdadm 
>> v2.0-devel, using the --metadata 1.0 option on the create line, and 
>> still get:
>
>
>> # mdadm -C -e 1.0 -l 6 -n 31 /dev/md0 /dev/hdb /dev/hdc /dev/hdd 
>> /dev/sda /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg 
>> /dev/sdh /dev/sdi /dev/sdj /dev/sdk /dev/sdl /dev/sdm /dev/sdn 
>> /dev/sdo /dev/sdp /dev/sdq /dev/sdr /dev/sds /dev/sdt /dev/sdu 
>> /dev/sdv /dev/sdw /dev/sdx /dev/sdy /dev/sdz /dev/sdaa /dev/sdab
>> mdadm: invalid number of raid devices: 31
>
>
> As far as I can tell, mdadm just shouldn't give this error when you're 
> using a version 1 superblock. If you disable that check in mdadm.c, I 
> think everything will work. Version 1 superblocks allow something like 
> 2000 disks in an array.
>
> -- 
> Paul

