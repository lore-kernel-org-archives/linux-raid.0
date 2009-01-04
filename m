From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: RFC: detection of silent corruption via ATA long sector reads
Date: Sun, 04 Jan 2009 12:31:17 +0000
Message-ID: <4960AC15.8030207@anonymous.org.uk>
References: <fa.8mwKV7y4hm+Q6mvIKtp9QGoJYUU@ifi.uio.no>	<fa.4QcsYZC0gJJwJ0eUOht3hDYaVWs@ifi.uio.no>	<49580061.9060506@yahoo.com>	<87f94c370901021226j40176872h9e5723c6da4afcbe@mail.gmail.com>	<yq13ag174af.fsf@sermon.lab.mkp.net>	<495F6622.9010103@anonymous.org.uk> <yq1eizj5xos.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq1eizj5xos.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/01/2009 07:37, Martin K. Petersen wrote:
>>>>>> "John" =3D=3D John Robinson <john.robinson@anonymous.org.uk> wri=
tes:
>=20
> John> Excuse me if I'm being dense - and indeed tell me! - but RAID
> John> 4/5/6 already suffer from having to do ready-modify-write for
> John> small writes, so is there any chance this could be done at
> John> relatively little additional expense for these?
>=20
> You'd still need to store a checksum somewhere else, incurring
> additional seek cost.  You could attempt to weasel out of that by add=
ing
> the checksum sector after a limited number of blocks and hope that yo=
u'd
> be able to pull it in or write it out in one sweep.
>=20
> The downside is that assume we do checksums on - say - 8KB chunks in =
the
> RAID5 case.  We only need to store a few handfuls of bytes of checksu=
m
> goo per block.  But we can't address less than a 512 byte sector.  So=
 we
> need to either waste the bulk of 1 sector for every 16 to increase th=
e
> likelihood of adjacent access.  Or we can push the checksum sector
> further out to fill it completely.  That wastes less space but has a
> higher chance of causing an extra seek.  Pick your poison.

Well, I was assuming that MD/DM operates in chunk size amounts (e.g. 32=
K=20
or 64 sectors) anyway, and having a sector or two of checksums on disc=20
immediately following each chunk would be a pretty small cost,=20
increasing each read or write cycle only marginally (e.g. to 65=20
sectors), which shouldn't cause much drop in performance (I guess 1/64t=
h=20
in throughput and IOPS, if the discs themselves are the bottleneck).=20
Essentially DIF on 32k blocks instead of 512 byte ones. But perhaps thi=
s=20
is a bad assumption and MD/DM already optimises out whole-chunk reads=20
and writes where they're not required (for very short,=20
less-than-one-chunk transactions), and I've no idea whether this happen=
s=20
a lot.

> The reason I'm advocating checksumming on logical (filesystem) blocks=
 is
> that the filesystems have a much better idea what's good and what's b=
ad
> in a recovery situation.  And the filesystems already have an
> infrastructure for storing metadata like checksums.  The cost of
> accessing that metadata is inherent and inevitable.

Yes, I can see that. But the old premise that RAID tried to maintain wa=
s=20
that disc sectors don't go bad. You're quite reasonably dropping the=20
premise rather than trying to do more to maintain it. There might be=20
validity to both approaches.

> We also don't want to do checksumming at every layer.  That's going t=
o
> suck from a performance perspective.  It's better to do checksumming
> high up in the stack and only do it once.  As long as we give the upp=
er
> layers the option of re-driving the I/O.
>=20
> That involves adding a cookie to each bio that gets filled out by DM/=
MD
> on completion.  If the filesystem checksum fails we can resubmit the =
I/O
> and pass along the cookie indicating that we want a different copy th=
an
> the one the cookie represents.

I'd like to understand this mechanism better; at first glance it's=20
either going to be too simplistic and not cover the various block layer=
=20
cases well, or it means you end up re-implementing RAID and LVM in the=20
filesystem.

Just my =E2=82=AC$=C2=A30.02 of course.

Cheers,

John.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
