From: Redeeman <redeeman@metanurb.dk>
Subject: Re: detection/correction of corruption with raid6
Date: Fri, 12 Dec 2008 16:31:24 +0100
Message-ID: <1229095884.16555.144.camel@localhost>
References: <1228510833.16555.76.camel@localhost>
	 <alpine.DEB.1.10.0812051602110.17806@p34.internal.lan>
	 <1228511195.16555.78.camel@localhost>
	 <alpine.DEB.1.10.0812051607100.17806@p34.internal.lan>
	 <1228511558.16555.84.camel@localhost>
	 <6c4602af0812051330o4220cbf1g8b969cd4b9843d3a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6c4602af0812051330o4220cbf1g8b969cd4b9843d3a@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?iso-8859-2?Q?Micha=B3_Przy=B3uski?= <mikylie@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2008-12-05 at 22:30 +0100, Micha=B3 Przy=B3uski wrote:
> Hi,
>=20
> 2008/12/5 Redeeman <redeeman@metanurb.dk>:
> > On Fri, 2008-12-05 at 16:09 -0500, Justin Piszcz wrote:
> >>
> >> On Fri, 5 Dec 2008, Redeeman wrote:
> >>
> >> > On Fri, 2008-12-05 at 16:02 -0500, Justin Piszcz wrote:
> >> >>
> >> >> On Fri, 5 Dec 2008, Redeeman wrote:
> >> >>
> >> >>> Hello.
> >> >>>
> >> >>> I was looking at the PDFs linked to from the wiki, and found t=
his:
> >> >>> http://kernel.org/pub/linux/kernel/people/hpa/raid6.pdf
> >> >>>
> >> >>> More specifically, section 4, starting on page 8.
> >> >>>
> >> >>> Am I understanding this correctly, in that with raid6, linux i=
s capable
> >> >>> of detecting if the content on 1 disk is corrupted, and recons=
truct it
> >> >>> from the remaining disks?
> >> >>
> >> >> I ran md/raid6 for awhile, do you mean remap the bad sector on =
the fly?
> >> >> Linux/md raid does not do this afaik.
> >> >
> >> > No, i mean, if one disk does silent corruption
> >>
> >> What would the error look like?  Both md/Linux & in the 3ware manu=
al
> >> recommend you run a 'check' across the raid at least once a week
> >> (3ware/raid-verify) and md/Linux in Debian runs a check once a mon=
th I
> >> believe to eliminate these issues.
> >>
> >> If you are asking whether a read error of a latent sector from the=
 one
> >> disk will result it reading the data from the second disk that is =
a good
> >> question.
> >
> > im asking, if one disk in a raid6 setup suddenly decides to flip a =
few
> > bits in some bytes, will it be able to detect that in a scan, and
> > correct it? i cant see how it can do it on raid5, but maybe raid6?
>=20
> No, not really.
> I've been investigating silent corruption for a quite a while now, an=
d
> it looks more or less like this.
> During a "check" action it'll be detected. During normal operation -
> it won't be detected.
> Normal (non-degraded) raid5/6 reads don't read parity (or Q syndrome)=
,
> they just read data. So they have no idea that something went bad.
> Now, worse news is that you cannot really fix it automagically, even
> after detecting by a "check" procedure. A "repair" will overwrite
> parity and Q syndrome, with new values (new =3D calculated from what =
it
> seems to be data blocks).
>=20
> It is possible (by the theory of Q syndrome, per the article you
> linked) to detect which drive is doing a silent corruption with raid6
> (and with some extra assumption, that just one drive is doing that).
> But it's not implemented.

thats a shame, it seems like a KILLER feature, but i guess its not too
simple to do, or it would have been done already :)

>=20
> Greets,
> Mike
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
