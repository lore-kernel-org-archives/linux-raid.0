From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: Considering a complete rework of RAID on my home compute server
Date: Thu, 6 Jan 2011 00:05:31 -0200
Message-ID: <AANLkTikb=bNr3iDj36Bz3zRd9RhfSZLQ40d3AFy4Up7E@mail.gmail.com>
References: <AANLkTinsQoPVaYVe4H9kMK7_-GFzHoKt_Zdf4nUKc+C2@mail.gmail.com>
	<87.68.02631.5E6052D4@cdptpa-omtalb.mail.rr.com>
	<20110106054754.44e7fe1a@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110106054754.44e7fe1a@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

could we implement a more flexible raid1? maybe with checksum? wrong
checksum =3D page failed or page with errors
page should be correct for a high performace
example,
mirror 1 =3D 4096 page size
mirror 2 =3D 8192 page size
mirror 3 =3D 512 page size

a good value for raid page size is 8192 (is multiple of 4096 and 512)
the checksum size shoud be multiple of page size
for example 1byte for each 512bytes, with a page of 8192bytes, we have
8192 pages checksum with only one page...

what's the `new` raid1 with checksum idea?
considering 8192 page size, with 3 mirrors...
the error is detect by page, not by mirror
pages make filesystem fast (ok, a little less than without raid)
low disk use for checksum

what we need...
example:
a raid with 8192001bytes
page size=3D8192   <- give at mdadm --create
checksum size per page =3D crc32? 4 bytes  <- give at mdadm --create ??=
?
total pages =3D  floor(size/page size) =3D floor(8.192.001/8192) =3D 10=
00
(~1000,000122, we will lose 1 byte...)
checksums per page size =3D floor(page size / checksum size) =3D
floor(8192/4) =3D 2048
total checksum pages =3D ceil(total pages / checksums per page size) =3D
ceil(1000 / 2048) =3D 1 (0,48828125 we will have a lot of checksum
without use)
total data pages =3D total pages - check sum pages =3D 1000 - 1 =3D 999
total size for filesystem =3D total data pages * page size =3D 999 * 81=
92
=3D 8.183.808 bytes

should we usa more information? what about what's the newest drive?
for example, we remove disk1 and disk2,3 are online, so write to 2,3
will make 1 older... should we use disk last write time information?
maybe a page just for information? this could help us for check what's
the currently working disk, checksum should be included with this
value, for example 4096 bytes + this page value? or a page for
checksum and a page for last write time value? the idea is help to
know what's the newest value, a page startup could allow us to sync
pages on each disk

ideas:
*it does not do 'voting' on RAID1 with more than 2 devices
this could be done with per page last write time (raid 5 or raid6?)
*obviously it does not have per-block checksums anywhere
a per block checksum (raid 5 or raid6?)


got? any idea?
for example, imagine that we have ten 1TB  disks and we want a 1TB
'raid'  disk, the best option is RAID1 today, a mirror on every disk,
and a read speed very fast (if we could select right read algorithm,
for example closest head position, fastest read time, round robin,
page module per mirrors on raid (for example, 10 disks, a read at page
1, will read for disk 1, a read from page 12 will read from disk 2,
page 23, 3, 13, 43, will read from disk 3,  'page number' mod 'mirrors
on raid' =3D disk to read)


a fast resume, reading about openbsd we could get:

write algorithm (what disk should be write? raid 0 with strip for examp=
le)
read algorithm (what disk should be read? raid1 with good disks, could
read with closest head position, fastest read time, round robin,
etc...)
strip algorithm (raid0, raid0 with strip)
mirror algorithm (raid1)
checksum algorithm (none =3D raid1, crc disk ~ raid 5/6, crc page per
mirror =3D raid1 with checksum)
correction algorithm (?? any idea)
sync algorithm (per page / per disk ??)
start disk algorithm (per page? per disk? last write time? incremental
write number?)
checksum/correction location (at each disk more secure, or, at
external disk / file less secure)

a mdadm with all this options could make a very flexible raid
solution... i don't believe that we could have a more flexible than
this, any idea??
we have a lot of work done today... just remap it, ok we have more
thinks to do... anyone want a new project? md2? like v4l2?



2011/1/5 Roman Mamedov <rm@romanrm.ru>:
> On Wed, 5 Jan 2011 18:03:47 -0600
> "Leslie Rhorer" <lrhorer@satx.rr.com> wrote:
>
>> =A0 =A0 =A0 RAID1 certainly offers the most robust solution, especia=
lly
>> with more than 1 mirror.
>
>> =A0 =A0 =A0 RAID1 is as safe as it gets
>
> Are you sure about that? Considering that mdadm's handling of corrupt=
 data on
> RAID1 devices is pretty simplistic (obviously it does not have per-bl=
ock
> checksums anywhere, it does not do 'voting' on RAID1 with more than 2
> devices), it basically has no way of knowing if a block of data is re=
turned
> differently by some of the component devices, which one has the 'corr=
ect'
> data. From what I understand, RAID5 and especially RAID6 give a much =
better
> protection in this situation.
>
>
>
> --
> With respect,
> Roman
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
