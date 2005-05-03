From: Tyler <tyler@dtbb.net>
Subject: Re: BUGREPORT: mdadm v2.0-devel - can't create array using version
 1 superblock, possibly related to previous bugreport
Date: Tue, 03 May 2005 04:38:33 -0700
Message-ID: <427762B9.1000802@dtbb.net>
References: <42775D47.4000805@dtbb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42775D47.4000805@dtbb.net>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@cse.unsw.edu.au
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Possibly useful information I forgot to include, that was in dmesg, just 
after trying the create with the version 1 superblock, cat /proc/mdstat 
shows/showed no raid devices active:

md: could not bd_claim hdb.
md: md_import_device returned -16

Tyler wrote:

> When i try to create any raid5/raid6 array with --metadata 1 or 
> --metadata 1.0, it simply spits out a response saying /dev/hdX is 
> busy... X being whichever drive i listed as an array member first on 
> the list of drives.  1.x.0 doesn't support version 1 superblocks, but 
> i used it as an example below without the metadata option to show that 
> creating the raid works fine, and then the same with mdadm v2.0-devel, 
> they create fine until you add the metadata option.  Kernel is 
> 2.6.12-rc3-mm2.
>
> First I create an array using v1.9.0 successfully (from system path):
>
> root@localhost:~/dev/mdadm-2.0-devel-1# mdadm -C -l 5 -n 3 /dev/md0 
> /dev/hdb /dev/hdc /dev/hdd
> mdadm: array /dev/md0 started.
> root@localhost:~/dev/mdadm-2.0-devel-1# mdadm -S /dev/md0
>
> Then successfully create an array with default superblock (0.90?) 
> using v2.0-devel (from current dir):
>
> root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm -C -l 5 -n 3 /dev/md0 
> /dev/hdb /dev/hdc /dev/hdd
> mdadm: /dev/hdb appears to be part of a raid array:
>    level=5 devices=3 ctime=Tue May  3 11:42:28 2005
> mdadm: /dev/hdc appears to be part of a raid array:
>    level=5 devices=3 ctime=Tue May  3 11:42:28 2005
> mdadm: /dev/hdd appears to be part of a raid array:
>    level=5 devices=3 ctime=Tue May  3 11:42:28 2005
> Continue creating array? y
> VERS = 9002
> mdadm: array /dev/md0 started.
> root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm -S /dev/md0
>
> Then try creating a raid with version 1 superblock, which fails:
>
> root@localhost:~/dev/mdadm-2.0-devel-1# mdadm -C -l 5 -n 3 --metadata 
> 1 /dev/md0 /dev/hdb /dev/hdc /dev/hdd
> mdadm: /dev/hdb appears to be part of a raid array:
>    level=5 devices=3 ctime=Tue May  3 11:43:00 2005
> mdadm: /dev/hdc appears to be part of a raid array:
>    level=5 devices=3 ctime=Tue May  3 11:43:00 2005
> mdadm: /dev/hdd appears to be part of a raid array:
>    level=5 devices=3 ctime=Tue May  3 11:43:00 2005
> Continue creating array? y
> VERS = 9002
> mdadm: ADD_NEW_DISK for /dev/hdb failed: Device or resource busy
>
> I believe it *could* have something to do with the fact that mdadm 
> 2.0-devel doesn't detect previously written (and/or blanked) raid 
> superblocks, look at my previous bugreport I filed a few minutes ago.  
> Maybe its seeing what the --examine feature shows, that there's an 
> "active" array on the drive still, hence, being unable to create a new 
> one.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

