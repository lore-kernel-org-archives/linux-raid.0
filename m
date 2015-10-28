From: Guillaume ALLEE <guillaume.allee@gmail.com>
Subject: Re: 2nd Faulty drive while rebuilding array on RAID5
Date: Wed, 28 Oct 2015 21:35:49 +0100
Message-ID: <CABEdK7wDU42phn2RTqUQWVTCet5v+WqtRYoD0ezvHXpGioapmQ@mail.gmail.com>
References: <CABEdK7w7zjjEXXenWRK0BSziekBGhkni50y0j3t=rW2AxNkkqQ@mail.gmail.com>
	<562D67E3.6050708@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <562D67E3.6050708@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Phil,


Thanks for your answer. I have tested my sda3 with badblocks and it
seems really bad like 6 digits unreadable blocks...

> Something's missing.  I see only sd[abcd]3.  Where's the report for
> /dev/sde* ?
Yep because /dev/sde is not part of my /dec/md1 array.

"ARRAY /dev/md1 level=raid5 num-devices=4 metadata=00.90
UUID=426d71a2:5b25a168:a4e2eff2:d305f1c1
   devices=/dev/sda3,/dev/sdb3,/dev/sdc3,/dev/sdd3"
>
> Yes, you have WD20EARS and ST3000DM001 drive models.  These are not safe
> to use in raid arrays due to lack of error recovery control.
Okay I will look at that for my next HDs.


> You need to stop the array and perform an '--assemble --force' with the
> last four devices (exclude /dev/sdc).  The ones that have "Raid Device"
> 0, 1, 2, & 3.
Here is the assemble output.

#mdadm --assemble --force /dev/md1 /dev/sda3 /dev/sdb3 /dev/sdd3
mdadm: no recogniseable superblock on /dev/sda3
mdadm: /dev/sda3 has no superblock - assembly aborted
>
> If that fails, show mdadm's responses in your next reply.

> Phil

Thanks I will read  those links

2015-10-26 0:38 GMT+01:00 Phil Turmel <philip@turmel.org>:
> Hi Guillaume,
>
> On 10/24/2015 06:27 PM, Guillaume ALLEE wrote:
>> Hi all,
>>
>> Context:
>> On my RAID5 sdc was faulty. I bought a new HD, format it and add it to
>> my raid array. However during the rebuilding sda was detected as
>> faulty. Now I am not sure what to do...
>
> Unfortunately, you are suffering from classic timeout mismatch.  I've
> put some links in the postscript for you to read.  Most likely, your
> original sdc wasn't really bad.
>
> [trim /]
>
>> $ mdadm --examine /dev/sd[abcdefghijklmn]3 >> raid.status
>> http://pastebin.com/qaP8bvna
>
> Something's missing.  I see only sd[abcd]3.  Where's the report for
> /dev/sde* ?
>
> [trim /]
>
>> Full dmesg available at:
>> http://pastebin.com/bBfcYjkg
>
> Yes, you have WD20EARS and ST3000DM001 drive models.  These are not safe
> to use in raid arrays due to lack of error recovery control.
>
>> Is there some way to re-add this disk (sda) in the array without mdadm
>> thinging it is a new one ?
>
> You need to stop the array and perform an '--assemble --force' with the
> last four devices (exclude /dev/sdc).  The ones that have "Raid Device"
> 0, 1, 2, & 3.
>
> If that fails, show mdadm's responses in your next reply.  If it works,
> your array will be available to mount, but degraded.  You will not be
> able to add your new sdc to the array while there are unresolved UREs,
> so you will need to backup your important data from the degraded array.
>  UREs can only be fixed by writing over them -- normally done
> automatically by MD with proper drives.  You will have to overwrite
> those spots with zeroes or use dd_rescue to move the data to fresh
> drives (with zeroes in place of the unreadable spots).
>
>> I have seen from the wiki that I could try to recreate the array with
>> --assume-clean but I want to do that only in last resort.
>
> Do *NOT* recreate the array.  (Unless you're starting over after backing
> up the files from the degraded array.)
>
> Phil
>
> [1] http://marc.info/?l=linux-raid&m=139050322510249&w=2
> [2] http://marc.info/?l=linux-raid&m=135863964624202&w=2
> [3] http://marc.info/?l=linux-raid&m=135811522817345&w=1
> [4] http://marc.info/?l=linux-raid&m=133761065622164&w=2
> [5] http://marc.info/?l=linux-raid&m=132477199207506
> [6] http://marc.info/?l=linux-raid&m=133665797115876&w=2
> [7] http://marc.info/?l=linux-raid&m=142487508806844&w=3
> [8] http://marc.info/?l=linux-raid&m=144535576302583&w=2
>
