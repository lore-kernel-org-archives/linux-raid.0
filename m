From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Random IO with md raid
Date: Mon, 14 Dec 2009 02:13:39 -0800
Message-ID: <4877c76c0912140213u3dab2fcfxfd7ed1b4ff79f4ad@mail.gmail.com>
References: <4B198DBA.5000906@matws.net> <4B1A6C28.20800@shiftmail.org>
	 <4B1D88D2.9000001@matws.net> <87hbs03y0t.fsf@frosties.localdomain>
	 <4B260000.3040703@matws.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B260000.3040703@matws.net>
Sender: linux-raid-owner@vger.kernel.org
To: Matthieu Patou <mat@matws.net>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, Asdo <asdo@shiftmail.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Dec 14, 2009 at 1:06 AM, Matthieu Patou <mat@matws.net> wrote:
> Hello Goswin,
>> Software raid1 will write twice as much data. That means twice as mu=
ch
>> data goes over the system bus and into the controler cache.
>> Effectively you have halve the cache size. Maybe that is all you see=
=2E
>>
>> MfG
>> =A0 =A0 =A0 =A0 =A0Goswin
>>
> Your idea seems logical, and I took a few hours today to verify it an=
d it's
> the case as accessing the disk without software raid leads to almost =
the
> same result as with hardware raid.
>
> Matthieu.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Thinking about it, the doubling of data going over the system bus part
is correct.  You must still push the operation out to each device's
buffer.  However for -most- modern systems the system-bus will not be
the bottleneck for a reasonable number of drives.

=46urther the later half which I'd skimmed over the first time is
utterly incorrect.  Each drive would still only see the commands
targeting that drive.  That should be virtually the same if not
identical to the single-drive case.

The two most likely bottlenecks are single-drive write speed, and any
IO barriers that are used to ensure file system consistency in the
event of sudden interruption.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
