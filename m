From: Reynald Borer <reynald.borer@gmail.com>
Subject: Re: mdXX: bitmap superblock UUID mismatch
Date: Mon, 14 Feb 2011 17:33:29 +0100
Message-ID: <AANLkTi=xahVD7A29jYZ53fY4h6U0AU=kyWqhXwwmkgLK@mail.gmail.com>
References: <AANLkTik83a9aEmywdcMEvpGwVMt_i=pS0dmg2s_o=EYG@mail.gmail.com> <20110128075346.4276e2d1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110128075346.4276e2d1@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Nice catch for the 1 bit difference, I didn't see it. My point
regarding bitmap reconstruction was because this raid was used in a
LVM setup. the LVM partition used two distinct raid 1 disks, and I was
not able to start the LVM correctly without this failing raid.

In the end, I was able to save my LVM by simply skipping the raid 1
and using directly one partition. The LVM tool was clever enough to
detect the MD bits and proposed me to remove them in order to mount
directly the partition, and it worked fine. Thus I was able to save my
data.

Thanks for your answer though.

Regards,
Reynald


On Thu, Jan 27, 2011 at 9:53 PM, NeilBrown <neilb@suse.de> wrote:
> On Wed, 26 Jan 2011 21:58:25 +0100 Reynald Borer <reynald.borer@gmail=
=2Ecom>
> wrote:
>
>> Hello guys,
>>
>> I have been using md raids for quite a long time now and it always
>> worked fine, until recently when I upgraded some hardware on my
>> workstation. Unfortunately the hardware I changed proved itself to b=
e
>> very unstable, and I encountered a lot of hard lockups of the system
>> while running. Those lockups recently made one of my raid 1 array
>> fails with the infamous error message "mdXX: bitmap superblock UUID
>> mismatch".
>>
>> Here is what I have found in the kernel logs when I try to activate
>> the given raid group:
>> -----------------
>> md/raid1:md126: active with 2 out of 2 mirrors
>> md126: bitmap superblock UUID mismatch
>> md126: bitmap file superblock:
>> =A0 =A0 =A0 =A0 =A0magic: 6d746962
>> =A0 =A0 =A0 =A0version: 4
>> =A0 =A0 =A0 =A0 =A0 uuid: 37102258.af9c1930.b8397fb8.eba356af
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ^ this is an 'a'
>
>> =A0 =A0 =A0 =A0 events: 199168
>> events cleared: 199166
>> =A0 =A0 =A0 =A0 =A0state: 00000000
>> =A0 =A0 =A0chunksize: 524288 B
>> =A0 daemon sleep: 5s
>> =A0 =A0 =A0sync size: 248075584 KB
>> max write behind: 0
>> md126: failed to create bitmap (-22)
>> -----------------
>>
>>
>> Such error messages are displayed each time I try to run the raid
>> group. Content of /proc/mdstat is:
>> -----------------
>> md126 : inactive sdb6[0] sda6[1]
>> =A0 =A0 =A0 496151168 blocks
>> -----------------
>>
>>
>> If I try to examine both disks with mdadm -E it shows some checksum
>> mismatch for both partitions:
>> -----------------
>> root@bob # mdadm -E /dev/sda6
>> /dev/sda6:
>> =A0 =A0 =A0 =A0 =A0 Magic : a92b4efc
>> =A0 =A0 =A0 =A0 Version : 0.90.03
>> =A0 =A0 =A0 =A0 =A0 =A0UUID : 37102258:bf9c1930:b8397fb8:eba356af
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ^ this is a '=
b'
>
> So you certainly do have some sick hardware!!!
>
> I suggest that you find some hardware that you can trust,
> mount one of the two devices ( (sdb6 or sda6) ignoring the raid stuff=
,
> and copy data off to the device that you trust.
>
> Then start again.
>
> NeilBrown
>
>
>> =A0 Creation Time : Mon Aug =A07 21:06:47 2006
>> =A0 =A0 =A0Raid Level : raid1
>> =A0 Used Dev Size : 248075584 (236.58 GiB 254.03 GB)
>> =A0 =A0 =A0Array Size : 248075584 (236.58 GiB 254.03 GB)
>> =A0 =A0Raid Devices : 2
>> =A0 Total Devices : 2
>> Preferred Minor : 6
>>
>> =A0 =A0 Update Time : Wed Jan 12 00:12:44 2011
>> =A0 =A0 =A0 =A0 =A0 State : clean
>> =A0Active Devices : 2
>> Working Devices : 2
>> =A0Failed Devices : 0
>> =A0 Spare Devices : 0
>> =A0 =A0 =A0 =A0Checksum : e4883f8e - expected e4883e8e
>> =A0 =A0 =A0 =A0 =A0Events : 199168
>>
>>
>> =A0 =A0 =A0 Number =A0 Major =A0 Minor =A0 RaidDevice State
>> this =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 38 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync
>>
>> =A0 =A00 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 70 =A0 =A0 =A0 =A00 =A0=
 =A0 =A0active sync
>> =A0 =A01 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 38 =A0 =A0 =A0 =A01 =A0=
 =A0 =A0active sync
>> root@bob # mdadm -E /dev/sdb6
>> /dev/sdb6:
>> =A0 =A0 =A0 =A0 =A0 Magic : a92b4efc
>> =A0 =A0 =A0 =A0 Version : 0.90.03
>> =A0 =A0 =A0 =A0 =A0 =A0UUID : 37102258:bf9c1930:b8397fb8:eba356af
>> =A0 Creation Time : Mon Aug =A07 21:06:47 2006
>> =A0 =A0 =A0Raid Level : raid1
>> =A0 Used Dev Size : 248075584 (236.58 GiB 254.03 GB)
>> =A0 =A0 =A0Array Size : 248075584 (236.58 GiB 254.03 GB)
>> =A0 =A0Raid Devices : 2
>> =A0 Total Devices : 2
>> Preferred Minor : 6
>>
>> =A0 =A0 Update Time : Wed Jan 12 00:12:44 2011
>> =A0 =A0 =A0 =A0 =A0 State : clean
>> =A0Active Devices : 2
>> Working Devices : 2
>> =A0Failed Devices : 0
>> =A0 Spare Devices : 0
>> =A0 =A0 =A0 =A0Checksum : e4883fac - expected e4883eac
>> =A0 =A0 =A0 =A0 =A0Events : 199168
>>
>>
>> =A0 =A0 =A0 Number =A0 Major =A0 Minor =A0 RaidDevice State
>> this =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 70 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync
>>
>> =A0 =A00 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 70 =A0 =A0 =A0 =A00 =A0=
 =A0 =A0active sync
>> =A0 =A01 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 38 =A0 =A0 =A0 =A01 =A0=
 =A0 =A0active sync
>> -----------------
>>
>>
>> Any idea how I could try to save my raid group?
>>
>> Thanks in advance for your help.
>>
>> Best Regards,
>> Reynald
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
