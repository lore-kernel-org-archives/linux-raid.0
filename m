From: Wilson Jonathan <piercing_male@hotmail.com>
Subject: Re: writing zeros to bad sector results in persistent read error
Date: Tue, 10 Jun 2014 07:52:30 +0100
Message-ID: <BLU436-SMTP219AA7248E603D2B8669A1F98280@phx.gbl>
References: <B7EA34DA-1064-45B1-B0C0-B7C423C7EB47@colorremedies.com>
	 <20140607075140.277c0880@natsu>
	 <0E76B97E-96DF-43A3-B8EC-4867964BF8E9@colorremedies.com>
	 <BLU436-SMTP1535675BF98253D9B967F17982E0@phx.gbl>
	 <BBD6BB5F-9D33-413B-AD74-3DC3EA34D6AB@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BBD6BB5F-9D33-413B-AD74-3DC3EA34D6AB@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 2014-06-09 at 18:09 -0600, Chris Murphy wrote:
> On Jun 8, 2014, at 2:10 AM, Wilson Jonathan <piercing_male@hotmail.co=
m> wrote:
>=20
> > On Sat, 2014-06-07 at 18:52 -0600, Chris Murphy wrote:
> >> I wrote:
> >>> How can there still be pending bad sectors, and yet no error and =
LBA reported?
> >>=20
> >> So I started another -t long test. And it comes up with an LBA not=
 previously reported.
> >>=20
> >> # 1  Extended offline    Completed: read failure       60%      12=
14         430234064
> >>=20
> >> # dd if=3D/dev/zero of=3D/dev/sda seek=3D430234064 count=3D8
> >> dd: writing to =E2=80=98/dev/sda=E2=80=99: Input/output error
> >> 1+0 records in
> >> 0+0 records out
> >> 0 bytes (0 B) copied, 3.63342 s, 0.0 kB/s
> >>=20
> >> On this sector the technique fails.
> >>=20
> >> # dd if=3D/dev/zero of=3D/dev/sda seek=3D430234064 count=3D8 oflag=
=3Ddirect
> >> 8+0 records in
> >> 8+0 records out
> >> 4096 bytes (4.1 kB) copied, 3.73824 s, 1.1 kB/s
> >=20
> > I may be missing something here, but surely after all this faffing =
about
> > and errors isn't it about time to replicate the data to a new drive=
 and
> > then hit this one repeatedly with a very large hammer.
> >=20
> > The law of diminishing returns must surely be coming into play by n=
ow.
>=20
> No the question here isn't what's the right course of action from thi=
s point. This is an academic question: whether the reported behavior(s)=
 are as designed.
>=20
> From an enterprise perspective, my understanding is even one bad sect=
or is disqualifying and the drive goes back to the manufacturer if it's=
 under warranty; or otherwise demoted for less important use if it's no=
t.
>=20
> For consumer drives, which this is, all the manufacturers will say th=
e drive is functioning as designed with bad sectors *if* they're being =
reallocated. Maybe some of them won't quibble and will send a replaceme=
nt drive anyway.
>=20
> But what I'm reporting is an instance where an ATA Secure Erase defin=
itely did not fix up a single one of the bad sectors. Maybe that's cons=
istent with the spec, I don't know, but it's not what I'd expect seeing=
 as every sector, those with an without LBA's assigned, are overwritten=
=2E Yet pending sectors were not remapped. Further, with all sectors ov=
erwritten by software (not merely the ATA Secure Erase command) yields =
no errors yet SMART reports there are still pending sectors, yet it's o=
wn extended test says there are none. I think that's bad behavior. But =
perhaps I don't understand the design and it's actually working as desi=
gned.
>=20

Thanks for the clarification over this being an academic question rathe=
r
than a live, real world disk is playing up, what should I do type
question.

Your mention of the secure erase not, or seemingly not, re-mapping does
raise an important question. If it does indeed remap, due to data
change, but does not change the count then its an oddity, however if
secure erase fails to remap and does not change the data at all then
there is the potential for live data to be recoverable (although it
would be a small amount) in some form, perhaps by directly driving the
disk (as apposed to os control) or even moving the platters to another
disk case or some other method dependent on the time and effort involve=
d
being worth it.=20

>=20
> Chris Murphy


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
