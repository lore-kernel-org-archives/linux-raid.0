From: Bart Kus <me@bartk.us>
Subject: Re: md-raid paranoia mode?
Date: Wed, 11 Jun 2014 03:34:01 -0700
Message-ID: <53983099.8030801@bartk.us>
References: <5397FBCE.3060009@bartk.us> <CAH3kUhH06kpJNqb-zdcv5nu2e1FeZuotcW0SjBbWDOCcasm9OA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH3kUhH06kpJNqb-zdcv5nu2e1FeZuotcW0SjBbWDOCcasm9OA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Doing the periodic check does not prevent corruption of read() data=20
though (RAID6 case).  Copied files may be corrupted, even though the=20
RAID would eventually fix itself after a repair is done.

Yes, there is a performance penalty, but data integrity is also=20
improved.  Paranoid mode should probably not be the default, but I woul=
d=20
like the choice to improve data integrity at the expense of some small=20
speed penalty.  ZFS implements this anti-corruption checking by using=20
checksums on their data.  We don't have a simple checksumming mechanism=
=20
in md-raid, but we do have the full stripe data available ready for=20
verification.

BTW, the idea of a daily repair operation doesn't work when it takes 14=
=20
hours to repair a large RAID.  That would only leave 10 hours of each=20
day for normal speed access.  I schedule repairs weekly, though.

--Bart


On 6/11/2014 2:53 AM, Roberto Spadim wrote:
> Hi
> IMHO
>
> For silent corrupt i think it's better a periodic raid check=20
> instead of a paranoid mode
>
> Normally a silent corrupt occurs with an 'old disk' or with old data,=
=20
> but it don't occurs at every disk read (must check disk studies)
>
> I think a 'paranoid' mode is nice, but i think it will reduce all=20
> system performace, maybe an crond daily check is better than a 'all=20
> read, check' (paranoid)
>
> Em quarta-feira, 11 de junho de 2014, Bart Kus <me@bartk.us=20
> <mailto:me@bartk.us>> escreveu:
>
>     Hello,
>
>     As far as I understand, md-raid relies on the underlying devices
>     to inform it of IO errors before it'll seek redundant/parity data
>     to fulfill the read request.  I have, however, seen certain hard
>     drives report successful reads while returning garbage data.
>
>     Is it possible to set md-raid into a paranoid mode, in which it
>     reads all available data and confirms integrity?  Here's how it
>     would work:
>
>     RAID6: read data + parity 1 + parity 2.  If 1 of the 3 mismatches=
,
>     correct it, and write corrected data to the corrupt source.  Log
>     the event.  If all 3 disagree, alert user somehow.
>     RAID5: read data + parity.  If they mismatch, alert user somehow.
>     RAID1: read data 1 + data 2.  If they mismatch, alert user someho=
w.
>
>     You can see this is mostly useful for RAID6 mode, where there is =
a
>     chance at automated recovery.  However, it can also be used to
>     prevent silent data corruption in the other modes, by making it
>     not silent.
>
>     --Bart
>
>     --
>     To unsubscribe from this list: send the line "unsubscribe
>     linux-raid" in
>     the body of a message to majordomo@vger.kernel.org
>     More majordomo info at http://vger.kernel.org/majordomo-info.html
>
>
>
> --=20
> Roberto Spadim
> SPAEmpresarial
> Eng. Automa=C3=A7=C3=A3o e Controle
>

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
