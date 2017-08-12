From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: force raid reassembly
Date: Sat, 12 Aug 2017 18:44:27 +0100
Message-ID: <5f064932-fc2d-926c-932b-1f3cdaaeb77a@youngman.org.uk>
References: <DB4PR07MB409B56E9B9173E33079902ED58A0@DB4PR07MB409.eurprd07.prod.outlook.com>
 <WM!bafd27028d31e7e922c12b615def50baa8369ba598ac220b2884f1706eddac34cd0580e2d54cc3da9be1bbadf104dab1!@mailhub-mx1.ncl.ac.uk>
 <15dc68d8630.27fa.c989c0045808b278ebe0f0fc417d866d@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15dc68d8630.27fa.c989c0045808b278ebe0f0fc417d866d@gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Joe Landman <joe.landman@gmail.com>, Bryan Hepworth <bryan.hepworth@newcastle.ac.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Only thing is, sdb1 says "AAA.AA", which is a bit weird, unless sdb1 is 
the very last one, which is the last dot in AAA.A. of all the others.

If five drives all have almost identical event counts, I'd be inclined 
to ddrescue the dodgy one (probably sdb1) and hope it all works out.

The alternative is to ddrescue both dodgy drives, and write the program 
that marks blocks as dodgy. Then you can hope that a scan can rebuild 
everything.

Cheers,
Wol

