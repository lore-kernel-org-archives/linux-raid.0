From: Wolfgang Denk <wd@denx.de>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Tue, 29 Jan 2013 00:23:16 +0100
Message-ID: <20130128232316.7B60A203AD5@gemini.denx.de>
References: <20130127192656.634892005AD@gemini.denx.de> <20130128173704.GA2329@lazy.lzy> <20130128190035.D943A294BAB@gemini.denx.de> <20130128191041.8E962200607@gemini.denx.de> <20130128192256.GB13803@lazy.lzy> <20130128201947.2B615200607@gemini.denx.de> <20130128204422.GA14115@lazy.lzy> <6D287BCE-96EB-4F91-AC5A-34CD7AD2C68D@colorremedies.com> <20130128225935.B8E2B20004B@gemini.denx.de> <ADB1B276-21F3-4006-A613-F979F931EDC3@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <ADB1B276-21F3-4006-A613-F979F931EDC3@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Chris,

In message <ADB1B276-21F3-4006-A613-F979F931EDC3@colorremedies.com> you=
 wrote:
>=20
> > Correct, these are 3 different machines.
>=20
> Too bad. Better to test first, than commit so many computers and arra=
ys
> for such a major change.

In hindsight you are of course correct.  But then, these are still not
really vitally critically systems, and I hve to admit that I did not
expect such kind of problems.  I have installed a large number of
=46edora releases before (all of them since FC4 actually, on quite a
number of systems), and while there have always been some problems, I
never ran into something like this before.

> Unclear. If parity chunks are both wrong, then that means you
> effectively have partial RAID 0 depending on what parity chunks are
> correct or not. I'm not recommending this, but if you set one disk to
> faulty and started your file system and file tests again=C2=85 if the=
y're
> bad then indeed it's parity that's affected. If you don't get errors,
> then it indicates the test method is insufficient to locate the error=
s
> and it could still be data that's affected.

OK, I will keep this in mind. If needed, I can dedicate one of the
systems to even a destructive test without too much actual loss.

> It's a tenuous situation. It might be wise to pick a low priority
> computer for regression, and hopefully the problem gets better rather
> than worse. If the assumption is that the parity is bad, it needs to =
be
> recalculated with repair. If that goes well with tests and another ch=
eck
> scrub, then it's better to get on with additional regressions sooner
> than later. Again in the meantime if you lost a drive, it could be a
> real mess if the raid starts to rebuild bad data from parity. Or even
> starts to write user data incorrectly too.

Well, I did this - the repair worked without errors, but it left again
a huge mismatch_cnt; raid6check on this array has not found any
problems so far - even though I see mismatch_cnt =3D 362731480

Best regards,

Wolfgang Denk

--=20
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
O Staat!   Wie tief dir alle Besten fluchen!  Du bist kein Ziel.  Der
Mensch mu=C3=9F weiter suchen.                     - Christian Morgenst=
ern
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
