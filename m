From: Neil Brown <neilb@suse.de>
Subject: Re: 5 drives lost in an inactive 15 drive raid 6 system due to
 cable problem - how to recover?
Date: Sat, 11 Sep 2010 07:24:46 +1000
Message-ID: <20100911072446.50833b79@notabene>
References: <4C87C656.2030405@stern.nyu.edu>
	<20100909073530.1e5da34d@notabene>
	<AANLkTiknvajTtJuCBO927tGcNLB+4R+pXev68snrU4kr@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTiknvajTtJuCBO927tGcNLB+4R+pXev68snrU4kr@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: Norman White <nwhite@stern.nyu.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 10 Sep 2010 23:39:08 +0400
CoolCold <coolthecold@gmail.com> wrote:

> Neil can you share that decision making algorithm ?

Nothing special really.  I just confirmed that the metadata contents ag=
reed
with what Norman said had happened.  Sometime people do other things to
arrays first and don't realise the consequences and don't report them. =
 So if
I based my "just use --force, that should work" on what they tell me I =
am
sometimes wrong - because what they tell me is flawed.  So I am not mor=
e
cautious and try to only base it on what mdadm tells me.

And I didn't really need to see the mdadm output.  As I said before
mdadm -Af should either do the right thing or nothing.  But I know peop=
le can
be very protective of there multi-gigabyte data sets so if I can be a b=
it
more definite, it helps them.

Also, I like to see want mdadm -E output from odd failures as it might =
show
me something that needs fixing.  Largely as a consequence of watching h=
ow
people interact with their failed arrays, the next release of mdadm wil=
l be a
lot more cautious about letting you add a device to an array - particul=
arly a
failed array.  People often seem to do this thinking it means 'add this=
 back
in', but really it means 'make this a spare and attach it to the array'=
=2E

In this particular case, I checked that what each device thought of its=
 own
role in the array was compatible with with what the newest device thoug=
ht,
where 'compatible' means either they agreed, or the newer reported a cl=
ean
failure.  If any device thought it was a spare and shouldn't have done,=
 or
two devices both thought they filled the same roles, that would have be=
en a
concern.

NeilBrown



> We have servers with "lucky" aic9410 & LSI 1068E controllers which
> hang system sometimes, then drive(s) are dropped.
> In simple cases, when one drive has different Events count it's enoug=
h
> to force assemble, but in other cases when, say 8 drives are dropped
> like in Kyler's case (
> http://marc.info/?l=3Dlinux-raid&m=3D127534131202696&w=3D2 ) and exam=
ine
> shows different info for drives from the same array, ie
> http://lairds.us/temp/ucmeng_md/20100526/examine_sdj1 ,
> http://lairds.us/temp/ucmeng_md/20100526/examine_sda1 . Keeping in
> mind that drives can be exported in different order on every boot,
> it's not so straightforward to detect "right" options.
>=20
> I promise to put that knowledge on wiki.
>=20
> On Thu, Sep 9, 2010 at 1:35 AM, Neil Brown <neilb@suse.de> wrote:
> > On Wed, 08 Sep 2010 13:22:30 -0400
> > Norman White <nwhite@stern.nyu.edu> wrote:
> >
> >> We have a 15 drive addonics array with 3 5 port sata multiplexors,=
 one
> >> of the sas cables was knocked out to one of the port multiplexors =
and now
> >> mdadm sees 9 drives , a spare, and 5 failed, removed drives (after
> >> fixing the cabling problem).
> >>
> >> A mdadm -E on each of the drives, see 5 drives (the ones that were
> >> uncabled) as seeing the original =C2=A0configuration with 14 drive=
s and a
> >> spare, while the other 10 drives report
> >> 9 drives, a spare and 5 failed , removed drives.
> >>
> >> We are very confident that there was no io going on at the time, b=
ut are
> >> not sure how to proceed.
> >>
> >> One obvious thing to do is to just do a:
> >>
> >> mdadm --assemble --force --assume-clean /dev/md0 sd[b,c, ... , p]
> >> but we are getting different advice about what force will do in th=
is
> >> situation. The last thing we want to do is wipe the array.
> >
> > What sort of different advice? =C2=A0From whom?
> >
> > This should either do exactly what you want, or nothing at all. =C2=
=A0I suspect
> > the former. =C2=A0To be more confident I would need to see the outp=
ut of
> > =C2=A0 mdadm -E /dev/sd[b-p]
> >
> > NeilBrown
> >
> >
> >>
> >> Another option would be to fiddle with the super blocks with mddum=
p, so
> >> that they all see the same 15 drives in the same configuration, an=
d then
> >> assemble it.
> >>
> >> Yet another suggestion was to recreate the array configuration and=
 hope
> >> that the data wouldn't be touched.
> >>
> >> And even another suggestion is to create the array with one drive
> >> missing (so it is degraded and won't rebuild)
> >>
> >> Any pointers on how to proceed would be helpful. Restoring 30TB ta=
kes
> >> along time.
> >>
> >> Best,
> >> Norman White
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-ra=
id" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info=
=2Ehtml
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
> >
>=20
>=20
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
