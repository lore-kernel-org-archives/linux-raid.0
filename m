From: "Patrick H." <linux-raid@feystorm.net>
Subject: Re: md device renaming
Date: Sun, 12 Dec 2010 21:01:03 -0700
Message-ID: <4D059A7F.9050508@feystorm.net>
References: <4D0586D1.2040501@feystorm.net>	<20101213134920.70512086@notabene.brown>	<4D058AA2.8090401@feystorm.net> <20101213141347.0753fbca@notabene.brown> <4D059514.6040901@feystorm.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D059514.6040901@feystorm.net>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sent: Sun Dec 12 2010 20:37:56 GMT-0700 (Mountain Standard Time)
From: Patrick H. <linux-raid@feystorm.net>
To: no To-header on input <unlisted-recipients:;> linux-raid@vger.kernel.org
Subject: Re: md device renaming
> Sent: Sun Dec 12 2010 20:13:47 GMT-0700 (Mountain Standard Time)
> From: Neil Brown <neilb@suse.de>
> To: Patrick H. <linux-raid@feystorm.net> linux-raid@vger.kernel.org
> Subject: Re: md device renaming
>> Sorry, I obviously didn't read properly...
>> It must be getting the old name from somewhere.
>> I would
>>  - stop the array
>>  - use "mdadm -E" to examine each device and see what name is recorded.
>>  - look in /etc/mdadm.conf to see what name is there.
>>  - check /dev/.mdadm/map or possible /var/run/mdadm/map to see if the
>>    array is mentioned in there (it shouldn't be).
>>
>> to find out where the old name still is.  Then at least you know what 
>> needs
>> fixing.
>> Just for completeness: what version of mdadm are you using?
>>
>> NeilBrown
>>   
> At the bottom is the output from the `mdadm -E` after stopping the 
> array. None of them say anything about the old name
> I'm not using mdadm.conf. This is part of a HA cluster, so I'm trying 
> not to keep any info in local files, but all in the HA software 
> (pacemaker). The only thing in mdadm.conf is "MAILADDR root" and "AUTO 
> -all"
> /dev/.mdadm/ is completely empty, and /var/run/mdadm/map doesnt exist 
> either (just a pid file in that dir)
>
> # mdadm --version
> mdadm - v3.1.3 - 6th August 2010
> # uname -r
> 2.6.32-71.el6.x86_64
>
>
> The first 2 disks are the ones that ended up in the array. The third 
> disk is one I failed out so its not in it
>
> # mdadm -E 
> /dev/disk/by-path/ip-165.212.101.241\:3260-iscsi-iqn.165.212.101.240\:nas01.sdb1-lun-1 
>
> /dev/disk/by-path/ip-165.212.101.241:3260-iscsi-iqn.165.212.101.240:nas01.sdb1-lun-1: 
>
>          Magic : a92b4efc
>        Version : 1.2
>    Feature Map : 0x0
>     Array UUID : abddf4ea:06524e68:8e2b8f4e:1b24c56d
>           Name : nas01:126  (local to host nas01)
>  Creation Time : Thu Dec  9 20:41:53 2010
>     Raid Level : raid5
>   Raid Devices : 3
>
> Avail Dev Size : 524032 (255.92 MiB 268.30 MB)
>     Array Size : 1048064 (511.84 MiB 536.61 MB)
>    Data Offset : 224 sectors
>   Super Offset : 8 sectors
>          State : clean
>    Device UUID : c38615d5:53c09e0c:33160bea:237031fd
>
>    Update Time : Mon Dec 13 03:28:28 2010
>       Checksum : 7e6f1bdd - correct
>         Events : 4321
>
>         Layout : left-symmetric
>     Chunk Size : 128K
>
>   Device Role : Active device 0
>   Array State : AA. ('A' == active, '.' == missing)
>
> 2010/12/13 03:28:35
> root@nas01 /etc/syslog-ng # mdadm -E 
> /dev/disk/by-path/ip-165.212.101.242\:3260-iscsi-iqn.165.212.101.240\:nas02.sdb1-lun-1 
>
> /dev/disk/by-path/ip-165.212.101.242:3260-iscsi-iqn.165.212.101.240:nas02.sdb1-lun-1: 
>
>          Magic : a92b4efc
>        Version : 1.2
>    Feature Map : 0x0
>     Array UUID : abddf4ea:06524e68:8e2b8f4e:1b24c56d
>           Name : nas01:126  (local to host nas01)
>  Creation Time : Thu Dec  9 20:41:53 2010
>     Raid Level : raid5
>   Raid Devices : 3
>
> Avail Dev Size : 524032 (255.92 MiB 268.30 MB)
>     Array Size : 1048064 (511.84 MiB 536.61 MB)
>    Data Offset : 224 sectors
>   Super Offset : 8 sectors
>          State : clean
>    Device UUID : aab5bf73:94242880:8d28b333:f0c88918
>
>    Update Time : Mon Dec 13 03:28:39 2010
>       Checksum : f5a31a3a - correct
>         Events : 4325
>
>         Layout : left-symmetric
>     Chunk Size : 128K
>
>   Device Role : Active device 1
>   Array State : AA. ('A' == active, '.' == missing)
>
> # mdadm -E 
> /dev/disk/by-path/ip-165.212.101.243\:3260-iscsi-iqn.165.212.101.240\:nas03.sdb1-lun-1 
>
> /dev/disk/by-path/ip-165.212.101.243:3260-iscsi-iqn.165.212.101.240:nas03.sdb1-lun-1: 
>
>          Magic : a92b4efc
>        Version : 1.2
>    Feature Map : 0x0
>     Array UUID : abddf4ea:06524e68:8e2b8f4e:1b24c56d
>           Name : nas01:iscsi-sdb1  (local to host nas01)
>  Creation Time : Thu Dec  9 20:41:53 2010
>     Raid Level : raid5
>   Raid Devices : 3
>
> Avail Dev Size : 524032 (255.92 MiB 268.30 MB)
>     Array Size : 1048064 (511.84 MiB 536.61 MB)
>    Data Offset : 224 sectors
>   Super Offset : 8 sectors
>          State : clean
>    Device UUID : 78faaa98:22154538:aeeab927:19a62875
>
>    Update Time : Mon Dec 13 03:03:18 2010
>       Checksum : c358be3f - correct
>         Events : 3731
>
>         Layout : left-symmetric
>     Chunk Size : 128K
>
>   Device Role : Active device 2
>   Array State : AAA ('A' == active, '.' == missing)
>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Well, I just re-assembled the array after I stopped it to get the `mdadm 
-E` data, and now the /dev/md/ entry is named correctly. I guess I just 
had to stop it and reassemble it after doing the '-U name'. Still think 
that might be a bug though that it says "/dev/md/nas01:iscsi-sdb1 has 
been started" but it really called it something else.
