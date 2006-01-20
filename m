From: Heinz Mauelshagen <mauelshagen@redhat.com>
Subject: Re: [PATCH 000 of 5] md: Introduction
Date: Fri, 20 Jan 2006 19:38:40 +0100
Message-ID: <20060120183840.GB2799@redhat.com>
References: <26A66BC731DAB741837AF6B2E29C1017D47EA0@xmb-hkg-413.apac.cisco.com> <Pine.LNX.4.61.0601181427090.19392@yvahk01.tjqt.qr> <17358.52476.290687.858954@cse.unsw.edu.au> <43D00FFA.1040401@cfl.rr.com> <17360.5011.975665.371008@cse.unsw.edu.au> <43D02033.4070008@cfl.rr.com> <17360.9233.215291.380922@cse.unsw.edu.au> <43D04828.8010107@cfl.rr.com> <20060120105306.GY22163@marowsky-bree.de>
Reply-To: mauelshagen@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060120105306.GY22163@marowsky-bree.de>
Sender: linux-raid-owner@vger.kernel.org
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: Phillip Susi <psusi@cfl.rr.com>, Neil Brown <neilb@suse.de>, Jan Engelhardt <jengelh@linux01.gwdg.de>, "Lincoln Dale (ltd)" <ltd@cisco.com>, Michael Tokarev <mjt@tls.msk.ru>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Steinar H. Gunderson" <sgunderson@bigfoot.com>
List-Id: linux-raid.ids

On Fri, Jan 20, 2006 at 11:53:06AM +0100, Lars Marowsky-Bree wrote:
> On 2006-01-19T21:17:12, Phillip Susi <psusi@cfl.rr.com> wrote:
>=20
> > I am under the impression that dm is simpler/cleaner than md.  That=
=20
> > impression very well may be wrong, but if it is simpler, then that'=
s a=20
> > good thing.=20
>=20
> That impression is wrong in that general form. Both have advantages a=
nd
> disadvantages.
>=20
> I've been an advocate of seeing both of them merged, mostly because I
> think it would be beneficial if they'd share the same interface to
> user-space to make the tools easier to write and maintain.
>=20
> However, rewriting the RAID personalities for DM is a thing only a fo=
ol
> would do without really good cause.

Thanks Lars ;)

> Sure, everybody can write a
> RAID5/RAID6 parity algorithm. But getting the failure/edge cases stab=
le
> is not trivial and requires years of maturing.
>=20
> Which is why I think gentle evolution of both source bases towards so=
me
> common API (for example) is much preferable to reinventing one within
> the other.
>=20
> Oversimplifying to "dm is better than md" is just stupid.
>=20
>=20
>=20
> Sincerely,
>     Lars Marowsky-Br=E9e
>=20
> --=20
> High Availability & Clustering
> SUSE Labs, Research and Development
> SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
> "Ignorance more frequently begets confidence than does knowledge"
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Regards,
Heinz    -- The LVM Guy --

=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-

Heinz Mauelshagen                                 Red Hat GmbH
Consulting Development Engineer                   Am Sonnenhang 11
Cluster and Storage Development                   56242 Marienrachdorf
                                                  Germany
Mauelshagen@RedHat.com                            +49 2626 141200
                                                       FAX 924446
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
