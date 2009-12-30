From: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Subject: Re: raid0 not growable?
Date: Wed, 30 Dec 2009 17:55:38 +0000
Message-ID: <73e903670912300955o63e5adb2va33a610f27ab1edb@mail.gmail.com>
References: <73e903670912230552n226e9052q182174cba32f3c54@mail.gmail.com>
	<20091224094557.1ae96a0d@notabene> <73e903670912231528u6d3cd2ekd0fa4ade06adbcf5@mail.gmail.com>
	<20091224105424.62c41b25@notabene> <73e903670912300725g20dc1746mf51db90a7e90e929@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <73e903670912300725g20dc1746mf51db90a7e90e929@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Dec 30, 2009 at 3:25 PM, Kristleifur Da=F0ason
<kristleifur@gmail.com> wrote:
> On Wed, Dec 23, 2009 at 11:54 PM, Neil Brown <neilb@suse.de> wrote:
>> On Wed, 23 Dec 2009 23:28:37 +0000
>> Kristleifur Da=F0ason <kristleifur@gmail.com> wrote:
>>
>>> On Wed, Dec 23, 2009 at 10:45 PM, Neil Brown <neilb@suse.de> wrote:
>>> > On Wed, 23 Dec 2009 13:52:54 +0000
>>> > Kristleifur Da=F0ason <kristleifur@gmail.com> wrote:
>>> >
>>> >> Hi,
>>> >>
>>> >> I'm running a raid0 array over a couple of raid6 arrays. I had p=
lanned
>>> >> on growing the arrays in time, and now turns out to be the time.
>>> >>
>>> > If the two raid6 arrays are exactly the same size, then you
>>> > could grow the two raid6 arrays, create a new raid0 over them
>>> > with the same block size and all your data will still be there.
>>> > But if they are not the same size, that won't work.
>>>
>>> Current chunksize is 256 and metadata is 1.1. So it's just a "mdadm
>>> --create /dev/md_bigraid0 --level=3D0 --raid-devices=3D2 --metadata=
=3D1.1
>>> --chunksize=3D256 /dev/md_raid6a /dev/md_raid6b", right?
>>
>> Yes... there is a possible complication though.
>> With 1.1 metadata mdadm reserves some space between the end of the m=
etadata
>> and the start of the data for a bitmap - even for raid0 which cannot=
 have
>> a bitmap. =A0The amount of space reserved is affected by the size of=
 the
>> devices.
>> So it is possible that the "data offset" will be different.
>> You should check the data offset before and after. =A0If it is diffe=
rent, we
>> will have to hack mdadm to allow you to set the data offset manually=
=2E
>
> ... I believe I am guaranteed an identical bitmap size and hence an i=
dentical data offset.
>
> And in theory, this case is closed. Thank you, all.
>

Yep, it worked great. We built the new raid0 array over the old one,
and did a "fsck.jfs -n" dry-run over the filesystem. Still there,
clean as a whistle. Next was a quick "mount -o remount,resize /tank"
which grew the JFS filesystem in a second or two.

Very quick and painless. For my purposes, I consider raid0 arrays to
be growable. Such was the ease. Even though raid0 may not be
officially growable.

-- Kristleifur
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
