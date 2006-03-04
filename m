From: Kasper Dupont
	<10616252720827252562@expires.05.sep.2006.kasperd.net>
Subject: Re: No syncing after crash. Is this a software raid bug?
Date: Sat, 4 Mar 2006 14:16:11 +0100
Message-ID: <20060304131609.GA4064@erwin.lan>
References: <20060301124432.GA3591@hactar.lan> <20060301215641.GA27042@hactar.lan> <20060303073016.GA662@hactar.lan> <20060303144824.GA15672@hactar.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060303144824.GA15672@hactar.lan>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> If it relies on static page content during updates of its mirrors, it
> need to take a private copy of the page(s).

And by that you mean that raid5 and raid6 must copy the page
contents before writing it to disk?

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
