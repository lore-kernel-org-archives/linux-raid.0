From: Stefan Lamby <webmaster@peter-speer.de>
Subject: Re: raid 10 - Recovering raid - what stats are most helpfull?
Date: Fri, 6 Mar 2015 20:23:10 +0100 (CET)
Message-ID: <270478433.23047.1425669790387.JavaMail.open-xchange@app04.ox.hosteurope.de>
References: <493130695.186182.1425543528690.JavaMail.open-xchange@app10.ox.hosteurope.de> <54F85645.9000603@turmel.org>
Reply-To: Stefan Lamby <webmaster@peter-speer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54F85645.9000603@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


> Phil Turmel <philip@turmel.org> hat am 5. M=C3=A4rz 2015 um 14:12 ges=
chrieben:
>
>
> On 03/05/2015 03:18 AM, Stefan Lamby wrote:
> >
> > Hi.
> > Is it OK to ask for support here to this list or is it the wrong pl=
ace?
> > If so, could you please give a hint where to go?
>
> This is the right place. Post your array details (mdadm -D), member
> details (mdadm -E) and a summary of what happened. Include excerpts
> from your dmesg and/or syslogs that look like they might be relevant.
>
> These should all be text files, so pasting them directly into your em=
ail
> would be preferred.
>
> Regards,
>
> Phil Turmel
>
>


Hi Phil,
hello List.

This would be also very interesting - just in case:

Hopefully it will never happen, but if the raid 10 array crashes, what
information will be the most usefull for later recovery? Is this the ou=
tput of
cat /proc/mdstat or as mentioned by Phil the output of mdadm --detail o=
r what
ever?

I would like to be prepared and write a small shell script which will w=
rite this
to a file to be included in the backups.

What information about the raid would you suggest to collect and to sav=
e
somewhere to have it handy in case it is needed?

Thank you very much for your help.
Stefan


P.S.: Phil, thank you so much for the hints regarding moving the data. =
It looks
very promising. I'll know more in detail tomorrow. pvmove is taking all=
 night, I
guess.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
