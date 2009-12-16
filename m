From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Random IO with md raid
Date: Wed, 16 Dec 2009 12:32:20 +0100
Message-ID: <87zl5j6tob.fsf@frosties.localdomain>
References: <4B198DBA.5000906@matws.net> <4B1A6C28.20800@shiftmail.org>
	<4B1D88D2.9000001@matws.net> <87hbs03y0t.fsf@frosties.localdomain>
	<4B260000.3040703@matws.net>
	<4877c76c0912140213u3dab2fcfxfd7ed1b4ff79f4ad@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c0912140213u3dab2fcfxfd7ed1b4ff79f4ad@mail.gmail.com>
	(Michael Evans's message of "Mon, 14 Dec 2009 02:13:39 -0800")
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: Matthieu Patou <mat@matws.net>, Goswin von Brederlow <goswin-v-b@web.de>, Asdo <asdo@shiftmail.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Michael Evans <mjevans1983@gmail.com> writes:

> On Mon, Dec 14, 2009 at 1:06 AM, Matthieu Patou <mat@matws.net> wrote=
:
>> Hello Goswin,
>>> Software raid1 will write twice as much data. That means twice as m=
uch
>>> data goes over the system bus and into the controler cache.
>>> Effectively you have halve the cache size. Maybe that is all you se=
e.
>>>
>>> MfG
>>> =A0 =A0 =A0 =A0 =A0Goswin
>>>
>> Your idea seems logical, and I took a few hours today to verify it a=
nd it's
>> the case as accessing the disk without software raid leads to almost=
 the
>> same result as with hardware raid.
>>
>> Matthieu.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
> Thinking about it, the doubling of data going over the system bus par=
t
> is correct.  You must still push the operation out to each device's
> buffer.  However for -most- modern systems the system-bus will not be
> the bottleneck for a reasonable number of drives.
>
> Further the later half which I'd skimmed over the first time is
> utterly incorrect.  Each drive would still only see the commands
> targeting that drive.  That should be virtually the same if not
> identical to the single-drive case.

The controler itself has cache. And that is shared between all drives.

> The two most likely bottlenecks are single-drive write speed, and any
> IO barriers that are used to ensure file system consistency in the
> event of sudden interruption.

MfG
        Goswin
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
