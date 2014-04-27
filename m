From: Jeff Wiegley <jeffw@csun.edu>
Subject: Re: Re-creating/Fixing Raid5 from superblock Info
Date: Sun, 27 Apr 2014 15:47:01 -0700
Message-ID: <535D88E5.7080800@csun.edu>
References: <ACABA0F8A3B9A3468A3881B311B28B08586E8013@ITS-MSXMBS2F.ad.unc.edu>,<535D726D.2040804@csun.edu> <ej0ve65owi1ayirr210j6tk3.1398637830612@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ej0ve65owi1ayirr210j6tk3.1398637830612@email.android.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Meyer, Adrian" <adrian_meyer@med.unc.edu>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

You don't have to reinstall the old OS. Especially
if you installed the OS to upgrade stuff.

The trick is getting the older version of mdadm that was
used to create your array in the first place. And these
can be downloaded from

https://www.kernel.org/pub/linux/utils/raid/mdadm/

Anyways... I don't think you used the mdadm from
kubuntu 12.04 when you originally created the array.
mdadm was defaulting to version 1.2 metadata by that
release. Your examination info shows a much older
metadata of 0.90.

So you have either used an older mdadm from long
before 12.04 (and you had subsequent OS upgrades since
then) or you specifically asked for v0.90 when you
created the array.

In the former, if you install kubuntu 12.04 again it
won't help you because the mdadm that gets installed
will be using different defaults than what you used
when you created it originally.

In the latter case you specifically asked for 0.90
(and since your chunk size is also not-default I
would guess you also selected a non-default chunk size
and possibly different data offsets and sizes.) In
this case it's not going to matter what version mdadm
you install or what verion OS because the chance of them
using the same defaults for the sizes as you picked
custom is essentially zero.

Essentially: You have to get your superblocks recreated
with the exact same size and offset information as it
was originally created with or you will not be able to
recover your data.

and again... when recovering the array ALWAYS add the
--assume-clean to the command or you'll cause a resync
and wipe your data.

- Jeff

