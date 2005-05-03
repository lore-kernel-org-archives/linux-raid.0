From: Tyler <pml@dtbb.net>
Subject: Re: BUGREPORT: mdadm v2.0-devel - Examine and zero-superblock misbehaving
Date: Tue, 03 May 2005 16:55:32 -0700
Message-ID: <42780F74.8050900@dtbb.net>
References: <42775A61.6020708@dtbb.net> <17016.3630.940288.540120@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17016.3630.940288.540120@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

I tried removing the superblock several times to test the theory, but it 
seems the removal isn't working.. maybe because of the semi-invalid 
information of 380 spare drives? I'm not sure?

root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm --zero-superblock /dev/hdc
root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm --zero-superblock /dev/hdc
root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm --zero-superblock /dev/hdc
root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm -E /dev/hdc
/dev/hdc:
          Magic : a92b4efc
        Version : 01.00
     Array UUID : f4b2dc026e:a3cc3e95:de0563f5:199250
           Name :
  Creation Time : Tue May  3 11:16:22 2005
     Raid Level : raid5
   Raid Devices : 3

    Device Size : 390721952 (186.31 GiB 200.05 GB)
   Super Offset : 390721952 sectors
          State : active
    Device UUID : f4b2dc026e:a3cc3e95:de0563f5:199250
    Update Time : Tue May  3 11:16:22 2005
       Checksum : d4cd5d80 - correct
         Events : 0

         Layout : -unknown-
     Chunk Size : 64K

   Array State : Uuu 381 spares
root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm -E /dev/hdd
root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm --zero-superblock /dev/hdd
mdadm: Unrecognised md component device - /dev/hdd

Neil Brown wrote:

>On Tuesday May 3, pml@dtbb.net wrote:
>  
>
>>On a site note, mdadm --zero-superblock doesn't seem to work correctly 
>>with mdadm v2.0-devel, it reports no error when you use it, but you can 
>>mdadm -E /dev/hdX after using it, and there is still a superblock, if 
>>you use mdadm v1.9.0-2, it works correctly, and the examine shows 
>>nothing afterwards.  Examples follow after the first problem.  Mdadm 
>>v2.0 also seems to misreport the findings using the examine function.. 
>>"381 spares."  Using kernel 2.6.12-rc3-mm2.
>>
>>First i run zero superblock with mdadm v2.0-devel from current dir:
>>
>>root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm --zero-superblock /dev/hdc
>>
>>Then examine the superblock using mdadm v2.0-devel from current dir:
>>
>>root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm -E /dev/hdc
>>/dev/hdc:
>>          Magic : a92b4efc
>>        Version : 01.00
>>    
>>
>
>What has happened here is that "mdadm --zero-superblock" found a
>version 0.90 superblock and zeroed it.  There was still a version 1
>superblock (which lives in a different location). and -E found that.
>If you run --zero-superblock serveral times it should zero everything,
>though normally you would not expect to have multiple superblocks.
>
>  
>
>>   Array State : Uuu 381 spares
>>
>>    
>>
>
>Not sure about this.  I'll have to spend  a while reminding my self
>what is meant to happen, and what actually does...
>
>NeilBrown
>
>
>  
>

