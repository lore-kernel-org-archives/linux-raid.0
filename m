From: Drew <drew.kay@gmail.com>
Subject: Re: raid-0 with mdadm vs lvm striping
Date: Wed, 12 Aug 2009 10:47:30 -0700
Message-ID: <c268e4660908121047i52659b9aqb4e31478592538d9@mail.gmail.com>
References: <3ECBDC05781B3D48ABD520A01ABF2F9B2E99EDBB63@SE-EX008.groupinfra.com>
	<c268e4660908111435x81d080fva423c5ea78605fc2@mail.gmail.com>
	<3ECBDC05781B3D48ABD520A01ABF2F9B2E9A0485D5@SE-EX008.groupinfra.com>
	<87vdkt4e5x.fsf@frosties.localdomain> <3ECBDC05781B3D48ABD520A01ABF2F9B2E9A048A82@SE-EX008.groupinfra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3ECBDC05781B3D48ABD520A01ABF2F9B2E9A048A82@SE-EX008.groupinfra.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Henry, Andrew" <andrew.henry@logica.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> That's what my question was: =C2=A0Will raid0 (striping) be faster or=
 easier to manage than lvm striping

I don't know about faster but IMO it'll be easier with raid0. With LVM
you have to specify striping *every* time you create a new LV. With an
underlying raid0 array as the sole physical volume, you can create the
LV knowing it's striped.

One less switch to forget.


--=20
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
