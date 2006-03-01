From: Kasper Dupont
	<48755289462761382922@expires.02.sep.2006.kasperd.net>
Subject: Re: No syncing after crash. Is this a software raid bug?
Date: Wed, 1 Mar 2006 22:56:43 +0100
Message-ID: <20060301215641.GA27042@hactar.lan>
References: <20060301124432.GA3591@hactar.lan>
Reply-To: linux-raid@vger.kernel.org,
	  48755289462761382922@expires.02.sep.2006.kasperd.net
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060301124432.GA3591@hactar.lan>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Why would you not be happy? resyncs in general are bad since they
> indicate your data is possibly out-of-sync and the resync itself
> consumes an enormous amount of resources

Of course reducing the amount of resources spend on syncing is
a good thing. But it shouldn't be done at the expense of less
reliability.

> This is a feature of new-ish md driver code that more aggressively ma=
rks
> the array as "clean" after writes

A bit too aggressive it seems. How can it end up being marked
clean when the two mirrors differ?

> The end result is that the array will most likely be "clean" in all
> circumstances even a crash, and you simply won't need to resync

Shouldn't it be unclean while an update is in progress? And if
it is how come I have been completely unable to trigger a resync
even when it was reset while disks were busy writing?

Here is the program I have used to verify if the two mirrors are
in sync: http://kasperd.net/~kasperd/raidtest.c
This program find that there is a difference between the two
mirrors.

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
