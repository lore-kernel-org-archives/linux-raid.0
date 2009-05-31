From: SandeepKsinha <sandeepksinha@gmail.com>
Subject: Re: RAID5 reconstruction ?
Date: Sun, 31 May 2009 13:40:07 +0530
Message-ID: <37d33d830905310110y4a718322t1020bb7e9a256ab1@mail.gmail.com>
References: <37d33d830905292244w685499b3h391aa2ca7a5b1ad@mail.gmail.com>
	 <4A213612.7080206@anonymous.org.uk>
	 <1243699735.5740.103.camel@localhost>
	 <87d49qzajf.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87d49qzajf.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Redeeman <redeeman@metanurb.dk>, John Robinson <john.robinson@anonymous.org.uk>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, May 31, 2009 at 12:24 AM, Goswin von Brederlow
<goswin-v-b@web.de> wrote:
> Redeeman <redeeman@metanurb.dk> writes:
>
>> On Sat, 2009-05-30 at 14:35 +0100, John Robinson wrote:
>>> On 30/05/2009 06:44, SandeepKsinha wrote:
>>> > Hi all,
>>> >
>>> > Say If I have a RAID 5 array of 50GB of five disks of 10GB each.
>>> >
>>> > I have data of 5GB. When a disk fails and replaced with a spare d=
isk.
>>> > Will the reconstruction happen only for the 5GB allocated disk bl=
ocks
>>> > or it will happen for the whole disk size.
>>>
>>> The whole disc size, for now anyway; md does not currently note whi=
ch
>>> blocks have been used by its client (the filesystem, LVM, whatever)=
=2E
>>>
>>> > Is it possible to make =A0reconstruction intelligent enough to ke=
ep it optimized ?
>>>
>>> This has been discussed in combination with supporting SSD drives' =
TRIM
>>> function, and would mean md had to keep track of used chunks or pos=
sibly
>>> even sectors using a bitmap or something like that, but whether any=
one's
>>> working on it I don't know.
>>
>> I would say it should be possible to 'query' the filesystem for that
>> information. Obviously this will only work if you run a filesystem o=
n it
>> which supports it, but it would seem like a nicer solution than a bi=
tmap
>> for it.
>
You have put a big constraint here of "filesystem which supports it".
In general, I have not known any file system work as yet which
leverages the underlying device topology to optimize its block
allocation policies for enhaced I/O, etc.
Or for any other reasons.

Having a bitmap can surely have lot of other benefits too. Looking at
the drive sizes in recent times, think of situation where you have to
do a reconstruction or resysnc. It might take months for them to
complete. Also, in the meanwhile you will have degraded I/O's.

Just in worst case, if your drive has most of allocated blocks, it
will be a penalty.

> On the other hand checking a bitmap is quick. You could use the bitma=
p
> not only for reconstruction but also for reads. If the bitmap say the
> block is unused you can skip the read and just zero fill the
> buffer. This would speed up reads and writes that don't cover the ful=
l
> stripe. And compared to a raid with current bitmap there shouldn't be
> any real slowdown for the extra "unused" bit.
>
> The only special case for resync would be that if all data blocks in =
a
> stripe are unused then the parity blocks can be marked unused too.
>
> MfG
> =A0 =A0 =A0 =A0Goswin
>



--=20
Regards,
Sandeep.





 =09
=93To learn is to change. Education is a process that changes the learn=
er.=94
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