On 4/27/2014 3:31 PM, Meyer, Adrian wrote:
> Thanks. I'll reinstall old os. It was kubuntu 12.04 i believe running
> kernel 2.4.something.I upgraded to kubuntu 14.04 on 3.2.sonething. I'll
> see how that goes.
>
> Thanks.
>
> Adrian
>
>
> Sent via the Samsung Galaxy S3
>
>
> -------- Original message --------
> From: Jeff Wiegley
> Date:04/27/2014 17:17 (GMT-05:00)
> To: "Meyer, Adrian" ,linux-raid@vger.kernel.org
> Subject: Re: Re-creating/Fixing Raid5 from superblock Info
>
> Did you install the original OS or did you install
> an updated OS? Metadata version 0.90.00 is really
> old I think. New metadata version is 1.2.
>
> The byte offsets for things have changed from
> version to version. You are going to need to know
> these offsets because they have to be the same
> as the original.
>
> If you reinstalled the original OS then you should
> be in luck because you will have reinstalled the old
> mdadm that was used to create the array in the first
> place. It will use the same offsets if you used its
> defaults in the first place.
>
> If you installed an up to date OS then you will
> need to get the array re-created with the original
> offsets and sizes. The newest mdadm allows you to
> specify these and override the defaults at create
> time.
>
> I can see from your listing that the chunksize is
> 64K. But the dump doesn't show data offsets. so I
> don't know what that is. 64K is not the default for
> current mdadm creations (on Raid6 at least) so I
> believe you may have not used default values which
> would make this all a lot harder to figure out what
> values to use on your re-create.
>
> I just went through recovering an array successfully
> similar to your problem and I didn't know those
> sizes either. Here's what I did. I went to the
> mdadm download site and I downloaded old versions
> of the tool. They are quite easy to build (I only
> had to remove the -Werror from the Makefiles and
> type make). I also like this way because I don't
> know enough about the various offsets/size/layouts
> to know what to override and what not. I know I
> just used the defaults in the past so as long as
> I use the same old version of mdadm that I did those
> many years ago it will use the right stuff.
>
> Pick the version closest to the one that you used.
> It should have the original offsets and sizes that
> you used assuming you didn't override/change them
> when you created the array.
>
> using the correct mdadm version do the following:
> ./mdadm --create --assume-clean --metadata=0.90 --chunk=64 --level=5
> --raid-devices=5 /dev/md0 /dev/sd[ghijk]
>
> THE ASSUME-CLEAN IS ***HUGELY*** IMPORTANT. You do NOT
> want the array to resync on you. If it does do its
> initial resync I believe you screw up your data.
>
> The order of the drives is important too. Your listing
> shows the md numeric order of the drives and the
> /dev/sd[ghijk] will shell expand to the same order.
>
>
> I would immediately do
>     mdadm --readonly /dev/md0
> after the create to make sure nothing changes while
> you test. If you've got the offsets wrong and it
> doesn't work then you can stop the array, zero the
> superblock and try creating it again with different
> offset/size values. But once you alter the data on
> the drives... you're toast.
>
> Before doing anything else to the array I would
> also do
>      cat /proc/mdstat
>      mdadm --examine /dev/sdg
> just to verify that it was created with the proper
> drive order and sizes. If they are clearly off I
> would not proceed and would try again with
> different settings.
>
> I was lucky that I had two similar arrays on the
> drives /dev/md3 and /dev/md4 and I didn't care about
> /dev/md3. So I could mess around with sizes and
> superblocks on there until/if I got it working and
> then use those parameters on the important drive.
>
> You don't have a spare to screw with. I would
> suggest finding a way to make a byte for byte
> backup of your drives using dd then you can screw
> around without fear of not being able to restore
> your drives if you accidentally alter their data.
> (But this is going to require 5 more 2TB drives
> on hand or some other 10TB storage to store your
> dd images while you attempt tests.)
>
> Please read/research carefully. I'm not an mdadm
> wizard and I figure I hit the jackpot of luck
> when I successfully recreated my array after
> reinstalling an OS and blowing away the superblocks.
> So if you can get verification of my suggestions
> before proceeding that would be best.
>
> - Jeff Wiegley
>
> On 4/27/2014 7:03 AM, Meyer, Adrian wrote:
>> I am trying to re-create a raid5 after re-installing the OS. Unfortunately my initial try was not successful and I probably messed things up. I saved the original disk information (see below). What would be the mdadm --create command with the correct additional  parameters?
>>
>> /dev/sde:
>>            Magic : a92b4efc
>>          Version : 0.90.00
>>             UUID : 208886f0:0b0c5d65:d1ecd824:5a220e5e (local to host niederhorn)
>>    Creation Time : Mon Jul  2 00:08:03 2012
>>       Raid Level : raid5
>>    Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
>>       Array Size : 7814057984 (7452.07 GiB 8001.60 GB)
>>     Raid Devices : 5
>>    Total Devices : 5
>> Preferred Minor : 0
>>
>>      Update Time : Sat Apr 26 11:03:04 2014
>>            State : clean
>>   Active Devices : 5
>> Working Devices : 5
>>   Failed Devices : 0
>>    Spare Devices : 0
>>         Checksum : 188e511f - correct
>>           Events : 33568
>>
>>           Layout : left-symmetric
>>       Chunk Size : 64K
>>
>>        Number   Major   Minor   RaidDevice State
>> this     0       8       96        0      active sync   /dev/sdg
>>
>>     0     0       8       96        0      active sync   /dev/sdg
>>     1     1       8      112        1      active sync   /dev/sdh
>>     2     2       8      128        2      active sync   /dev/sdi
>>     3     3       8      144        3      active sync   /dev/sdj
>>     4     4       8      160        4      active sync   /dev/sdk
>> root@niederhorn:/home/xbmc# mdadm --examine /dev/sdf
>> /dev/sdf:
>>            Magic : a92b4efc
>>          Version : 0.90.00
>>             UUID : 208886f0:0b0c5d65:d1ecd824:5a220e5e (local to host niederhorn)
>>    Creation Time : Mon Jul  2 00:08:03 2012
>>       Raid Level : raid5
>>    Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
>>       Array Size : 7814057984 (7452.07 GiB 8001.60 GB)
>>     Raid Devices : 5
>>    Total Devices : 5
>> Preferred Minor : 0
>>
>>      Update Time : Sat Apr 26 11:03:04 2014
>>            State : clean
>>   Active Devices : 5
>> Working Devices : 5
>>   Failed Devices : 0
>>    Spare Devices : 0
>>         Checksum : 188e5131 - correct
>>           Events : 33568
>>
>>           Layout : left-symmetric
>>       Chunk Size : 64K
>>
>>        Number   Major   Minor   RaidDevice State
>> this     1       8      112        1      active sync   /dev/sdh
>>
>>     0     0       8       96        0      active sync   /dev/sdg
>>     1     1       8      112        1      active sync   /dev/sdh
>>     2     2       8      128        2      active sync   /dev/sdi
>>     3     3       8      144        3      active sync   /dev/sdj
>>     4     4       8      160        4      active sync   /dev/sdk
>> root@niederhorn:/home/xbmc# mdadm --examine /dev/sdg
>> /dev/sdg:
>>            Magic : a92b4efc
>>          Version : 0.90.00
>>             UUID : 208886f0:0b0c5d65:d1ecd824:5a220e5e (local to host niederhorn)
>>    Creation Time : Mon Jul  2 00:08:03 2012
>>       Raid Level : raid5
>>    Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
>>       Array Size : 7814057984 (7452.07 GiB 8001.60 GB)
>>     Raid Devices : 5
>>    Total Devices : 5
>> Preferred Minor : 0
>>
>>      Update Time : Sat Apr 26 11:03:04 2014
>>            State : clean
>>   Active Devices : 5
>> Working Devices : 5
>>   Failed Devices : 0
>>    Spare Devices : 0
>>         Checksum : 188e5143 - correct
>>           Events : 33568
>>
>>           Layout : left-symmetric
>>       Chunk Size : 64K
>>
>>        Number   Major   Minor   RaidDevice State
>> this     2       8      128        2      active sync   /dev/sdi
>>
>>     0     0       8       96        0      active sync   /dev/sdg
>>     1     1       8      112        1      active sync   /dev/sdh
>>     2     2       8      128        2      active sync   /dev/sdi
>>     3     3       8      144        3      active sync   /dev/sdj
>>     4     4       8      160        4      active sync   /dev/sdk
>> root@niederhorn:/home/xbmc# mdadm --examine /dev/sdh
>> /dev/sdh:
>>            Magic : a92b4efc
>>          Version : 0.90.00
>>             UUID : 208886f0:0b0c5d65:d1ecd824:5a220e5e (local to host niederhorn)
>>    Creation Time : Mon Jul  2 00:08:03 2012
>>       Raid Level : raid5
>>    Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
>>       Array Size : 7814057984 (7452.07 GiB 8001.60 GB)
>>     Raid Devices : 5
>>    Total Devices : 5
>> Preferred Minor : 0
>>
>>      Update Time : Sat Apr 26 11:03:04 2014
>>            State : clean
>>   Active Devices : 5
>> Working Devices : 5
>>   Failed Devices : 0
>>    Spare Devices : 0
>>         Checksum : 188e5155 - correct
>>           Events : 33568
>>
>>           Layout : left-symmetric
>>       Chunk Size : 64K
>>
>>        Number   Major   Minor   RaidDevice State
>> this     3       8      144        3      active sync   /dev/sdj
>>
>>     0     0       8       96        0      active sync   /dev/sdg
>>     1     1       8      112        1      active sync   /dev/sdh
>>     2     2       8      128        2      active sync   /dev/sdi
>>     3     3       8      144        3      active sync   /dev/sdj
>>     4     4       8      160        4      active sync   /dev/sdk
>> root@niederhorn:/home/xbmc# mdadm --examine /dev/sdi
>> /dev/sdi:
>>            Magic : a92b4efc
>>          Version : 0.90.00
>>             UUID : 208886f0:0b0c5d65:d1ecd824:5a220e5e (local to host niederhorn)
>>    Creation Time : Mon Jul  2 00:08:03 2012
>>       Raid Level : raid5
>>    Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
>>       Array Size : 7814057984 (7452.07 GiB 8001.60 GB)
>>     Raid Devices : 5
>>    Total Devices : 5
>> Preferred Minor : 0
>>
>>      Update Time : Sat Apr 26 11:03:04 2014
>>            State : clean
>>   Active Devices : 5
>> Working Devices : 5
>>   Failed Devices : 0
>>    Spare Devices : 0
>>         Checksum : 188e5167 - correct
>>           Events : 33568
>>
>>           Layout : left-symmetric
>>       Chunk Size : 64K
>>
>>        Number   Major   Minor   RaidDevice State
>> this     4       8      160        4      active sync   /dev/sdk
>>
>>     0     0       8       96        0      active sync   /dev/sdg
>>     1     1       8      112        1      active sync   /dev/sdh
>>     2     2       8      128        2      active sync   /dev/sdi
>>     3     3       8      144        3      active sync   /dev/sdj
>>     4     4       8      160        4      active sync   /dev/sdk
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info athttp://vger.kernel.org/majordomo-info.html
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html

