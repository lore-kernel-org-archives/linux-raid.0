From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: reconf raid
Date: Thu, 20 May 2004 21:09:50 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16556.37374.166298.3940@cse.unsw.edu.au>
References: <1085044407.16167.5.camel@freya>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Magnus  =?ISO-8859-1?Q?=20M=E5nsson?= on Thursday May 20
To: Magnus =?ISO-8859-1?Q?M=E5nsson?= <ganja@0x63.nu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday May 20, ganja@0x63.nu wrote:
> Hello, I have just joined this list and made some reading.
> What I am looking for is a way to add new hard drives to my raid5 mad=
e
> with mdadm. If have got it right it's not supported, and it's taking
> some time though people wants to do it in the kernel and not the way
> raidtools-reconf does it, fully understandable (even though I would l=
ike
> to do it offline).

You can use raidreconfig (or whatever it is called) from raidtools to
reconfigure an array built with mdadm.  The arrays built by mdadm are
just the same as those built by mkraid - it is just a different tool
with a different interface.

>=20
> So my question is, is there any timeplan for this functionallity? Can=
 I
> expect to be able to resize my raid5 before winter?

There is no timeplan for anything.  It gets done when it gets done,
depending entirely on who is motivated, how much, how clever they are,
how busy they are, and things like that.


NeilBrown

>=20
> My idea was to build a lot of raid5 (like 5 of them) to match that my
> hard drives have different sizes, and after that use lvm to get one b=
ig
> partition that I can add new drives to and just enlarge.
>=20
> This leads to that I also have to be able to convert raid1 to raid5, =
if
> I do not want to move the data on that little part to a temporary dis=
k,
> that would be possible today, it would be only 70G to move around.
>=20
> --=20
> Magnus M=E5nsson <ganja@0x63.nu>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
