From: Heinz Mauelshagen <mauelshagen@redhat.com>
Subject: Re: No syncing after crash. Is this a software raid bug?
Date: Tue, 7 Mar 2006 13:12:37 +0100
Message-ID: <20060307121237.GS2980@redhat.com>
References: <20060301124432.GA3591@hactar.lan> <20060301215641.GA27042@hactar.lan> <20060303073016.GA662@hactar.lan> <20060303144824.GA15672@hactar.lan> <20060304131609.GA4064@erwin.lan> <20060307104704.GD2976@redhat.com> <20060307111835.GA15648@hactar.lan>
Reply-To: mauelshagen@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060307111835.GA15648@hactar.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Kasper Dupont <61795653253942064414@expires.08.sep.2006.kasperd.net>
Cc: Heinz Mauelshagen <mauelshagen@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Mar 07, 2006 at 12:18:35PM +0100, Kasper Dupont wrote:
> On 07/03/06 11.47, Heinz Mauelshagen wrote:
> > On Sat, Mar 04, 2006 at 02:16:11PM +0100, Kasper Dupont wrote:
> > > > If it relies on static page content during updates of its mirro=
rs, it
> > > > need to take a private copy of the page(s).
> > >=20
> > > And by that you mean that raid5 and raid6 must copy the page
> > > contents before writing it to disk?
> >=20
> > Yes.
> > They need to do it anayway in order to calculate parity blocks.
>=20
> OK, I'll do some testing with raid5 then. I want to know if it
> behaves differently from raid1 in this respect.

Yes, it definitely should.

Heinz

>=20
> --=20
> Kasper Dupont -- Rigtige m=E6nd skriver deres egne backupprogrammer
> #define _(_)"d.%.4s%."_"2s" /* This is my new email address */
> char*_=3D"@2kaspner"_()"%03"_("4s%.")"t\n";printf(_+11,_+6,_,6,_+2,_+=
7,_+6);

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
