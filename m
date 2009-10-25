From: Christopher Chen <muffaleta@gmail.com>
Subject: Re: Is My Data DESTROYED?!
Date: Sat, 24 Oct 2009 19:03:51 -0700
Message-ID: <7bc80d500910241903i1c3faf48r2706d58e14a11016@mail.gmail.com>
References: <7bc80d500910240759x443e7a00n4fdcb41f60ec9d73@mail.gmail.com>
	 <20091025015257748.WYGS6016@cdptpa-omta03.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091025015257748.WYGS6016@cdptpa-omta03.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Oct 24, 2009 at 6:52 PM, Leslie Rhorer <lrhorer@satx.rr.com> wr=
ote:
>> I'm going to go on a limb here and say for anyone (with data they wa=
nt
>> to preserve), no matter what, backups make sense and are cost
>> effective. I'm going to be crazy and say that there's no reason that
>> someone who thinks they can afford a 8TB disk array and dual SLI vid=
eo
>> cards, etc, etc, can't also consider some sort of disk or tape backu=
p.
>
> =A0 =A0 =A0 =A0I agree with the disk backup, but not the tape.
>
>> Cumbersome? Can be. But having worked with datasets and filesystems
>
> =A0 =A0 =A0 =A0Cumberesome, slow, kludgy, and expensive.

Well, like anything else, having a system helps. And by system I mean
a library, barcodes on all tapes, and a good tape storage system. Yes,
it involves Humans.

>
>> that run into the hundreds of terabytes, and having backed them up t=
o
>> tape, it makes sense. If you have something on the order of tens of
>> disks, sure, go ahead, take that next step and back them up somewher=
e
>> else to another set of disks. If you have more disks, seriously
>> consider tape--in terms of capacity and power consumption (and data
>> integrity), tape wins.
>
> =A0 =A0 =A0 =A0Power consumption, yes. =A0Capacity is a somewhat more=
 complex
> problem, with a number of variables. =A0For speed, tapes lose disastr=
ously.
> For cost, hard drives win unless the array is very large. =A0For reli=
ability
> and availability, drives win hands down. =A0I've had quite a bit of d=
ata lost
> with bad tape sets, and the most persistent problems on my systems wh=
ich do
> use tapes involve the tape drives, even sans data loss. =A0Once someo=
ne wiped
> out a directory which someone up in corporate was backing up to tape.=
 =A0It
> took 3 days to recover the directory, no doubt because no one could f=
ind the
> tape.

I'm not so sure about the speed--you can stream 100MB/sec to a single
tape drive, and if you have multiple in a library, it just scales
horizontally.

But, where I was working, we were also duplicating tape sets for
offsite, which means there was two copies per backup set.

Is this expensive? You betcha! But...you know. The bad old days of DDS
are also gone, so there's some rejoicing there.

:)

cc

--=20
Chris Chen <muffaleta@gmail.com>
"The fact that yours is better than anyone else's
is not a guarantee that it's any good."
-- Seen on a wall
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
