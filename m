From: Stephen Haran <steveharan@gmail.com>
Subject: Re: RAID5 NAS Recovery...00.90.01 vs 00.90
Date: Wed, 21 Nov 2012 12:29:53 -0500
Message-ID: <CAKcp_7YdAgfoVM_j+jQNE61cLoEVd+y75zfyPNy1wv9w7+jfdQ@mail.gmail.com>
References: <CAKcp_7ZrR+L5jZBK3cd-z780Cw76XpwMuWmwtUGt=ecwbx_LPg@mail.gmail.com>
	<20121121083936.1a4d4b13@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121121083936.1a4d4b13@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you Neil for your reply comments below...

On Tue, Nov 20, 2012 at 4:39 PM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 20 Nov 2012 15:41:57 -0500 Stephen Haran <steveharan@gmail.com> wrote:
>
>> Hi, I'm trying to recover a Western Digital Share Space NAS.
>> I'm able to assemble the RAID5 and restore the LVM but it can't see
>> any filesystem.
>>
>> Below is a raid.log file that shows how the raid was configured when
>> it was working.
>> And also the output of mdadm -D showing the raid in it's current state.
>> Note the Version difference 00.90.01 vs. 0.90. And the array size
>> difference 2925293760  vs. 2925894144
>> I'm thinking this difference may be the reason Linux can not see a filesystem.
>
> Probably not - losing a few blocks from the end might make 'fsck' complain,
> but it should still be able to see the filesystem.
>
> How did you test if you could see a filesystem?  'mount' or 'fsck -n' ?

Yes I tried both mount and fsck. It can't find the superblock.
Testdisk finds ext3 partitions but can not see data.
But looking with hexedit the data appears to still be there.

> It looks like you re-created the array recently (Nov 18 12:07:53 2012)  Why
> did you do that?

The end user attempted a firmware upgrade on the NAS box and could not access
their data afterwards. Not sure if the firmware update or the end user
did the re-create.

> It has been created slightly smaller - not sure why.  Maybe if you explicitly
> request the old per-device size with "--size=975097920" it might get it right.

Thanks. I tried re-creating and specifying the size but it didn't help.

> Are you sure the dm cow devices show exactly the same size and content as the
> originals?

I checked the cow's and they look content and match up exactly size
wise and with mdadm -E.

> The stray '.01' at the end of the version number is not relevant.  It just
> indicates a different version of mdadm in use to report the array.

Thanks for clarifying that. I'm searching on ext3 recovery options now.
But certainly any other ideas are most welcome.  -Stephen

> NeilBrown
>
>
>>
>> My question is would the version difference explain the array size difference?
>> And is it possible to create a version 00.90.01 array? I do not see
>> that in the mdadm docs.
>>
>> ....original working raid config....
>> /dev/md2:
>>         Version : 00.90.01
>>   Creation Time : Wed Jun 24 19:00:59 2009
>>      Raid Level : raid5
>>      Array Size : 2925293760 (2789.78 GiB 2995.50 GB)
>>     Device Size : 975097920 (929.93 GiB 998.50 GB)
>>    Raid Devices : 4
>>   Total Devices : 4
>> Preferred Minor : 2
>>     Persistence : Superblock is persistent
>>
>>     Update Time : Thu Jun 25 02:36:31 2009
>>           State : clean
>>  Active Devices : 4
>> Working Devices : 4
>>  Failed Devices : 0
>>   Spare Devices : 0
>>
>>          Layout : left-symmetric
>>      Chunk Size : 64K
>>
>>            UUID : 6860a291:a5479bc6:e782da22:90dbd792
>>          Events : 0.45705
>>
>>     Number   Major   Minor   RaidDevice State
>>        0       8        4        0      active sync   /dev/sda4
>>        1       8       20        1      active sync   /dev/sdb4
>>        2       8       36        2      active sync   /dev/sdc4
>>        3       8       52        3      active sync   /dev/sdd4
>>
>>
>> ....and here is the raid as it stands now. Note the end user I'm
>> helping tried to rebuild back on Sunday...
>>
>>  % mdadm -D /dev/md2
>> /dev/md2:
>>         Version : 0.90
>>   Creation Time : Sun
>>      Raid Level : raid5
>>      Array Size : 2925894144 (2790.35 GiB 2996.12 GB)
>>   Used Dev Size : 975298048 (930.12 GiB 998.71 GB)
>>    Raid Devices : 4
>>   Total Devices : 4
>> Preferred Minor : 2
>>     Persistence : Superblock is persistent
>>
>>     Update Time : Tue Nov 20 16:06:10 2012
>>           State : clean
>>  Active Devices : 4
>> Working Devices : 4
>>  Failed Devices : 0
>>   Spare Devices : 0
>>
>>          Layout : left-symmetric
>>      Chunk Size : 64K
>>
>>            UUID : 2ac5bacd:b40dc3f5:cb031839:58437670
>>          Events : 0.1
>>
>>     Number   Major   Minor   RaidDevice State
>>        0     253       19        0      active sync   /dev/dm-19  <<<
>> Note I am using cow devices via dmsetup
>>        1     253       11        1      active sync   /dev/dm-11
>>        2     253       15        2      active sync   /dev/dm-15
>>        3     253        7        3      active sync   /dev/dm-7
>>
>> Thank you for any and all help.
>>
>> Regards,
>> Stephen
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
