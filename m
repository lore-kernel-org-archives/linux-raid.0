From: Ed W <lists@wildgooses.com>
Subject: Re: HBA Adaptor advice
Date: Mon, 23 May 2011 11:18:05 +0100
Message-ID: <4DDA345D.1010603@wildgooses.com>
References: <4DD50C89.8060006@wildgooses.com> <20110520020853.GC4759@bitfolk.com> <4DD61948.8050302@wildgooses.com> <4DD6409F.9070904@hardwarefreak.com> <4DD79F4E.7000509@wildgooses.com> <4DD8D1A7.1090803@hardwarefreak.com> <4DD8E0D3.1030905@fnarfbargle.com> <4DD9633E.5000101@hardwarefreak.com> <4DD99FF2.2030609@fnarfbargle.com> <4DD9A558.7000802@fnarfbargle.com> <4DD9F0EB.5040801@stud.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD9F0EB.5040801@stud.tu-ilmenau.de>
Sender: linux-raid-owner@vger.kernel.org
To: stefan.huebner@stud.tu-ilmenau.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23/05/2011 06:30, Stefan /*St0fF*/ H=FCbner wrote:

> We sell 200+ drives a week from our "at that time preferred"
> Manufacturer.  That was WD from 2008 till the beginning of 2010. =20

Just to clarify - are all those "failures" basically attributable to
drives with unreadable sectors which then drop out of arrays due to lac=
k
of TLER?

ie if the drive DID have TLER then it would likely not have been
reported as a failed drive? (But presumably smart might report a
re-allocated sector and you might get a sectors dataloss?)



> But
> since the climb of wd failure rates we're at "Hitachi" and have
> astounding failure rates of less than one percent.  I hope this will
> stay the case even after WD bought Hitachi GST...

Likewise is this because the Hitachi drives appear more reliable or
because they incorporate some kind of TLER which keeps them running in
the face of reallocated sectors?

Can you draw your conclusion to the desktop Hitachi drives also? Do
these also suffer lower failure rates? Can they be made "TLER" compatib=
le?


> Conclusion about this university-storage-failure: wrong drives for th=
is
> scenario.  It would've been OK to use the cheap WDs for backup (if th=
e
> backup was at least RAID6 and sends error-mails to the admin).  But t=
he
> primary storage was a big fail.  You do not use this kind of storage =
for
> data which is worth much time (and by that much money).

How do folks here react to Googles paper stating that largely they find
little difference in reliability between "raid drives" and consumer dri=
ves?

Granted it's a problem if a drive pops out of an array because it has a
reallocated sector, but a) do folks with TLER drives immediately replac=
e
the drive when they see a reallocated sector? b) those without TLER run
badblocks and put the drive back into the array c) can MD raid work
around the limitations of lacking TLER and consumer drives?

Thanks

Ed W

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
