From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID10 Layouts
Date: Fri, 21 Aug 2009 17:57:43 -0400
Message-ID: <4A8F1857.2010305@tmr.com>
References: <200908210627.06241.Info@quantum-sci.net> <87ljldce33.fsf@frosties.localdomain> <20090821204234.GA3683@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090821204234.GA3683@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, Info@quantum-sci.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keld J=F8rn Simonsen wrote:
> On Fri, Aug 21, 2009 at 06:43:28PM +0200, Goswin von Brederlow wrote:
>  =20
>> Info@quantum-sci.net writes:
>>
>>    =20
>>> Hello list,
>>>
>>> Researching RAID10, trying to learn the most advanced system for a =
2
>>> SATA drive system.  Have two WD 2TB drives for a media computer, an=
d
>>> the most important requirement is data redundancy.  I realize that
>>> RAID is no substitute for backups, but this is a backup for the
>>> backups and the purpose here is data safety.  The secondary goal is
>>> speed enhancement.  It appears that RAID10 can give both.
>>>
>>> First question is on layout of RAID10.  In studying the man pages i=
t
>>> seems that Far mode gives 95% of the speed of RAID0, but with
>>> increased seek for writes.  And that Offset retains much of this
>>> benefit while increasing efficiency of writes.  What should be the
>>> preference, Far or Offset?  Are they equally as robust?
>>>      =20
>> All raid10 layouts offer the same robustness. Which layout is best f=
or
>> you really depends on your use case. Probably the biggest factor wil=
l
>> be the average file size. My experience is that with large files the
>> far copies do not cost noticeable write speed while being twice as
>> fast reading as raid1.
>>    =20
>
> The file system elevator makes up for the Far write head movement.
>
>  =20
>>> How safe is the data in Far or Offset mode?  If a drive fails, will
>>> a complete, usable, bootable system exist on the other drive?
>>> (These two are the only drives in the system, which is Debian
>>> Testing, Debian kernel 2.6.30-5) Need I make any special Grub
>>> settings?
>>>      =20
>> I don't think lilo or grub1 can boot from raid10 at all with offset =
or
>> far copies. With near copies you are identical to a simple raid1 so
>> that would boot.
>>    =20
>
> there is a howto on setting up a system, that can continue runnig, if=
 one=20
> disk fails at
> http://linux-raid.osdl.org/index.php/Preventing_against_a_failing_dis=
k
>
>  =20
>>> How does this look:
>>> # mdadm --create /dev/md0 --level=3Draid10 --layout=3Do2 --metadata=
=3D1.2 --chunk=3D64 --raid-disks=3D2 missing /dev/sdb1
>>>      =20
>> On partitions it is save to use 1.1 format. Saves you 4k. Jupey.
>>
>> You should play with the chunksize though and try with and without
>> bitmap and different bitmap sizes. Bitmap costs some write performan=
ce
>> but it greatly speeds up resyncs after a crash or temporary drive
>> failure.
>>    =20
>
> I would recommend a bigger chunk size. at least 256 kiB.
>  =20

You really want to look at stripe-size and stride-size creating an=20
ext[234] filesystem on top of raid, good things to happen there.

--=20
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"You are disgraced professional losers. And by the way, give us our mon=
ey back."
    - Representative Earl Pomeroy,  Democrat of North Dakota
on the A.I.G. executives who were paid bonuses  after a federal bailout=
=2E



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
