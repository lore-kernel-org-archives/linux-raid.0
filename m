From: "A. James Lewis" <james@fsck.co.uk>
Subject: Re: [PATCH md 2 of 4] Fix raid6 problem
Date: Sun, 23 Jan 2005 14:02:01 -0000 (GMT)
Message-ID: <33023.212.158.231.74.1106488921.squirrel@mail.fsck.co.uk>
References: <38038.212.158.231.74.1099526180.squirrel@mail.fsck.co.uk>
    <200412090021.iB90L4MK014200@terminus.zytor.com>
Reply-To: james@fsck.co.uk
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200412090021.iB90L4MK014200@terminus.zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Sorry for the delay in replying, I've been using RAID6 in a real life
situation with 2.6.9 + patch, for 2 months now, with 1.15Tb of storage,
and I have had more than 1 drive failure... as well as some rather
embarasing hardware corruption which I traced to a faulty IDE controlle=
r.

Dispite some random DMA corrupion, and loosing a total of 3 disks, I ha=
ve
not had any problems with it RAID6 itself, and really it has litereally
saved my data from being lost.

I ran a diff against the 2.6.9 patch and what is in 2.6.10... and they =
are
not the same, presumably a more elegant fix has been implimented for th=
e
production kernel??

As an aside,

At the moment, I am experimenting with RAID on top of USB Mass Storage
devices... it's interesting because the USB system takes a significant
time to identify and make each drive available, and I have to determine=
 if
all the drives have become available before starting any arrays....

Does anyone have any experience with this sort of thing?

I'm sure H. Peter Anvin said somthing about:
> Followup to:  <38038.212.158.231.74.1099526180.squirrel@mail.fsck.co.=
uk>
> By author:    "A. James Lewis" <james@fsck.co.uk>
> In newsgroup: linux.dev.raid
>>
>> I'd like to put raid6 to use, and after reading through the process =
of
>> tracking down this bug, it seems that a rational explanation was fou=
nd
>> for
>> the data corruption, and the fix well tested... but being new to a l=
ot
>> of
>> the process here, what is the process for this to get into the stand=
ard
>> kernel... perhaps 2.6.10 will have this patch??
>>
>> Obviously I could apply the patch to raid6main.c on my system, but i=
t
>> would be  good to use a standard kernel...
>>
>> The problem is only when writing to a degraded array, but most of us=
 are
>> impatient and want to write a filesystem and get it mounted before t=
he
>> first sync is complete... and those, like me cursed with bad hardwar=
e
>> will
>> have 2 drives fail at the same time (last week!) and hence raid6 is =
very
>> appealing :).
>>
>
> Hi James,
>
> This patch got integrated in, I believe, 2.6.10-rc2.
>
> Please let me know what your experience is.  It would be good to get
> the EXPERIMENTAL tag taken off at some point.
>
> 	-hpa
>
>
> !DSPAM:41b79a8888125029010830!
>
>
>


--=20
=AF=B7.=B8=B8.=B7=B4=AF=B7.=B8=B8.-> A. James Lewis (james@fsck.co.uk)
http://www.fsck.co.uk/personal/nopistons.jpg
MAZDA - World domination through rotary power.

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
