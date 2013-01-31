From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Thu, 31 Jan 2013 13:41:58 -0700
Message-ID: <261D7C10-29F9-4C95-9F98-4482A78D0700@colorremedies.com>
References: <20130127192656.634892005AD@gemini.denx.de> <20130128173704.GA2329@lazy.lzy> <20130128190035.D943A294BAB@gemini.denx.de> <20130128191041.8E962200607@gemini.denx.de> <20130128192256.GB13803@lazy.lzy> <20130128201947.2B615200607@gemini.denx.de> <20130128204422.GA14115@lazy.lzy> <20130128231840.03C37203AD5@gemini.denx.de> <20130129175720.GB2396@lazy.lzy> <20130129184309.D65DD2A1846@gemini.denx.de> <20130129202433.GB7005@lazy.lzy> <20130131121220.F3CA220059E@gemini.denx.de> <3DB28596-B1D6-48A9-9520-4CF9D367E39D@colorremedies.com> <20130131183606.E4C23200276@gemini.denx.de> <1C562BB9-9FD8-482C-BE3E-E52A027A5C88@colorremedies.com> <20130131200547.63ABB200276@gemini.denx.de>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130131200547.63ABB200276@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Jan 31, 2013, at 1:05 PM, Wolfgang Denk <wd@denx.de> wrote:
>=20
> Ah!  Do you have any pointer for me how to access stuff there?
http://koji.fedoraproject.org/koji/
Type in kernel for search.
Click on a result that has a green check for state.
=46ind the rpm you want, right click download.

You can use rpm -ivh --force to install an older kernel.


>=20
>>> With the current Fedora kernel, the first check will report errors
>>> which do not go away permanently, not even with a "repair".
>>=20
>> This is 3.7.4-204?
>=20
> Correct.
>=20
>> Hypothetically this should be reproducible by anyone using that kern=
el, by creating a new raid6, running repair, and then running check and=
 confirming thee mismatch count is non-zero.
>=20
> Actually just running check should be sufficient - that was how I
> discovered the issue: I received warning mails from the "raid-check"
> cron job.

But check alone doesn't reproduce the problem because the check *might*=
 be finding valid mismatches, however unlikely on a new raid array. The=
 problem is doing a repair which should fix any mismatches, running che=
ck still finding mismatches then is a huge bug for the scrub process fo=
r sure; and if some parity is actually being computed wrong, or written=
 on disk wrong, then it's a possible data loss bug in addition. Not jus=
t (maybe bogus) errors.


> This is what surprises me most.  I would have expected at least some
> "me too!" by now=85

If there were a study that said 95% of users using md raid never do scr=
ubs, either check or repair, I would not be surprised at all.

> For me it is sufficient to:
>=20
> - boot the 3.7.4-204
> - bring up the array
> - run "check"
>=20
> It comes up with mismatch_cnt=3D0 after boot, and some huge number wh=
ile
> / after the check.

If check is non-zero following a repair, with one kernel version but no=
t another, it's a software bug.

Chris Murphy

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
