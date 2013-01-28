From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Mon, 28 Jan 2013 16:07:59 -0700
Message-ID: <ADB1B276-21F3-4006-A613-F979F931EDC3@colorremedies.com>
References: <20130127192656.634892005AD@gemini.denx.de> <20130128173704.GA2329@lazy.lzy> <20130128190035.D943A294BAB@gemini.denx.de> <20130128191041.8E962200607@gemini.denx.de> <20130128192256.GB13803@lazy.lzy> <20130128201947.2B615200607@gemini.denx.de> <20130128204422.GA14115@lazy.lzy> <6D287BCE-96EB-4F91-AC5A-34CD7AD2C68D@colorremedies.com> <20130128225935.B8E2B20004B@gemini.denx.de>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130128225935.B8E2B20004B@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Jan 28, 2013, at 3:59 PM, Wolfgang Denk <wd@denx.de> wrote:

> Dear Chris,
>=20
> In message <6D287BCE-96EB-4F91-AC5A-34CD7AD2C68D@colorremedies.com> y=
ou wrote:
>>=20
>> Yes, it sounds reproducible on more than one array, more than one HB=
A. Is it also more than one computer also, Wolfgang?
>=20
> Correct, these are 3 different machines.

Too bad. Better to test first, than commit so many computers and arrays=
 for such a major change.
>=20
>> I think regression is going to be needed to find it. Hopefully the
>> problem is restricted to parity computation and data chunks aren't
>> affected; however if a URE occurs in a data chunk, it could be
>> reconstructed incorrectly from bad parity so it's obviously still a
>> big problem.
>=20
> My gut feeling is that the data are still OK, but I have to admit tha=
t
> I inspected only a small fraction of the files, and I would like to
> avoid restoring the data from backup tapes to another system as long
> as possible.  So it indeed appears to me as if we had a sotware issue=
,
> computing incorrect parity data.

Unclear. If parity chunks are both wrong, then that means you effective=
ly have partial RAID 0 depending on what parity chunks are correct or n=
ot. I'm not recommending this, but if you set one disk to faulty and st=
arted your file system and file tests again=85 if they're bad then inde=
ed it's parity that's affected. If you don't get errors, then it indica=
tes the test method is insufficient to locate the errors and it could s=
till be data that's affected.

It's a tenuous situation. It might be wise to pick a low priority compu=
ter for regression, and hopefully the problem gets better rather than w=
orse. If the assumption is that the parity is bad, it needs to be recal=
culated with repair. If that goes well with tests and another check scr=
ub, then it's better to get on with additional regressions sooner than =
later. Again in the meantime if you lost a drive, it could be a real me=
ss if the raid starts to rebuild bad data from parity. Or even starts t=
o write user data incorrectly too.

Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
