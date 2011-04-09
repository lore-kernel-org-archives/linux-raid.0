From: Linux Raid Study <linuxraid.study@gmail.com>
Subject: Re: iostat with raid device...
Date: Fri, 8 Apr 2011 17:40:46 -0700
Message-ID: <BANLkTin2KP-_vy8jbmV3JB-LHHJNOEVCKw@mail.gmail.com>
References: <BANLkTi=6uvCsQTpCi4xLUWzx5X7o99_=5g@mail.gmail.com>
	<20110409094629.2eae2d5b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110409094629.2eae2d5b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

This is raid5. I have mounted /dev/md0 to /mnt and file system is ext4.

The system is newly created. Steps:
mdadm for raid5
mkfs.ext4 /dev/md0
mount /dev/md0 /mnt/raid
Export /mnt/raid to remote PC using CIFS
Copy file from PC to the mounted drive

An update....
I just ran the test again (without doing reformatting device) and
noticed all 4 HDDs incremented the #ofWritesBlocks equally. This
implies that when raid was configured first time, raid5 was trying to
do its own stuff (recovery)...

What I'm not sure of is if the device is newly formatted, would raid
recovery happen? What else could explain difference in the first run
of IO benchmark?


Thanks.

On Fri, Apr 8, 2011 at 4:46 PM, NeilBrown <neilb@suse.de> wrote:
> On Fri, 8 Apr 2011 12:55:39 -0700 Linux Raid Study
> <linuxraid.study@gmail.com> wrote:
>
>> Hello,
>>
>> I have a raid device /dev/md0 based on 4 devices sd[abcd].
>
> Would this be raid0? raid1? raid5? raid6? raid10?
> It could make a difference.
>
>>
>> When I write 4GB to /dev/md0, I see following output from iostat...
>
> Are you writing directly to the /dev/md0, or to a filesystem mounted
> from /dev/md0? =C2=A0It might be easier to explain in the second case=
, but you
> text suggests the first case.
>
>>
>> Ques:
>> Shouldn't I see write/sec to be same for all four drives? Why does
>> /dev/sdd always have higher value for =C2=A0BlksWrtn/sec?
>> My strip size is 1MB.
>>
>> thanks for any pointers...
>>
>> avg-cpu: =C2=A0%user =C2=A0 %nice %system %iowait =C2=A0%steal =C2=A0=
 %idle
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00.02 =C2=A0 =C2=A00.00 =C2=A0=
 =C2=A00.34 =C2=A0 =C2=A00.03 =C2=A0 =C2=A00.00 =C2=A0 99.61
>>
>> Device: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tps =C2=A0 Blk_read=
/s =C2=A0 Blk_wrtn/s =C2=A0 Blk_read =C2=A0 Blk_wrtn
>> sda =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1.08 =C2=A0 =C2=
=A0 =C2=A0 247.77 =C2=A0 =C2=A0 =C2=A0 338.73 =C2=A0 37478883 =C2=A0 51=
237136
>> sda1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01.08 =C2=A0 =C2=
=A0 =C2=A0 247.77 =C2=A0 =C2=A0 =C2=A0 338.73 =C2=A0 37478195 =C2=A0 51=
237136
>> sdb =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1.08 =C2=A0 =C2=
=A0 =C2=A0 247.73 =C2=A0 =C2=A0 =C2=A0 338.78 =C2=A0 37472990 =C2=A0 51=
245712
>> sdb1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01.08 =C2=A0 =C2=
=A0 =C2=A0 247.73 =C2=A0 =C2=A0 =C2=A0 338.78 =C2=A0 37472302 =C2=A0 51=
245712
>> sdc =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1.10 =C2=A0 =C2=
=A0 =C2=A0 247.82 =C2=A0 =C2=A0 =C2=A0 338.66 =C2=A0 37486670 =C2=A0 51=
226640
>> sdc1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01.10 =C2=A0 =C2=
=A0 =C2=A0 247.82 =C2=A0 =C2=A0 =C2=A0 338.66 =C2=A0 37485982 =C2=A0 51=
226640
>> sdd =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1.09 =C2=A0 =C2=
=A0 =C2=A0 118.46 =C2=A0 =C2=A0 =C2=A0 467.97 =C2=A0 17918510 =C2=A0 70=
786576
>> sdd1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01.09 =C2=A0 =C2=
=A0 =C2=A0 118.45 =C2=A0 =C2=A0 =C2=A0 467.97 =C2=A0 17917822 =C2=A0 70=
786576
>> md0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A065.60 =C2=A0 =C2=
=A0 =C2=A0 443.79 =C2=A0 =C2=A0 =C2=A01002.42 =C2=A0 67129812 =C2=A0151=
629440
>
> Doing the sums, for every 2 blocks written to md0 we see 3 blocks wri=
tten to
> some underlying device. =C2=A0That doesn't make much sense for a 4 dr=
ive array.
> If we assume that the extra writes to sdd were from some other source=
, then
> It is closer to a 3:4 ratio which suggests raid5.
> So I'm guessing that the array is newly created and is recovering the=
 data on
> sdd1 at the same time as you are doing the IO test.
> This would agree with the observation that sd[abc] see a lot more rea=
ds than
> sdd.
>
> I'll let you figure out the tps number.... do the math to find out th=
e
> average blk/t number for each device.
>
> NeilBrown
>
>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
