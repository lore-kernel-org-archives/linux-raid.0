From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Doubt
Date: Thu, 5 Nov 2009 08:35:21 -0800
Message-ID: <4877c76c0911050835w2d993a76q1ee5a137d43714b2@mail.gmail.com>
References: <d3540f4d0911042326o754d5f06qf958d8ab5b309e86@mail.gmail.com>
	 <4877c76c0911042342v7fcd67c4j120b2addf99eabba@mail.gmail.com>
	 <d3540f4d0911050044w4ff51fddoba0aced44e3988b3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d3540f4d0911050044w4ff51fddoba0aced44e3988b3@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Light King <thelightking@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You're not looking for something that raid, software or otherwise, can =
provide.

Given that you are using only 4 devices, overall storage to redundancy
ratios can be 0, 25, 50, 66, or 75%.  Were you using 5 devices those
ratios would be 0, 20, 40, 50, 60, 66, and 80%. (The 50% number can
always be attained when using raid10. As can 2 redundant stripes per
data stripe (2/3); I'm ignoring higher multiples of this number.)

If you only want a small percentage of redundancy you must seek other
solutions.  My prior suggestion of using each card individually and
utilizing some kind of software solution to distribute the load could
work; you could also use the par2 (parchive version 2 aka par2cmdline
) command to create redundancy information for one or more files
within a directory; it uses a more general case reed-solomon
http://en.wikipedia.org/wiki/Reed=96Solomon_error_correction to
logically divide a set of input files in to a number of byte-chunks
and then produce a rough percentage of redundancy or to produce a
specified number of redundancy blocks (blocks that can fail in the
file in question).

This won't protect you from device-level failure that compromises the
filesystem, but it will protect against partial device failure.  For
your application merely detecting the existence of a failure may be
sufficient, in which case any number of checksum utilities would be
useful.

On Thu, Nov 5, 2009 at 12:44 AM, Light King <thelightking@gmail.com> wr=
ote:
> Sir ,
>
> Thanks for Ur valuable reply . =A0I ve some more thoughts ....
>
> We want a solution like if 5 to 10 % of memory is going for reductanc=
y
> thn it is ok for us . We dont want data recovery fully of permanent
> data . We want when system is running if one CARD goes bad then the
> array shd continue work without any disturbance .
>
> Can we run the reductancy application of the array in RAM (We ve to
> specify some space in RAM) of the system ? When system
> is switched off we dont want previous data stored but ;upto the perio=
d
> the system is switched on we want the CF cars to work as a cache (Its
> not like RAM opeartion exactly)for our system for running data .
>
> plz give some idea ......
>
> Ansh
>
>
> On Thu, Nov 5, 2009 at 1:12 PM, Michael Evans <mjevans1983@gmail.com>=
 wrote:
>> Your requirements are contradictory. =A0You want to span all your
>> devices with a single storage system, but you do not want to use any
>> devices for redundancy and expect the filing system on them to remai=
n
>> consistent should any of the devices fail.
>>
>> That is simply impossible for file-systems, which is what block-devi=
ce
>> aggregation such as mdadm is designed to support. =A0Were you to loo=
se
>> any random device out of the four portions of the filesystem metadat=
a
>> as well as your actual data would be missing. =A0That may be tolerab=
le
>> for special cases (regularly sampled data, such as sensor outputs
>> comes to mind, when you don't -require- the sensor data, but merely
>> want to have it), however those cases are all application specific,
>> not general solution.
>>
>> One typical way a specific application might use four devices would =
be
>> a round-robin method. =A0In this a list of currently online devices
>> would be kept, then each cohesive unit would be stored to the next
>> device in the list. =A0Should a device be added the list would grow,
>> should a device fail (be removed) it would be taken out of the list.
>>
>> You have four choices then:
>>
>> 1) What I described above
>> 2) A Raid 0 that gives you 100% storage, but all devices working or =
none.
>> 3) A Raid 1+0 or 10 (same idea different drivers) solution, you're
>> already trying it and disliking it though.
>> 4) Raid 5; you spend more CPU but you use one of the devices for
>> recovery data, so that you can tolerate a single failure.
>> 5) Technically you might also have raid 6; but I'm not counting it
>> because you're already complaining about loosing 50% of your data an=
d
>> this has the addition of being slower (BUT surviving -literally- any=
 2
>> devices, instead of any 1 device of the correct set.)
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
