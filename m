From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: What's the typical RAID10 setup?
Date: Thu, 3 Feb 2011 16:43:05 +0100
Message-ID: <20110203154305.GA27356@www2.open-std.org>
References: <AANLkTi=kUGc8bjisn69BEEkZr6kcHUyfKnVZzNtgaJf3@mail.gmail.com> <20110131225235.GA11775@www2.open-std.org> <ii8lcv$3jg$1@dough.gmane.org> <AANLkTin1MPYZGMuL75c=_q+ndeiz0F5+eCRudpDdTwu9@mail.gmail.com> <ii96gl$vrl$1@dough.gmane.org> <AANLkTim3UgP0jtM6E_-3o-_OuNw6j1JG8OZzcvxt8A8s@mail.gmail.com> <AANLkTikehWC6-wzWE26p0n7Ng1YW6Sv_L1xU_K4LZdkv@mail.gmail.com> <AANLkTikerSZfhMbkEvGBVyLB=wHDSHLWszoEz5As5Hi4@mail.gmail.com> <AANLkTikLyR206x4aMy+veNkWPV67uF9r5dZKGqXJUEqN@mail.gmail.com> <AANLkTikzNHJFDfXbQEduu3=OwoaSwVp+p186K5rW1AXH@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTikzNHJFDfXbQEduu3=OwoaSwVp+p186K5rW1AXH@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Drew <drew.kay@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Feb 03, 2011 at 12:35:52PM -0200, Roberto Spadim wrote:
> =3D] i think that we can end discussion and conclude that context (te=
st
> / production) allow or don't allow lucky on probability, what's lucky=
?
> for production, lucky =3D poor disk, for production we don't allow
> failed disks, we have smart to predict, and when a disk fail we chang=
e
> many disks to prevent another disk fail
>=20
> could we update our raid wiki with some informations about this discu=
ssion?

I would like to, but it is a bit complicated.
Anyway I think there already is something there on the wiki.
And then, for one of the most important raid types in Linux MD,
namely raid10, I am not sure what to write. It could be raid1+0, or
raid0+1 like, and as far as I kow, it is raid0+1 for F2:-(
but I don't know for n2 and o2.

The German version on raid at wikipedia has a lot of info on probabilit=
y
http://de.wikipedia.org/wiki/RAID - but it is wrong a number of places.
I have tried to correct it, but the German version is moderated, and
they don't know what they are writing about.
http://de.wikipedia.org/wiki/RAID

Best regards
Keld

> 2011/2/3 Drew <drew.kay@gmail.com>:
> >> for test, raid1 and after raid0 have better probability to don't s=
top
> >> raid10, but it's a probability... don't believe in lucky, since it=
's
> >> just for test, not production, it doesn't matter...
> >>
> >> what i whould implement? for production? anyone, if a disk fail, a=
ll
> >> array should be replaced (if without money replace disk with small
> >> life)
> >
> > A lot of this discussion about failure rates and probabilities is
> > academic. There are assumptions about each disk having it's own
> > independent failure probability, which if that can not be predicted
> > must be assumed to be 50%. =A0At the end of the day I agree that wh=
en
> > the first disk fails the RAID is degraded and one *must* take steps=
 to
> > remedy that. This discussion is more about why RAID 10 (1+0) is bet=
ter
> > then 0+1.
> >
> > On our production systems we work with our vendor to ensure the
> > individual drives we get aren't from the same batch/production run,
> > thereby mitigating some issues around flaws in specific batches. We
> > keep spare drives on hand for all three RAID arrays, so as to minim=
ize
> > the time we're operating in a degraded state. All data on RAID arra=
ys
> > is backed up nightly to storage which is then mirrored off-site.
> >
> > At the end of the day our decision around what RAID type (10/5/6) t=
o
> > use was based on a balance between performance, safety, & capacity
> > then on specific failure criteria. RAID 10 backs the iSCSI LUN that
> > our VMware cluster uses for the individual OSes, and the data
> > partition for the accounting database server. RAID 5 backs the
> > partitions we store user data one. And RAID 6 backs the NASes we us=
e
> > for our backup system.
> >
> > RAID 10 was chosen for performance reasons. It doesn't have to
> > calculate parity on every write so for the OS & database, which do =
a
> > lot of small reads & writes, it's faster. For user disks we went wi=
th
> > RAID 5 because we get more space in the array at a small performanc=
e
> > penalty, which is fine as the users have to access the file server
> > over the LAN and the bottle neck is the pipe between the switch & t=
he
> > VM, not between the iSCSI SAN & the server. For backups we went wit=
h
> > RAID 6 because the performance & storage penalties for the array we=
re
> > outweighed by the need for maximum safety.
> >
> >
> >
> > --
> > Drew
> >
> > "Nothing in life is to be feared. It is only to be understood."
> > --Marie Curie
> >
> >
>=20
>=20
>=20
> --=20
> Roberto Spadim
> Spadim Technology / SPAEmpresarial
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
