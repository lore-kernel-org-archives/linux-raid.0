From: Mircea Ciocan <mirceac@interplus.ro>
Subject: Re: Please help with a special RAID 1 setup
Date: Wed, 07 Jan 2004 22:17:13 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3FFC6949.1060101@interplus.ro>
References: <8075D5C3061B9441944E137377645118012F02@cinshrexc03.shermfin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8075D5C3061B9441944E137377645118012F02@cinshrexc03.shermfin.com>
To: "Rechenberg, Andrew" <ARechenberg@shermanfinancialgroup.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Rechenberg, Andrew wrote:

> 
>
>  
>
>>-----Original Message-----
>>From: linux-raid-owner@vger.kernel.org 
>>[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Cress, Andrew R
>>Sent: Wednesday, January 07, 2004 9:48 AM
>>To: Catalin BOIE; Mircea Ciocan
>>Cc: linux-raid@vger.kernel.org
>>Subject: RE: Please help with a special RAID 1 setup
>>
>>
>>Note that RAID-1 will only ever have a maximum of 2 active disks.
>>    
>>
>
>I don't believe that the above is a correct statement.  Linux software
>RAID1 will allow mirroring across more than 2 devices:
>
>[root@cinshrlnxlap01 ~]# cat /proc/mdstat
>Personalities : [raid1]
>read_ahead 1024 sectors
>md2 : active raid1 [dev 01:02][2] [dev 01:01][1] [dev 01:00][0]
>      4032 blocks [3/3] [UUU]
>
>  
>
    This is a refershing info, depressing is the fact that a slice can't 
be added unobrtusively ( sp ?), I'll try Luca's solution first than 
scratch & rebuild if this will be a resounding failure  ;).

[SNIP]

>We had a "triple" mirror sofware RAID setup on a box as a "poor man's
>snapshot" before we started using LVM.  We triple mirrored and then
>broke one mirror to backup and then added the removed disk back into the
>array and re-synched.  LVM snapshots are much more elegant and LVM
>provides more functionality such as extended volumes when you want to
>add more space.  You have to be careful using LVM because as of 2.4.18
>there was a Linux VM bug that would not allow snapshotting with greater
>than about 6GB of system RAM.
>
>However, I would recommend recreating the filesystem on top of LVM and
>using snapshots to accomplish what you want.  We use LVM on top of SW
>RAID with great success.
>
>  
>
    Ha, so I'm not the only one crazy enough to propose such a solution, 
I'm happy that I'm not alone :),  did it worked ??
I belive that was designed and initialised from the first time as a 3 
slice raid, the 3rd slice wasn't aded as an aftertought ??

The raid boxes have 4GiB RAM so is not a problem, BTW to you have a 
pointer for starting the RTFM about that LVM and especially those 
snapshots, is there a posibility to to save the inital setup with 2 
slices or everything has to be destroyed and recreated again???

    Best regards,

    Mircea

