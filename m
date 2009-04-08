From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: RAID halting
Date: Wed, 8 Apr 2009 10:37:34 -0400
Message-ID: <87f94c370904080737m2cc82712v3c02b072250f41a7@mail.gmail.com>
References: <F2C688D6A021E34CB81C0E631EF4C09301864D15@34093-C4-EVS1.exchange.rackspace.com>
	 <20090408141756.SJCK26228.cdptpa-omta04.mail.rr.com@Leslie>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090408141756.SJCK26228.cdptpa-omta04.mail.rr.com@Leslie>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Apr 8, 2009 at 10:17 AM, Leslie Rhorer <lrhorer@satx.rr.com> wr=
ote:
>> There is also a SMART error log reporting mechanism. =A0The disks ha=
ve
>> ability to report the last 5 commands that errored on each disk, whi=
ch
>> includes timestamp, op code, input parameters and reason for error.
>
> I pulled the logs from the drives. =A0Four showed no errors whatsoeve=
r, and
> three showed 1, 2, and 3 errors, respectively. =A0The others ranged f=
rom 408
> to 1871. =A0I then triggered a halt with a mv command, and checked th=
e logs
> again. =A0The values all remain the same, with no new errors reported
> whatsoever.
>
>> This runs instantly, and it is possible that just having these last =
5
>> errors will tell you exactly what problem is. The errors are also
>
> I presume a sector remapping would be caught by the log file, yes? =A0=
If so,
> bad sector mapping is pretty much completely eliminated as a cause fo=
r this
> issue.

Leslie,

The next thing I would try to eliminate is the kernel i/o scheduler.
I assume you're using the default one (CFQ).

The noop one is far less complex and in particular I believe it does
not have all the "plugging" logic that CFQ has.

Plugging is used to ensure data is held back from the disk until all
of it is in the block layer buffers together, thus allowing
coalescing, and seek sorting (elevator logic) to most efficiently take
place.  The trouble is that if a unplug call is missed, the i/o can
stall waiting for it.  I don't know if it can cause a total i/o stall
like your seeing or not.

Since the noop scheduler does not do any of this fancyness, you
eliminate one the big potential causes of your problem by this test.
And since you said throughput is not a major concern for you, I would
leave the noop scheduler in place for the long run if it gives
satisfactory results.

I think the only way to switch schedulers is to reboot.  You invoke
the noop scheduler via a command line arg to the kernel at boot time.

You said your using debian, I don't know if they have a gui tool to
make that change for you or not.  Alternatively you can edit
/boot/grub/menu.lst manually.  (Assuming your using grub.)

Greg
--=20
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
=46irst 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.p=
df

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
