From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Failing disk?
Date: Thu, 26 Jun 2003 09:14:39 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16122.11487.594097.921234@gargle.gargle.HOWL>
References: <20030625183111.GF21580@rdlg.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Robert L. Harris on Wednesday June 25
To: "Robert L. Harris" <Robert.L.Harris@rdlg.net>
Cc: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday June 25, Robert.L.Harris@rdlg.net wrote:
> 
> 
> I'm asking this on the raid list even though it's LVM related for 2
> reasons.  It's the best list I know of for this question and because the
> LVM in question is disk 0 in a RAID 1 scheme so it's not 100 % off
> topic.
> 
> I've got an lvm which consists of drive sda and sdbc.  One of the two
> disks is complaining about scsi errors.  I get this on the console:
> 
> md: lvm-vg2/lvm2 [events: 0000000b]<6>(write) lvm-vg2/lvm2's sb offset:
> 35618752
>  I/O error: dev 08:22, sector 35430824
>  I/O error: dev 08:22, sector 35431072
>  I/O error: dev 08:22, sector 35431320
>  I/O error: dev 08:22, sector 35431568
>  I/O error: dev 08:22, sector 35431816
>  I/O error: dev 08:22, sector 35432064
>  I/O error: dev 08:22, sector 35432312
> 
> 
> Am I correct in assuming that the 22 is hex which translates to 34

Yes.

> giving me:
> root@performance.tok:~# cat /proc/partitions 
> major minor  #blocks  name
> 
>   58     0   35618816 lvm-vg1/lvm1
>   58     1   35618816 lvm-vg2/lvm2
>    9     0   35618752 md/0
>    8     0   17921835 scsi/host0/bus0/target0/lun0/disc
> .
> .
> .
>    8    33     104422 scsi/host0/bus0/target2/lun0/part1
>    8    34   17816085 scsi/host0/bus0/target2/lun0/part2
> 
> 
> Meaning it's partition 2 of disk hdc (host 0 target 2)?
> 
> Thoughts?

Replace the disc...

or was there some other though you were after?

NeilBrown

>   Robert
> 
> 
> 
> 
> :wq!
> ---------------------------------------------------------------------------
> Robert L. Harris                     | GPG Key ID: E344DA3B
>                                          @ x-hkp://pgp.mit.edu
> DISCLAIMER:
>       These are MY OPINIONS ALONE.  I speak for no-one else.
> 
> Diagnosis: witzelsucht
> 
> IPv6 = robert@ipv6.rdlg.net	http://ipv6.rdlg.net
> IPv4 = robert@mail.rdlg.net	http://www.rdlg.net
