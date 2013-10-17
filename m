From: peter@steinhoff.se
Subject: Re: Problem diagnosing rebuilding raid5 array
Date: Wed, 16 Oct 2013 22:27:54 -0400
Message-ID: <20131016222754.15765kbm152z5skc@phobos.elinuxservers.com>
References: <20131014123104.77620e8uy2pe0214@phobos.elinuxservers.com>
 <20131016171157.7655fe31@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131016171157.7655fe31@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks Neil,

I've checked the drives and sdd had unrecoverable read errors which  
was the reason that the rebuilding of sdh failed in the first place.

Then I made a clone of sdd with ddrescue and it looks like only 4096  
bytes was completely unreadable.

Then I did the --force assemble as you suggested using the 3 good  
drives and the cloned sdd. I ran e2fsck after that and temporarily  
mounted the array to check that it looked OK.

Now I've added sdh again and the rebuilding process is underway.  
Hopefully it will complete.


I was just wondering but since I lost 4kB of data when I cloned sdd,  
does that mean that I will have 4x4kB of garbled data somewhere since  
I assembled 4 drives (n-1) and the raid system wouldn't know? Or would  
that have been detected somehow when I ran fsck (ext3)?


Thanks,
Peter



Quoting NeilBrown <neilb@suse.de>:

