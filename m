From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: md road-map: 2011
Date: Thu, 17 Feb 2011 11:58:15 +0100
Message-ID: <20110217105815.GA24580@www2.open-std.org>
References: <20110216212751.51a294aa@notabene.brown> <ijgr9p$7v8$1@dough.gmane.org> <20110217083531.3090a348@notabene.brown> <ijhje3$ocd$1@dough.gmane.org> <20110217100139.7520893d@notabene.brown> <ijhq7p$pjv$1@dough.gmane.org> <20110217010455.GA16324@www2.open-std.org> <ijiu99$ill$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ijiu99$ill$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Feb 17, 2011 at 11:45:35AM +0100, David Brown wrote:
> On 17/02/2011 02:04, Keld J=F8rn Simonsen wrote:
> >On Thu, Feb 17, 2011 at 01:30:49AM +0100, David Brown wrote:
> >>On 17/02/11 00:01, NeilBrown wrote:
> >>>On Wed, 16 Feb 2011 23:34:43 +0100 David Brown<david.brown@hesbyne=
tt.no>
> >>>wrote:
> >>>
> >>>>I thought there was some mechanism for block devices to report ba=
d
> >>>>blocks back to the file system, and that file systems tracked bad=
 block
> >>>>lists.  Modern drives automatically relocate bad blocks (at least=
, they
> >>>>do if they can), but there was a time when they did not and it wa=
s up to
> >>>>the file system to track these.  Whether that still applies to mo=
dern
> >>>>file systems, I do not know - they only file system I have studie=
d in
> >>>>low-level detail is FAT16.
> >>>
> >>>When the block device reports an error the filesystem can certainl=
y=20
> >>>record
> >>>that information in a bad-block list, and possibly does.
> >>>
> >>>However I thought you were suggesting a situation where the block =
device
> >>>could succeed with the request, but knew that area of the device w=
as of=20
> >>>low
> >>>quality.
> >>
> >>I guess that is what I was trying to suggest, though not very clear=
ly.
> >>
> >>>e.g. IO to a block on a stripe which had one 'bad block'.  The IO =
should
> >>>succeed, but the data isn't as safe as elsewhere.  It would be nic=
e if we
> >>>could tell the filesystem that fact, and if it could make use of i=
t. But=20
> >>>we
> >>>currently cannot.   We can say "success" or "failure", but we cann=
ot say
> >>>"success, but you might not be so lucky next time".
> >>>
> >>
> >>Do filesystems re-try reads when there is a failure?  Could you ret=
urn
> >>fail on one read, then success on a re-read, which could be interpr=
eted
> >>as "dying, but not yet dead" by the file system?
> >
> >This should not be a file system feature. The file system is built u=
pon
> >the raid, and in mirrorred raid types like raid1 and raid10, and als=
o
> >other raid types, you cannot be sure which specific drive and sector=
 the
> >data was read from - it could be one out of many (typically two) pla=
ces.
> >So the bad blocks of a raid is a feature of the raid and its individ=
ual
> >drives, not the file system. If it was a property of the file system=
,
> >then the fs should be aware of the underlying raid topology, and kno=
w if
> >this was a parity block or data block of raid5 or raid6, or which
> >mirror instance of a raid1/10 type which  was involved.
> >
>=20
> Thanks for the explanation.
>=20
> I guess my worry is that if md layer has tracked a bad block on a dis=
k,=20
> then that stripe will be in a degraded mode.  It's great that it will=
=20
> still work, and it's great that the bad block list means that it is=20
> /only/ that stripe that is degraded - not the whole raid.

I am proposing that the stripe not be degraded, using a recovery area f=
or bad
blocks on the disk, that goes together with the metadata area.

> But I'm hoping there can be some sort of relocation somewhere=20
> (ultimately it doesn't matter if it is handled by the file system, or=
 by=20
> md for the whole stripe, or by md for just that disk block, or by the=
=20
> disk itself), so that you can get raid protection again for that stri=
pe.

I think we agree in hoping:-)

best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
