From: "Phantazm" <phantazm@phantazm.nu>
Subject: Re: Huge mdadm resync problem.
Date: Thu, 17 Feb 2005 15:33:13 +0100
Message-ID: <cv29q2$l2l$1@sea.gmane.org>
References: <20050217145217.327494214a19146cf7@mail.kip.uni-heidelberg.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I use master slave. Problem is that i cant break raid set couse if i do i 
will loose over 1TB of data :/

Goin to see if i can get more controller cards though.

"Lord Hess,Raum 301Kw,54-8994" <hess@kip.uni-heidelberg.de> skrev i 
meddelandet 
news:20050217145217.327494214a19146cf7@mail.kip.uni-heidelberg.de...
>
> Hi,
>
> check the sync rate while connecting the disks only as a IDE masters. This 
> means
> you can try a RAID with 5 disks as I can see in your configuration.
> I guess that every disk is correct jumpered as a master or slave? Or do 
> you use
> the "cable select" option?
>
> Lord
>
>
> Phantazm <phantazm@phantazm.nu> schrieb:
>
>> This is really wierd problem with mdadm.
>>
>> I currently have 8 Maxtor 200gb disks.
>> They are connected like this
>>
>> hdb hdc hdd = onboard ide
>> hde hdf hdg hdh = Promise ata133 card
>> hdk = Promise ata 133 card.
>>
>> Hardware is a P4 2.8ghz with 2gb of ram and a MSI NEO 2 mobo.
>>
>> Problem is that te resync is really slow and when it's done it just loops
>> and the box craches.
>> Here are some info.
>>
>> Currently i'm testing a resync with a non HT/SMP config and noapic just 
>> to
>> check that is no irq routing crap. (failed before though)
>>
>> merlin / # uname -a
>> Linux merlin 2.6.10-gentoo-r6 #16 Thu Feb 17 11:00:11 CET 2005 i686 
>> Intel(R)
>> Pentium(R) 4 CPU 2.80GHz GenuineIntel GNU/Linux
>>
>>
>> merlin / # cat /proc/interrupts
>>            CPU0
>>   0:    6621371          XT-PIC  timer
>>   1:          8          XT-PIC  i8042
>>   2:          0          XT-PIC  cascade
>>   3:    1487791          XT-PIC  eth1
>>  10:    1628242          XT-PIC  eth0, eth2
>>  11:     112644          XT-PIC  ide2, ide3
>>  12:      35197          XT-PIC  ide5
>>  14:      71092          XT-PIC  ide0
>>  15:      63376          XT-PIC  ide1
>> NMI:          0
>> ERR:      40328
>>
>> cat /proc/mdstat
>> Personalities : [raid5]
>> md0 : active raid5 hde1[0] hdb1[8] hdd1[7] hdk1[6] hdc1[4] hdh1[3] 
>> hdg1[2]
>> hdf1[1]
>>       1393991424 blocks level 5, 64k chunk, algorithm 2 [8/7] [UUUUU_UU]
>>       [=>...................]  recovery =  5.5% (11110168/199141632)
>> finish=1641.7min speed=1906K/sec
>> unused devices: <none>
>>
>> (The resync speed is always somewhere between 500K to 3000K/s) should be
>> 10000K/s  ;-)
>>
>>
>> This is the kernelog. it's just a lil grab in it since this list goes on
>> untill i reboot the box. (its freezed).
>> This is what i get when sync is finiched and it should markt the array 
>> good.
>> Feb 17 07:17:08 [kernel] md: using maximum available idle IO bandwith 
>> (but
>> not more than 150000 KB/sec) for reconstruction.
>> Feb 17 07:17:08 [kernel] md: md0: sync done.
>> Feb 17 07:17:08 [kernel] .<6>md: syncing RAID array md0
>> Feb 17 07:17:08 [kernel] md: md0: sync done.
>> Feb 17 07:17:08 [kernel] .<6>md: syncing RAID array md0
>> Feb 17 07:17:08 [kernel] md: md0: sync done.
>> Feb 17 07:17:08 [kernel] .<6>md: syncing RAID array md0
>> Feb 17 07:17:08 [kernel] md: md0: sync done.
>> Feb 17 07:17:08 [kernel] .<6>md: syncing RAID array md0
>> Feb 17 07:17:08 [kernel] md: md0: sync done.
>> Feb 17 07:17:08 [kernel] .<6>md: syncing RAID array md0
>> Feb 17 07:17:08 [kernel] md: md0: sync done.
>> Feb 17 07:17:08 [kernel] .<6>md: syncing RAID array md0
>> Feb 17 07:17:08 [kernel] md: md0: sync done.
>> Feb 17 07:17:08 [kernel] .<6>md: syncing RAID array md0
>> Feb 17 07:17:08 [kernel] md: md0: sync done.
>> Feb 17 07:17:08 [kernel] .<6>md: syncing RAID array md0
>> Feb 17 07:17:08 [kernel] md: using maximum available idle IO bandwith 
>> (but
>> not more than 150000 KB/sec) for reconstruction.
>> Feb 17 07:17:08 [kernel] .<6>md: syncing RAID array md0
>> Feb 17 07:17:08 [kernel] md: md0: sync done.
>> Feb 17 07:17:08 [kernel] .<6>md: syncing RAID array md0
>>
>> I've also tried to have 4 disks on each promise card with same result. 
>> (if
>> having apic i get alot of cpu apic error 60)
>> i have checked all disks with smarttool and also benchmarked them. Each 
>> disk
>> gets about (hdparm) -T = 1800mb/s and -t 60mb/s so i doubt that
>> theres actually a broken disk.
>>
>> i'm running mdadm 1.7.0
>>
>> This is toally bugging me out.
>> Help is really really apricated.
>>
>>
>>
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
>
>
> --
> Lord Hess, R. 3.307 ,KIP, Inf 227 69120 Heidelberg
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



