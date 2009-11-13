From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: Known-good LSI PCIe SAS HBAs?
Date: Fri, 13 Nov 2009 11:59:26 -0700
Message-ID: <200911131159.26236.tfjellstrom@shaw.ca>
References: <73e903670911100854o1b48380apb5b0a86c44ae9dcb@mail.gmail.com> <200911111151.09021.tfjellstrom@shaw.ca> <73e903670911131003i26f25b01xb6671684419d5c51@mail.gmail.com>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <73e903670911131003i26f25b01xb6671684419d5c51@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kristleifur =?iso-8859-1?q?Da=F0ason?= <kristleifur@gmail.com>
Cc: Richard Scobie <richard@sauce.co.nz>, linux-raid@vger.kernel.org, andy yan <andyysj@gmail.com>
List-Id: linux-raid.ids

On Fri November 13 2009, Kristleifur Da=F0ason wrote:
> On Wed, Nov 11, 2009 at 6:51 PM, Thomas Fjellstrom <tfjellstrom@shaw.=
ca>=20
wrote:
> > On Wed November 11 2009, Richard Scobie wrote:
> > > Thomas Fjellstrom wrote:
> > > > Thats the problem he was trying to get away from. the MV8
> > > > controller likes to offline disks when a few smart commands arr=
ive.
> > > > at least with the main kernel drivers. But then the main kernel
> > > > mvsas drivers decide to give up if you even attempt to start a =
raid
> > > > array on them. The controller locks up and you have to reboot. =
Most
> > > > of the time a reboot even fails when it tries to sync the block
> > > > devices, so a hard reset is in order.
> > >
> > > OK, I did not know the Marvell controller also has a problem with
> > > smartmontools.
> >
> > Given the state of the in kernel drivers, its probably a driver iss=
ue.
>=20
> Thanks for the replies, all.
>=20
> I'll bet it's the driver - it doesn't feel quite right that a random
> external command can easily drop drives off the controller, be it
> smartmontools or mdadm.
>=20
> Thomas, I tried sending a private email to Andy Yan. I haven't got a
> reply, which kind of isn't surprising in this world of spam. Can I as=
k
> you for a referral - could you send him an email asking him if I can
> have the patch and how to test it?

He seems to be a busy guy, but I've CCed him on this. The actual driver=
 I=20
got is a full copy of the driver, builds out of tree.

He hasn't said I can't send the package to anyone, but I'll wait a litt=
le=20
while before doing so, he might pop up saying not to give it out.

All I can say is: it works well enough for me*.

=46or a $120 8 port sata card, it really does the trick. I was so glad =
when I=20
didn't have to get several crappy 2-4 port jmicron cards.

> Also, to list-dwellers: I'd greatly appreciate further tips on PCIe S=
AS
>  HBAs.
>=20
> Thanks!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

* Performance (to me) is outstanding, or at least it will be once the w=
rite=20
back stuff is fixed up, and the io controller stuff is also fixed up, b=
ut as=20
is right now in 2.6.31, its "good enough". Might not get the absolute i=
nsane=20
400-500MB/s I saw with the controller originally, but I do get a good=20
100-230MB/s off my 5 drive md raid5 array (512KB chunk). I find things =
that=20
used to take 30 seconds or more on my old array now happen in a few sec=
onds.=20
Right now writes are rather bad (60-100MB/s) but that I assume is the w=
rite=20
back stuff, which should hopefully be fixed in 32.

--=20
Thomas Fjellstrom
tfjellstrom@shaw.ca
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