> On Mon, 14 Oct 2013 12:31:04 -0400 peter@steinhoff.se wrote:
>
>> Hi!
>>
>> I'm having some problems with a raid 5 array and I'm not sure how to
>> diagnose the problem and how to proceed so I figured I need to ask the
>> experts :-)
>>
>> I actually suspect I may have several problems at the same time.
>>
>> The machine has two raid arrays, one raid 1 (md0) and one raid 5
>> (md1). The raid 5 array consists of 5 x 2TB WD RE4-GP drives.
>>
>> I found some read errors in the log on /dev/sdh so I replaced it with
>> a new RE4 GP drive and did mdadm --add /dev/md1 /dev/sdh.
>>
>> The array was rebuilding and I left it for the night.
>>
>> In the morning cat /proc/mdstat showed that 2 drives where down. I may
>> remember incorrectly but I think that /dev/sdh showed up as a spare
>> and another drive showed fail but the array showed up as active.
>>
>> Anyway, I'm not sure which drive showed fail but I disconnected the
>> system for more diagnosis. This was a couple of days ago.
>>
>> I found that the CPU fan had stopped working and replaced it. The case
>> have several fans and the heatsink seemed cool even without the fan
>> (it's an i3-530 that does nothing more than samba so it's mostly
>> idle). Possibly the hardrives has been running hotter than normal for
>> a while though.
>>
>> Anyway, now when I reboot I get this:
>>
>> > cat /proc/mdstat
>> Personalities : [raid1]
>> md1 : inactive sdd[1](S) sdh[5](S) sdg[4](S) sdf[2](S) sde[0](S)
>>        9767572480 blocks
>>
>> md0 : active raid1 sda[0] sdb[1]
>>        1953514496 blocks [2/2] [UU]
>>
>> unused devices: <none>
>>
>>
>> I'm not sure what is happening and what my next step is. I would
>> appreciate any help on this so I don't screw up the system more than
>> it already is :-)
>
> We have no way of knowing how far recovery progressed onto sdh, so you need
> to exclude it.  With v1.x metadata we would know ... but it wouldn't really
> help the much.
>
> Your only option is to do a --force assemble of the other devices.
> sde is a little bit out of date, but it cannot be much out of date as the
> array would have stopped handling writes as soon as it failed.
>
> This will assemble the array degraded.  You should then 'fsck' and do
> anything else to check that the data is OK.
>
> Then you need to check that all your drives and are your system are good (if
> you haven't already), then add a good drive as a spare and let it rebuild.
>
> NeilBrown
>
>
>>
>> Below is the ouput of "mdadm --examine" for the drives in the raid 5 array.
>>
>> BTW, don't know if it matters but the system is running an older
>> debian (lenny?) with a 2.6.32 backport kernel, mdadm version is 2.6.7.2.
>>
>> Best Regards,
>> Peter
>>
>>
>> > mdadm --examine /dev/sd?
>>
>> /dev/sdd:
>>            Magic : a92b4efc
>>          Version : 00.90.00
>>             UUID : 61a6a879:adb7ac7b:86c7b55e:eb5cc2b6
>>    Creation Time : Thu Jun 24 15:12:41 2010
>>       Raid Level : raid5
>>    Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
>>       Array Size : 7814057984 (7452.07 GiB 8001.60 GB)
>>     Raid Devices : 5
>>    Total Devices : 5
>> Preferred Minor : 1
>>
>>      Update Time : Wed Oct  9 20:29:41 2013
>>            State : clean
>>   Active Devices : 3
>> Working Devices : 4
>>   Failed Devices : 1
>>    Spare Devices : 1
>>         Checksum : 3dc0af1a - correct
>>           Events : 1288444
>>
>>           Layout : left-symmetric
>>       Chunk Size : 128K
>>
>>        Number   Major   Minor   RaidDevice State
>> this     1       8       48        1      active sync   /dev/sdd
>>
>>     0     0       0        0        0      removed
>>     1     1       8       48        1      active sync   /dev/sdd
>>     2     2       8       80        2      active sync   /dev/sdf
>>     3     3       0        0        3      faulty removed
>>     4     4       8       96        4      active sync   /dev/sdg
>>     5     5       8      112        5      spare   /dev/sdh
>>
>>
>> /dev/sde:
>>            Magic : a92b4efc
>>          Version : 00.90.00
>>             UUID : 61a6a879:adb7ac7b:86c7b55e:eb5cc2b6
>>    Creation Time : Thu Jun 24 15:12:41 2010
>>       Raid Level : raid5
>>    Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
>>       Array Size : 7814057984 (7452.07 GiB 8001.60 GB)
>>     Raid Devices : 5
>>    Total Devices : 5
>> Preferred Minor : 1
>>
>>      Update Time : Tue Oct  8 03:26:05 2013
>>            State : clean
>>   Active Devices : 4
>> Working Devices : 5
>>   Failed Devices : 1
>>    Spare Devices : 1
>>         Checksum : 3dbe6d93 - correct
>>           Events : 1288428
>>
>>           Layout : left-symmetric
>>       Chunk Size : 128K
>>
>>        Number   Major   Minor   RaidDevice State
>> this     0       8       64        0      active sync   /dev/sde
>>
>>     0     0       8       64        0      active sync   /dev/sde
>>     1     1       8       48        1      active sync   /dev/sdd
>>     2     2       8       80        2      active sync   /dev/sdf
>>     3     3       0        0        3      faulty removed
>>     4     4       8       96        4      active sync   /dev/sdg
>>     5     5       8      112        5      spare   /dev/sdh
>>
>>
>> /dev/sdf:
>>            Magic : a92b4efc
>>          Version : 00.90.00
>>             UUID : 61a6a879:adb7ac7b:86c7b55e:eb5cc2b6
>>    Creation Time : Thu Jun 24 15:12:41 2010
>>       Raid Level : raid5
>>    Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
>>       Array Size : 7814057984 (7452.07 GiB 8001.60 GB)
>>     Raid Devices : 5
>>    Total Devices : 5
>> Preferred Minor : 1
>>
>>      Update Time : Wed Oct  9 20:29:41 2013
>>            State : clean
>>   Active Devices : 3
>> Working Devices : 4
>>   Failed Devices : 1
>>    Spare Devices : 1
>>         Checksum : 3dc0af3c - correct
>>           Events : 1288444
>>
>>           Layout : left-symmetric
>>       Chunk Size : 128K
>>
>>        Number   Major   Minor   RaidDevice State
>> this     2       8       80        2      active sync   /dev/sdf
>>
>>     0     0       0        0        0      removed
>>     1     1       8       48        1      active sync   /dev/sdd
>>     2     2       8       80        2      active sync   /dev/sdf
>>     3     3       0        0        3      faulty removed
>>     4     4       8       96        4      active sync   /dev/sdg
>>     5     5       8      112        5      spare   /dev/sdh
>>
>>
>> /dev/sdg:
>>            Magic : a92b4efc
>>          Version : 00.90.00
>>             UUID : 61a6a879:adb7ac7b:86c7b55e:eb5cc2b6
>>    Creation Time : Thu Jun 24 15:12:41 2010
>>       Raid Level : raid5
>>    Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
>>       Array Size : 7814057984 (7452.07 GiB 8001.60 GB)
>>     Raid Devices : 5
>>    Total Devices : 5
>> Preferred Minor : 1
>>
>>      Update Time : Wed Oct  9 20:29:41 2013
>>            State : clean
>>   Active Devices : 3
>> Working Devices : 4
>>   Failed Devices : 1
>>    Spare Devices : 1
>>         Checksum : 3dc0af50 - correct
>>           Events : 1288444
>>
>>           Layout : left-symmetric
>>       Chunk Size : 128K
>>
>>        Number   Major   Minor   RaidDevice State
>> this     4       8       96        4      active sync   /dev/sdg
>>
>>     0     0       0        0        0      removed
>>     1     1       8       48        1      active sync   /dev/sdd
>>     2     2       8       80        2      active sync   /dev/sdf
>>     3     3       0        0        3      faulty removed
>>     4     4       8       96        4      active sync   /dev/sdg
>>     5     5       8      112        5      spare   /dev/sdh
>>
>>
>> /dev/sdh:
>>            Magic : a92b4efc
>>          Version : 00.90.00
>>             UUID : 61a6a879:adb7ac7b:86c7b55e:eb5cc2b6
>>    Creation Time : Thu Jun 24 15:12:41 2010
>>       Raid Level : raid5
>>    Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
>>       Array Size : 7814057984 (7452.07 GiB 8001.60 GB)
>>     Raid Devices : 5
>>    Total Devices : 5
>> Preferred Minor : 1
>>
>>      Update Time : Wed Oct  9 20:29:41 2013
>>            State : clean
>>   Active Devices : 3
>> Working Devices : 4
>>   Failed Devices : 1
>>    Spare Devices : 1
>>         Checksum : 3dc0af5c - correct
>>           Events : 1288444
>>
>>           Layout : left-symmetric
>>       Chunk Size : 128K
>>
>>        Number   Major   Minor   RaidDevice State
>> this     5       8      112        5      spare   /dev/sdh
>>
>>     0     0       0        0        0      removed
>>     1     1       8       48        1      active sync   /dev/sdd
>>     2     2       8       80        2      active sync   /dev/sdf
>>     3     3       0        0        3      faulty removed
>>     4     4       8       96        4      active sync   /dev/sdg
>>     5     5       8      112        5      spare   /dev/sdh
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>



