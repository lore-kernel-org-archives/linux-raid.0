From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Unbalanced reads of RAID10
Date: Wed, 02 Sep 2009 12:13:15 -0400
Message-ID: <4A9E999B.8070401@tmr.com>
References: <20090823142439.GA5162@lazy.lzy> <20090830003706.GB5633@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090830003706.GB5633@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keld J=F8rn Simonsen wrote:
> On Sun, Aug 23, 2009 at 04:24:39PM +0200, Piergiorgio Sartor wrote:
>  =20
>> Hi all,
>>
>> some time ago I was reporting about a strange issue.
>>
>> I have a two HDDs system, with a small RAID1 (/boot)
>> and the rest as RAID10 f2 (with LVM on top).
>>
>> It seems that /dev/sdb has more reads than /dev/sda.
>>
>> I had a quick check, with "iostat", and it seems that
>> all small reads, somehow below 1~4KiB, are done from
>> /dev/sdb2, regardless.
>> Actually, it seems that only if there is a pending
>> (small) read, this will be scheduled to /dev/sda2,
>> but non-overlapping small reads seem to happen always
>> from /dev/sdb2.
>>
>> This occurs with the RAID10, but it seems also with
>> the RAID1.
>>    =20
>
> Hmm, have you done testing separately on each array?
>
>  =20
>> In normal operation, this does not seem to lead to
>> problems, but during the smart long test /dev/sdb
>> takes by far more time than /dev/sda, since each
>> small read stop the test, and small read occurs
>> whenever there is a small write from syslog or
>> similar.
>> Note that failing and removing /dev/sdb2 results
>> in much shorter time for the smart test, about
>> 1hr30min vs. the 6~7hrs with the drive still
>> attached to RAID10.
>>
>> Is there any way to tune which is the "preferred"
>> drive or the "preferred" policy in case of these
>> small (or big) reads?
>>    =20
>
> What level of the kernel are you running?
>
>  =20
>> Could this be due to HW configuration?
>> The two HDDs are numbered SATA1 and SATA2 in BIOS,
>> there are still SATA3 and SATA4 ports somehow
>> available (SATA3 has a DVD).
>>
>> How are the reads scheduled withing the RAID10 software?
>>    =20
>
> there was a change of this about 2.6.25 which forced reads to always =
be
> from the faster inner part of the disks, and that should even out rea=
ds.
>  =20

??? what faster inner part is that? The linear velocity and=20
bytes/cylinder are higher as the diameter increases.

--=20
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"Now we have another quarterback besides Kurt Warner telling us during =
postgame
interviews that he owes every great thing that happens to him on a foot=
ball
field to his faith in Jesus. I knew there had to be a reason why the Al=
mighty
included a mute button on my remote."
			-- Arthur Troyer on Tim Tebow (Sports Illustrated)


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
