From: Chris Birkinshaw <chris@postbox.org.uk>
Subject: Re: Raid 5 always degraded!
Date: Tue, 29 Jun 2004 01:14:01 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <38DCB586-C961-11D8-B3CC-000A959A30DC@postbox.org.uk>
References: <200406270227.i5R2RF305822@watkins-home.com> <D0A60FDE-C90D-11D8-B3CC-000A959A30DC@postbox.org.uk>
Mime-Version: 1.0 (Apple Message framework v618)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D0A60FDE-C90D-11D8-B3CC-000A959A30DC@postbox.org.uk>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When I did fdisk -I it did not list the partition as raid autodetect. I 
set the device as failed and then removed it from the array, then using 
fdisk set the partition type to fd (linux raid autodetect), before 
adding it back to the array. Everything seems fine now, thank you for 
your help, it all makes much more sense now!

Kind regards,

Chris



On 28 Jun 2004, at 15:16, Chris Birkinshaw wrote:

>
> On 27 Jun 2004, at 03:27, Guy wrote:
>
>> Do:
>> 	fdisk -l /dev/hdd
>>
>> The Id for /dev/hdd3 should be fd.
>> fd=" Linux raid autodetect"
>>
>> Guy
>>
>> -----Original Message-----
>> From: linux-raid-owner@vger.kernel.org
>> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Chris 
>> Birkinshaw
>> Sent: Saturday, June 26, 2004 9:15 PM
>> To: linux-raid@vger.kernel.org
>> Subject: Re: Raid 5 always degraded!
>>
>> Firstly, thanks for the response and the offer to help, it's very much
>> appreciated - at the moment I am stressing about lack of protection
>> from drive failure, and a lot of data I can't back up!
>>
>>
>> I'm not really sure of how the raid array is started - I am using
>> Redhat 9 and it starts at boot automatically. I dug out the relevant
>> lines from /var/log/messages and have pasted them below. It seems that
>> as you said it isn't even looking for hdd3, yet the superblock has it
>> listing.
>>
>> I have done "mdadm --examine" for every device in the raid, and each
>> time the table at the bottom is as follows:
>>
>> Number   Major   Minor   RaidDevice State
>> this     6       3       65        6      active sync   /dev/hdb1
>>     0     0      34        1        0      active sync   /dev/hdg1
>>     1     1      34       65        1      active sync   /dev/hdh1
>>     2     2      33        1        2      active sync   /dev/hde1
>>     3     3      33       65        3      active sync   /dev/hdf1
>>     4     4      22        1        4      active sync   /dev/hdc1
>>     5     5      22       67        5      active sync   /dev/hdd3
>>     6     6       3       65        6      active sync   /dev/hdb1
>>
>> So it seems the superblocks are right.... hmmm. How does the the raid
>> get autostarted - and where does it get its info on the devices in the
>> raid from?
>>
>> Chris.
>>
>>
>>
>>
>> Jun 26 19:31:40 postbox kernel: md: linear personality registered as 
>> nr
>> 1
>> Jun 26 19:31:40 postbox kernel: md: raid0 personality registered as 
>> nr 2
>> Jun 26 19:31:40 postbox kernel: md: raid1 personality registered as 
>> nr 3
>> Jun 26 19:31:40 postbox kernel: md: raid5 personality registered as 
>> nr 4
>> Jun 26 19:31:40 postbox kernel: raid5: measuring checksumming speed
>> Jun 26 19:31:40 postbox kernel:    8regs     :  1068.000 MB/sec
>> Jun 26 19:31:40 postbox ntpdate[1059]: sendto(129.132.2.21): Network 
>> is
>> unreachable
>> Jun 26 19:31:40 postbox kernel:    8regs_prefetch:  1012.000 MB/sec
>> Jun 26 19:31:40 postbox kernel:    32regs    :   820.000 MB/sec
>> Jun 26 19:31:40 postbox kernel:    32regs    :   820.000 MB/sec
>> Jun 26 19:31:40 postbox kernel:    32regs_prefetch:   796.000 MB/sec
>> Jun 26 19:31:40 postbox kernel:    pII_mmx   :  2140.000 MB/sec
>> Jun 26 19:31:40 postbox kernel:    p5_mmx    :  2868.000 MB/sec
>> Jun 26 19:31:40 postbox kernel: raid5: using function: p5_mmx 
>> (2868.000
>> MB/sec)
>> Jun 26 19:31:40 postbox kernel: md: multipath personality registered 
>> as
>> nr 7
>> Jun 26 19:31:40 postbox kernel: md: md driver 0.90.0
>> MAX_MD_DEVS=256,MD_SB_DISKS=27
>>
>> Then a bit later...
>>
>>
>> Jun 26 19:31:41 postbox kernel: md: Autodetecting RAID arrays.
>> Jun 26 19:31:41 postbox kernel: md: autorun ...
>> Jun 26 19:31:41 postbox kernel: md: autorun ...
>> Jun 26 19:31:41 postbox kernel: md: considering hdh1 ...
>> Jun 26 19:31:41 postbox kernel: md:  adding hdh1 ...
>> Jun 26 19:31:41 postbox kernel: md: hdg2 has different UUID to hdh1
>> Jun 26 19:31:41 postbox ntpdate[1059]: sendto(129.132.2.21): Network 
>> is
>> unreachable
>> Jun 26 19:31:41 postbox kernel: md:  adding hdg1 ...
>> Jun 26 19:31:41 postbox kernel: md: hdf2 has different UUID to hdh1
>> Jun 26 19:31:41 postbox kernel: md:  adding hdf1 ...
>> Jun 26 19:31:41 postbox kernel: md: hde2 has different UUID to hdh1
>> Jun 26 19:31:41 postbox kernel: md:  adding hde1 ...
>> Jun 26 19:31:41 postbox kernel: md: hdc2 has different UUID to hdh1
>> Jun 26 19:31:41 postbox kernel: md:  adding hdc1 ...
>> Jun 26 19:31:41 postbox kernel: md:  adding hdb1 ...
>> Jun 26 19:31:42 postbox kernel: md: created md0
>> Jun 26 19:31:42 postbox kernel: md: bind<hdb1>
>> Jun 26 19:31:42 postbox kernel: md: bind<hdc1>
>> Jun 26 19:31:42 postbox kernel: md: bind<hde1>
>> Jun 26 19:31:42 postbox kernel: md: bind<hdf1>
>> Jun 26 19:31:42 postbox kernel: md: bind<hdg1>
>> Jun 26 19:31:42 postbox kernel: md: bind<hdh1>
>> Jun 26 19:31:42 postbox kernel: md: running:
>> <hdh1><hdg1><hdf1><hde1><hdc1><hdb1>
>> Jun 26 19:31:42 postbox kernel: raid5: device hdh1 operational as raid
>> disk 1
>> Jun 26 19:31:42 postbox kernel: raid5: device hdg1 operational as raid
>> disk 0
>> Jun 26 19:31:42 postbox kernel: raid5: device hdf1 operational as raid
>> disk 3
>> Jun 26 19:31:42 postbox kernel: raid5: device hde1 operational as raid
>> disk 2
>> Jun 26 19:31:42 postbox kernel: raid5: device hdc1 operational as raid
>> disk 4
>> Jun 26 19:31:42 postbox kernel: raid5: device hdb1 operational as raid
>> disk 6
>> Jun 26 19:31:42 postbox kernel: raid5: allocated 7298kB for md0
>> Jun 26 19:31:42 postbox kernel: raid5: raid level 5 set md0 active 
>> with
>> 6 out of 7 devices, algorithm 0
>> Jun 26 19:31:42 postbox kernel: RAID5 conf printout:
>> Jun 26 19:31:42 postbox kernel:  --- rd:7 wd:6 fd:1
>> Jun 26 19:31:42 postbox kernel:  disk 0, o:1, dev:hdg1
>> Jun 26 19:31:42 postbox kernel:  disk 1, o:1, dev:hdh1
>> Jun 26 19:31:42 postbox kernel:  disk 2, o:1, dev:hde1
>> Jun 26 19:31:42 postbox kernel:  disk 3, o:1, dev:hdf1
>> Jun 26 19:31:42 postbox kernel:  disk 4, o:1, dev:hdc1
>> Jun 26 19:31:42 postbox kernel:  disk 6, o:1, dev:hdb1
>> Jun 26 19:31:42 postbox kernel: md: considering hdg2 ...
>> Jun 26 19:31:42 postbox kernel: md: considering hdg2 ...
>> Jun 26 19:31:42 postbox kernel: md:  adding hdg2 ...
>> Jun 26 19:31:42 postbox kernel: md:  adding hdf2 ...
>> Jun 26 19:31:42 postbox kernel: md:  adding hde2 ...
>> Jun 26 19:31:42 postbox kernel: md:  adding hdc2 ...
>> Jun 26 19:31:42 postbox kernel: md: created md1
>> Jun 26 19:31:42 postbox kernel: md: bind<hdc2>
>> Jun 26 19:31:42 postbox kernel: md: bind<hde2>
>> Jun 26 19:31:42 postbox kernel: md: bind<hdf2>
>> Jun 26 19:31:42 postbox kernel: md: bind<hdg2>
>> Jun 26 19:31:42 postbox ntpdate[1059]: sendto(129.132.2.21): Network 
>> is
>> unreachable
>> Jun 26 19:31:42 postbox kernel: md: running: <hdg2><hdf2><hde2><hdc2>
>> Jun 26 19:31:42 postbox kernel: md1: setting max_sectors to 2048,
>> segment boundary to 524287
>> Jun 26 19:31:42 postbox kernel: raid0: looking at hdg2
>> Jun 26 19:31:42 postbox kernel: raid0:   comparing hdg2(1437696) with
>> hdg2(1437696)
>> Jun 26 19:31:42 postbox kernel: raid0:   END
>> Jun 26 19:31:42 postbox kernel: raid0:   ==> UNIQUE
>> Jun 26 19:31:42 postbox kernel: raid0: 1 zones
>> Jun 26 19:31:43 postbox kernel: raid0: looking at hdf2
>> Jun 26 19:31:43 postbox kernel: raid0:   comparing hdf2(1437696) with
>> hdg2(1437696)
>> Jun 26 19:31:43 postbox kernel: raid0:   EQUAL
>> Jun 26 19:31:43 postbox kernel: raid0: looking at hde2
>> Jun 26 19:31:43 postbox kernel: raid0:   comparing hde2(1437696) with
>> hdg2(1437696)
>> Jun 26 19:31:43 postbox kernel: raid0:   EQUAL
>> Jun 26 19:31:43 postbox kernel: raid0: looking at hdc2
>> Jun 26 19:31:43 postbox kernel: raid0:   comparing hdc2(1437696) with
>> hdg2(1437696)
>> Jun 26 19:31:43 postbox kernel: raid0:   EQUAL
>> Jun 26 19:31:43 postbox kernel: raid0: FINAL 1 zones
>> Jun 26 19:31:43 postbox kernel: raid0: done.
>> Jun 26 19:31:43 postbox kernel: raid0 : md_size is 5750784 blocks.
>> Jun 26 19:31:43 postbox kernel: raid0 : conf->hash_spacing is 5750784
>> blocks.
>> Jun 26 19:31:43 postbox kernel: raid0 : nb_zone is 1.
>> Jun 26 19:31:43 postbox kernel: raid0 : Allocating 4 bytes for hash.
>> Jun 26 19:31:43 postbox kernel: md: ... autorun DONE.
>>
>>
>>
>> On 26 Jun 2004, at 23:58, Neil Brown wrote:
>>
>>> On Saturday June 26, chris@postbox.org.uk wrote:
>>>>
>>>>
>>>> Whenever I reboot my computer the RAID5 comes back in degraded mode,
>>>> and mdadm outputs the following info:
>>>>
>>>>        Number   Major   Minor   RaidDevice State
>>>> this     0      34        1        0      active sync   /dev/hdg1
>>>>     0     0      34        1        0      active sync   /dev/hdg1
>>>>     1     1      34       65        1      active sync   /dev/hdh1
>>>>     2     2      33        1        2      active sync   /dev/hde1
>>>>     3     3      33       65        3      active sync   /dev/hdf1
>>>>     4     4      22        1        4      active sync   /dev/hdc1
>>>>     5     5       0        0        5      faulty removed
>>>>     6     6       3       65        6      active sync   /dev/hdb1
>>>>
>>>> If I do a mdadm /dev/md0 --add /dev/hdd3 the missing disk is 
>>>> re-added
>>>> and everything seems fine after it has worked away for a few hours -
>>>> however after another reboot the disk has gone again.
>>>>
>>>> Does anyone have any idea what is going on?
>>>
>>> At a guess, I'd say  that you are relying on auto-detection of raid
>>> arrays using  raid-auto-detect partition types, and that /dev/hdd3
>>> isn't set to raid-auto-detect.
>>> If that isn't it, some kernel log messages would probably help, along
>>> with more details of why you expect it to work (e.g. are you using
>>> raidstart, mdadm, autodetect, etc).
>>>
>>> NeilBrown
>>> -
>>> To unsubscribe from this list: send the line "unsubscribe linux-raid"
>>> in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" 
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" 
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" 
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

