From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Awful RAID5 random read performance
Date: Wed, 03 Jun 2009 14:38:11 -0400
Message-ID: <4A26C313.6080700@tmr.com>
References: <20090531154159405.TTOI3923@cdptpa-omta04.mail.rr.com> <200905311056.30521.tfjellstrom@shaw.ca> <4A25754F.5030107@tmr.com> <20090602194704.GA30639@rap.rap.dk> <4A25B201.2000705@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A25B201.2000705@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

John Robinson wrote:
> On 02/06/2009 20:47, Keld J=F8rn Simonsen wrote:
> [...]
>> My perception is that raid10,f2 is probably the fastest also for=20
>> small random
>> reads because of the lower latency, and faster transfer times due to=
=20
>> only
>> using the outer disk sectors. For writes the elevator evens out the
>> ramdom access. Benchmarks may not show this effect as they are often
>> done on clean file systems, where the files are allocated in the
>> beginning of the fs.
>>
>> For cases where you need cheap disk space, and have big files like
>> .iso's then raid5 could be a good choice because it has the most spa=
ce
>> while maintaining fair to good performance for big files.
>> In your case, using 3 disks, raid5 should give about 210 % of the=20
>> nominal
>> single disk speed for big file reads, and maybe 180 % for big file
>> writes. raid10,f2 should give about 290 % for big file reads and 140=
%
>> for big file writes. Random reads should be about the same for raid5=
 and
>> raid10,f2 - raid10,f2 maybe 15 % faster, while random writes should =
be
>> mediocre for raid5, and good for raid10,f2.
>
> I'd be interested in reading about where you got these figures from=20
> and/or the rationale behind them; I'd have guessed differently...

=46or small values of N, 10,f2 generally comes quite close to N*Sr, whe=
re=20
N is # of disks and Sr is single drive read speed. This is assuming=20
fiarly large reads and adequate stripe buffer space. Obviously for=20
larger values of N that saturates something else in the system, like th=
e=20
bus, before N gets too large. I don't generally see more than (N/2-1)*S=
w=20
for write, at least for large writes. I came up with those numbers base=
d=20
on testing 3-4-5 drive arrays which do large file transfers. If you wan=
t=20
to read more than large file speed into them, feel free.

All tests done on raw devices and raw arrays, and ext3 devices and=20
arrays. The ratios stay about the same, tuning stripe size (stride) can=
=20
be helpful for improving write speed.

Short summary - the numbers look close enough to mine that I would say=20
they are at least useful approximations.

--=20
Bill Davidsen <davidsen@tmr.com>
  Even purely technical things can appear to be magic, if the documenta=
tion is
obscure enough. For example, PulseAudio is configured by dancing naked =
around a
fire at midnight, shaking a rattle with one hand and a LISP manual with=
 the
other, while reciting the GNU manifesto in hexadecimal. The documentati=
on fails
to note that you must circle the fire counter-clockwise in the southern
hemisphere.



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
