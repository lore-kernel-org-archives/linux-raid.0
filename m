From: Marcus Sorensen <shadowsor@gmail.com>
Subject: Re: md RAID with enterprise-class SATA or SAS drives
Date: Thu, 10 May 2012 17:00:37 -0600
Message-ID: <CALFpzo68RksP9Wwb5jDTRzwNb4e83s6hVKcqrPrNSRHf5uFdzw@mail.gmail.com>
References: <4FAAE8F1.8000600@pocock.com.au>
	<CALFpzo5ObdwFATdT4e20znnxzU5hX9SVSfqJcdqOXM1FEYJQuw@mail.gmail.com>
	<4FABC7C6.4030107@turmel.org>
	<CALFpzo6BECrv2eTbSRKwUzpTopx_0EmD+UipqUf-XE=vzz2OnQ@mail.gmail.com>
	<4FAC366E.7080309@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FAC366E.7080309@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Phil Turmel <philip@turmel.org>, Daniel Pocock <daniel@pocock.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You quoted me so I'll reply to this. Consider that most people use
drives with NO limit, and that the 7 second limit is standard only
because most RAID cards will freak and start sending resets at around
8 seconds. The danger you discuss is just as prevalent with a 7 second
limit; if a drive is repeatedly having to do *any* read correction
then it should be replaced, but that's a separate discussion on
monitoring. However the notion that a drive routinely doing error
correction within 5 seconds keeps you safer if called upon to do a
rebuild than one that routinely takes 11 seconds is spurious.

I agree that your assertion of "enterprise users don't use md RAID" is
false. Then again, perhaps we should only define enterprises as those
who don't use software RAID.

Regarding something someone else mentioned, as far as I'm aware md
raid kicks drives out based on a read error rate, not only on writes.
This since 2.6.33, and in the patched RHEL/CentOS 6 stuff. see
drivers/md/md.c "#define MD_DEFAULT_MAX_CORRECTED_READ_ERRORS 20"

On Thu, May 10, 2012 at 3:43 PM, Stan Hoeppner <stan@hardwarefreak.com>=
 wrote:
> On 5/10/2012 10:26 AM, Marcus Sorensen wrote:
>
>> * Using smartctl to increase the ERC timeout on enterprise SATA
>> drives, say to 25 seconds, for use with md. I have no idea if this
>> will cause the drive to actually try different methods of recovery,
>> but it could be a good middle ground.
>
> If a drive needs 25 seconds to recover from a read error it should ha=
ve
> been replaced long ago.
>
> The only thing that increasing these timeouts to silly high numbers d=
oes
> is, hopefully for those doing it anyway, prolong the replacement
> interval of failing drives.
>
> Can anyone guess what the big bear trap is that this places before yo=
u?
> =A0The rest of the drives in the array have been held over much longe=
r as
> well. =A0So when you go to finally rebuild the replacement for this 2=
5s
> delay king, you'll be more likely to run into unrecoverable errors on
> other array members. =A0Then you chance losing your entire array, and=
, for
> many here, all of your data, as hobbyists don't do backups. ;)
>
> Fist 2 rules of managing RAID systems:
>
> 1. =A0Monitor drives and preemptively replace those going down hill B=
EFORE
> your RAID controllers or md raid kick them
>
> 1a. Don't wait for controllers/md raid to kick bad drives
>
> 2. =A0Data is always worth more than disks drives
>
> 2a. If drives cost more than your lost data, you're doing it wrong
>
> --
> Stan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
