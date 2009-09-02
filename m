From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Unbalanced reads of RAID10
Date: Wed, 2 Sep 2009 23:27:06 +0200
Message-ID: <20090902212706.GA17680@rap.rap.dk>
References: <20090823142439.GA5162@lazy.lzy> <20090830003706.GB5633@rap.rap.dk> <4A9E999B.8070401@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A9E999B.8070401@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Sep 02, 2009 at 12:13:15PM -0400, Bill Davidsen wrote:
> Keld J=F8rn Simonsen wrote:
>> On Sun, Aug 23, 2009 at 04:24:39PM +0200, Piergiorgio Sartor wrote:
>>  =20
>>> Hi all,
>>>
>>> some time ago I was reporting about a strange issue.
>>>
>>> I have a two HDDs system, with a small RAID1 (/boot)
>>> and the rest as RAID10 f2 (with LVM on top).
>>>
>>> It seems that /dev/sdb has more reads than /dev/sda.
>>>
>>> I had a quick check, with "iostat", and it seems that
>>> all small reads, somehow below 1~4KiB, are done from
>>> /dev/sdb2, regardless.
>>> Actually, it seems that only if there is a pending
>>> (small) read, this will be scheduled to /dev/sda2,
>>> but non-overlapping small reads seem to happen always
>>> from /dev/sdb2.
>>>
>>> This occurs with the RAID10, but it seems also with
>>> the RAID1.
>>>    =20
>>
>> Hmm, have you done testing separately on each array?
>>
>>  =20
>>> In normal operation, this does not seem to lead to
>>> problems, but during the smart long test /dev/sdb
>>> takes by far more time than /dev/sda, since each
>>> small read stop the test, and small read occurs
>>> whenever there is a small write from syslog or
>>> similar.
>>> Note that failing and removing /dev/sdb2 results
>>> in much shorter time for the smart test, about
>>> 1hr30min vs. the 6~7hrs with the drive still
>>> attached to RAID10.
>>>
>>> Is there any way to tune which is the "preferred"
>>> drive or the "preferred" policy in case of these
>>> small (or big) reads?
>>>    =20
>>
>> What level of the kernel are you running?
>>
>>  =20
>>> Could this be due to HW configuration?
>>> The two HDDs are numbered SATA1 and SATA2 in BIOS,
>>> there are still SATA3 and SATA4 ports somehow
>>> available (SATA3 has a DVD).
>>>
>>> How are the reads scheduled withing the RAID10 software?
>>>    =20
>>
>> there was a change of this about 2.6.25 which forced reads to always=
 be
>> from the faster inner part of the disks, and that should even out re=
ads.
>>  =20
>
> ??? what faster inner part is that? The linear velocity and =20
> bytes/cylinder are higher as the diameter increases.

I meant the faster lower numbered sectors, which are the *outer*
sectors on the physical disk.

Best regards
Keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
