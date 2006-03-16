From: Kasper Dupont
	<40993640693243247796@expires.17.sep.2006.kasperd.net>
Subject: Re: No syncing after crash. Is this a software raid bug?
Date: Thu, 16 Mar 2006 08:24:52 +0100
Message-ID: <20060316072450.GA28095@hactar.lan>
References: <20060301124432.GA3591@hactar.lan> <20060301215641.GA27042@hactar.lan> <20060303073016.GA662@hactar.lan> <20060303144824.GA15672@hactar.lan> <20060304131609.GA4064@erwin.lan> <20060307104704.GD2976@redhat.com> <20060307111835.GA15648@hactar.lan> <20060310074337.GE16@redhat.com> <20060310074954.GA23424@hactar.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060310074954.GA23424@hactar.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Heinz Mauelshagen <mauelshagen@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/03/06 08.49, Kasper Dupont wrote:
> On 10/03/06 08.43, Heinz Mauelshagen wrote:
> > On Tue, Mar 07, 2006 at 12:18:35PM +0100, Kasper Dupont wrote:
> > >=20
> > > OK, I'll do some testing with raid5 then. I want to know if it
> > > behaves differently from raid1 in this respect.
> >=20
> > Have you got results yet ?
>=20
> No, not yet. I'll tell you as soon as I have some.

OK now I have some results. I could not reproduce the symptoms
with raid5. As long as this only shows up with raid1, there is
not much reason to worry.

--=20
Kasper Dupont -- Rigtige m=E6nd skriver deres egne backupprogrammer
#define _(_)"d.%.4s%."_"2s" /* This is my new email address */
char*_=3D"@2kaspner"_()"%03"_("4s%.")"t\n";printf(_+11,_+6,_,6,_+2,_+7,=
_+6);
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
