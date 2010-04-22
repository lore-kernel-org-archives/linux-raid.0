From: Neil Brown <neilb@suse.de>
Subject: Re: reshape from raid5 to raid6 failed -- and backup file is gone?
Date: Fri, 23 Apr 2010 08:37:01 +1000
Message-ID: <20100423083701.5fa5da72@notabene.brown>
References: <n2j657cbef51004221132uf2d7f5cds1268f848fee1489e@mail.gmail.com>
	<q2u657cbef51004221446l41381e31hf26f96072b04983e@mail.gmail.com>
	<20100423080938.5ef90287@notabene.brown>
	<l2k657cbef51004221526hcb002ac9pd8e464f50c5b1a70@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <l2k657cbef51004221526hcb002ac9pd8e464f50c5b1a70@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Rich Rauenzahn <rrauenza@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 22 Apr 2010 15:26:13 -0700
Rich Rauenzahn <rrauenza@gmail.com> wrote:

> >
> >
> > It is very odd that the backup file disappeared. =C2=A0What is
> > =C2=A0 /.MEDIA/tmp
> > ?? Not a tmpfs filesystem I hope...
>=20
> No, a persistent filesystem on another disk -- with no autodelete
> scripts or anything.  Very very weird that it disappeared.   I saw it
> before I went to bed... was about 50MB if I recall.  Unless the fsck
> at boot removed it -- but I would imagine you make sure you fsync tha=
t
> file to disk before you proceed?   I think ./.MEDIA is ext4.
>=20

I don't fsync the directory containing the file, but I do fsync the fil=
e
quite regularly.
But if the system ran for even just one minute after the --grow started=
 the
directory would have been flushed to disk so the absence of an fsync on=
 the
directory cannot have been a problem... not that I'm convinced it could=
 be a
problem anyway.


> > You could hack mdadm to assemble the array even without a backup fi=
le.
> > Get 'Grow_restart' to always return 0.
> >
> > Then most of your data should be assessible, but the could be a sec=
tion in
> > the middle which is currupt.
>=20
> As long as fsck can bring it back to a consistent state, I'm ok with
> that.   But I would guess some file contents could be silently
> corrupt?

Yes, there could be silent corruption.  Or there might be no corruption=
=2E
If the backup file was about 50MB (which seems likely) then the total a=
mount
of corruption should not exceed 50MB - though in an indexing block was =
lost
you could loose more than 50MB of a single file..

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
