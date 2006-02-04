From: "Oren Ben-Menachem" <oren@kcbbs.gen.nz>
Subject: Re: Help on rebuilding an array that had a massive failure.
Date: Sat, 4 Feb 2006 21:38:45 +1300 (NZDT)
Message-ID: <4273.192.203.83.7.1139042325.squirrel@192.203.83.14>
References: <3984.192.203.83.7.1139023706.squirrel@192.203.83.14>
    <17380.16413.243841.797524@cse.unsw.edu.au>
Reply-To: oren@kcbbs.gen.nz
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17380.16413.243841.797524@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: oren@kcbbs.gen.nz
List-Id: linux-raid.ids

> On Saturday February 4, oren@kcbbs.gen.nz wrote:
>> Hi all,
>>
>> I recently had a machine (Debian 2.6.7) with a raid array have a
>> failure,
>> the disk controller card died partially ( so a couple of disks went
>> offline) then died permantly taking a further two drives out of the
>> array.
>>
>> The array (/dev/md1) was made up of /dev/hda3, /dev/hdi3, /dev/hdk3,
>> /dev/hdl3 and /dev/hdj3) the array was made up of the first three and
>> then
>> the fourth was added (I believe).
>>
>> Mdadm.conf looks like:
>> ARRAY /dev/md1 level=raid5 num-devices=5
>> UUID=aeb44e5d:14388f60:8c2f39ec:9488facd
>>    devices=/dev/hda3,/dev/hdc3,/dev/hdd3,/dev/hde3,/dev/hdf3
>>
>> Due to the controller death I've moved the disks across to another
>> machine, which has relabelled the disks as hda, hdc, hdd, hde, hdf.
>>
>> I've attached the output of mdadm -E, below and have at least worked out
>> what the mapping is from old to new. (ie hda-hda, hdi-hdc, hdk-hde,
>> hdl-hdf, hdj-hdd).
>>
>> When I try to assemble the drives I either get a 3 disk array mounted or
>> the following output:
>> phineas:/etc# mdadm --assemble /dev/md1 /dev/hda3 /dev/hdc3 /dev/hde3
>> /dev/hdf3 /dev/hdd3
>> mdadm: failed to add /dev/hdf3 to /dev/md1: Invalid argument
>> mdadm: failed to add /dev/hdd3 to /dev/md1: Invalid argument
>> mdadm: /dev/md1 assembled from 3 drives - not enough to start the array.
>>
>
> hdf3 and hdd3 have bad checksums somehow, but otherwise look fine.
> You should be able to fix this with
>
>   mdadm --assemble /dev/md1 --update=summaries /dev/hd[acefd]3
>
> If that doesn't work, could just recreate the array:
>   mdadm --create /dev/md1 -l5 -c128 -n5 /dev/hda3 /dev/hdc3 /dev/hde3 \
>             /dev/hdf3 /dev/hdd3
>
> NeilBrown
>
Great thanks, the assemble with update summaries had eluded me, and I was
worried about the create as it had not necessarily been created all
togeather.  The assemble looks like it has mounted md1 for me.

Thanks