On 09/08/17 11:34, Joe Landman wrote:
> Ok, you are missing 2 drives in a 6 drive raid.  This is generally bad 
> news.  Are you sure all your drives are accessible?  Can you read 
> partition tables from each? If not, f2f hen a force won't likely do 
> anything.
> 
> Can you give context and logs entries on what happend to cause this?  
> Also do you have backups of the data... raid is not a backup itself ... 
> if need be, can you recover from a recent backup?
> 
> 
> On August 8, 2017 3:39:46 PM Bryan Hepworth 
> <bryan.hepworth@newcastle.ac.uk> wrote:
> 
>> Hi all
>>
>> I'd be grateful of another pair of eyes just to check and verify what 
>> I'm thinking. I've had an array fail and I've checked the components 
>> with the mdadm --examine command. Five out of the six event counts are 
>> correct and I'm hoping I can get it to assemble with the force option: -
>>
>> "mdadm --assemble --force /dev/mdX <list of devices>"
>>
>> mdadm --assemble --force /dev/md0 /dev/sdd1 /dev/sdg1 /dev/sdf1 
>> /dev/sde1 /dev/sdb1 /dev/sdc1
>>
>> Output from --examine is as follows: -
>>
>>
>> [root@inscribe4 dev]# mdadm --examine /dev/sde1
>> /dev/sde1:
>>           Magic : a92b4efc
>>         Version : 1.2
>>     Feature Map : 0x1
>>      Array UUID : ace00fb5:8771d55a:cf36728b:ddc3ce89
>>            Name : intermediate0
>>   Creation Time : Tue Oct 15 21:03:50 2013
>>      Raid Level : raid5
>>    Raid Devices : 6
>>
>>  Avail Dev Size : 3906761858 (1862.89 GiB 2000.26 GB)
>>      Array Size : 9766901760 (9314.44 GiB 10001.31 GB)
>>   Used Dev Size : 3906760704 (1862.89 GiB 2000.26 GB)
>>     Data Offset : 262144 sectors
>>    Super Offset : 8 sectors
>>    Unused Space : before=262064 sectors, after=1154 sectors
>>           State : clean
>>     Device UUID : 8d0b6c8e:0c526265:6ec0a71b:52a636ba
>>
>> Internal Bitmap : 8 sectors from superblock
>>     Update Time : Tue Aug  8 14:16:53 2017
>>        Checksum : 44b7b461 - correct
>>          Events : 119894
>>
>>          Layout : left-symmetric
>>      Chunk Size : 512K
>>
>>    Device Role : spare
>>    Array State : AAA.A. ('A' == active, '.' == missing, 'R' == replacing)
>>
>> [root@inscribe4 dev]# mdadm --examine /dev/sdg1
>> /dev/sdg1:
>>           Magic : a92b4efc
>>         Version : 1.2
>>     Feature Map : 0x1
>>      Array UUID : ace00fb5:8771d55a:cf36728b:ddc3ce89
>>            Name : intermediate0
>>   Creation Time : Tue Oct 15 21:03:50 2013
>>      Raid Level : raid5
>>    Raid Devices : 6
>>
>>  Avail Dev Size : 3906761858 (1862.89 GiB 2000.26 GB)
>>      Array Size : 9766901760 (9314.44 GiB 10001.31 GB)
>>   Used Dev Size : 3906760704 (1862.89 GiB 2000.26 GB)
>>     Data Offset : 262144 sectors
>>    Super Offset : 8 sectors
>>    Unused Space : before=262064 sectors, after=1154 sectors
>>           State : clean
>>     Device UUID : e238e74b:d40efc43:d34d876d:ca0700b0
>>
>> Internal Bitmap : 8 sectors from superblock
>>     Update Time : Tue Aug  8 14:16:53 2017
>>        Checksum : 28758d54 - correct
>>          Events : 119894
>>
>>          Layout : left-symmetric
>>      Chunk Size : 512K
>>
>>    Device Role : Active device 1
>>    Array State : AAA.A. ('A' == active, '.' == missing, 'R' == replacing)
>>
>> [root@inscribe4 dev]# mdadm --examine /dev/sdd1
>> /dev/sdd1:
>>           Magic : a92b4efc
>>         Version : 1.2
>>     Feature Map : 0x1
>>      Array UUID : ace00fb5:8771d55a:cf36728b:ddc3ce89
>>            Name : intermediate0
>>   Creation Time : Tue Oct 15 21:03:50 2013
>>      Raid Level : raid5
>>    Raid Devices : 6
>>
>>  Avail Dev Size : 3906761858 (1862.89 GiB 2000.26 GB)
>>      Array Size : 9766901760 (9314.44 GiB 10001.31 GB)
>>   Used Dev Size : 3906760704 (1862.89 GiB 2000.26 GB)
>>     Data Offset : 262144 sectors
>>    Super Offset : 8 sectors
>>    Unused Space : before=262064 sectors, after=1154 sectors
>>           State : clean
>>     Device UUID : 1732f121:f6f0df09:fafd2411:7c78ce00
>>
>> Internal Bitmap : 8 sectors from superblock
>>     Update Time : Tue Aug  8 14:16:53 2017
>>        Checksum : b8cf8981 - correct
>>          Events : 119894
>>
>>          Layout : left-symmetric
>>      Chunk Size : 512K
>>
>>    Device Role : Active device 0
>>    Array State : AAA.A. ('A' == active, '.' == missing, 'R' == replacing)
>>
>> [root@inscribe4 dev]# mdadm --examine /dev/sdf1
>> /dev/sdf1:
>>           Magic : a92b4efc
>>         Version : 1.2
>>     Feature Map : 0x1
>>      Array UUID : ace00fb5:8771d55a:cf36728b:ddc3ce89
>>            Name : intermediate0
>>   Creation Time : Tue Oct 15 21:03:50 2013
>>      Raid Level : raid5
>>    Raid Devices : 6
>>
>>  Avail Dev Size : 3906761858 (1862.89 GiB 2000.26 GB)
>>      Array Size : 9766901760 (9314.44 GiB 10001.31 GB)
>>   Used Dev Size : 3906760704 (1862.89 GiB 2000.26 GB)
>>     Data Offset : 262144 sectors
>>    Super Offset : 8 sectors
>>    Unused Space : before=262064 sectors, after=1154 sectors
>>           State : clean
>>     Device UUID : 3d414ad2:4310c1f9:98f50214:3e9b1e33
>>
>> Internal Bitmap : 8 sectors from superblock
>>     Update Time : Tue Aug  8 14:16:53 2017
>>        Checksum : 8e37d25d - correct
>>          Events : 119894
>>
>>          Layout : left-symmetric
>>      Chunk Size : 512K
>>
>>    Device Role : Active device 2
>>    Array State : AAA.A. ('A' == active, '.' == missing, 'R' == replacing)
>>
>> [root@inscribe4 dev]# mdadm --examine /dev/sdb1
>> /dev/sdb1:
>>           Magic : a92b4efc
>>         Version : 1.2
>>     Feature Map : 0x1
>>      Array UUID : ace00fb5:8771d55a:cf36728b:ddc3ce89
>>            Name : intermediate0
>>   Creation Time : Tue Oct 15 21:03:50 2013
>>      Raid Level : raid5
>>    Raid Devices : 6
>>
>>  Avail Dev Size : 3906761858 (1862.89 GiB 2000.26 GB)
>>      Array Size : 9766901760 (9314.44 GiB 10001.31 GB)
>>   Used Dev Size : 3906760704 (1862.89 GiB 2000.26 GB)
>>     Data Offset : 262144 sectors
>>    Super Offset : 8 sectors
>>    Unused Space : before=262064 sectors, after=1154 sectors
>>           State : clean
>>     Device UUID : a84263cd:75ce20b9:a3a72a1c:b18b2457
>>
>> Internal Bitmap : 8 sectors from superblock
>>     Update Time : Mon Jul 31 22:50:37 2017
>>        Checksum : 74d320d6 - correct
>>          Events : 119879
>>
>>          Layout : left-symmetric
>>      Chunk Size : 512K
>>
>>    Device Role : Active device 5
>>    Array State : AAA.AA ('A' == active, '.' == missing, 'R' == replacing)
>>
>> [root@inscribe4 dev]# mdadm --examine /dev/sdc1
>> /dev/sdc1:
>>           Magic : a92b4efc
>>         Version : 1.2
>>     Feature Map : 0x1
>>      Array UUID : ace00fb5:8771d55a:cf36728b:ddc3ce89
>>            Name : intermediate0
>>   Creation Time : Tue Oct 15 21:03:50 2013
>>      Raid Level : raid5
>>    Raid Devices : 6
>>
>>  Avail Dev Size : 3906761858 (1862.89 GiB 2000.26 GB)
>>      Array Size : 9766901760 (9314.44 GiB 10001.31 GB)
>>   Used Dev Size : 3906760704 (1862.89 GiB 2000.26 GB)
>>     Data Offset : 262144 sectors
>>    Super Offset : 8 sectors
>>    Unused Space : before=262064 sectors, after=1154 sectors
>>           State : clean
>>     Device UUID : be5ec20e:249645e5:22aeca25:a60c7599
>>
>> Internal Bitmap : 8 sectors from superblock
>>     Update Time : Tue Aug  8 14:16:53 2017
>>        Checksum : 2e529fae - correct
>>          Events : 119894
>>
>>          Layout : left-symmetric
>>      Chunk Size : 512K
>>
>>    Device Role : Active device 4
>>    Array State : AAA.A. ('A' == active, '.' == missing, 'R' == replacing)
>>
>> Thanks
>>
>> Bryan
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
