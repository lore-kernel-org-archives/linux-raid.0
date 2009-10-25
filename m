From: Christopher Chen <muffaleta@gmail.com>
Subject: Re: Is My Data DESTROYED?!
Date: Sat, 24 Oct 2009 23:15:57 -0700
Message-ID: <7bc80d500910242315s69cc330atb6d910b28edb6f7e@mail.gmail.com>
References: <20091025023059520.QFQH17264@cdptpa-omta04.mail.rr.com>
	 <200910242326.07365.tfjellstrom@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200910242326.07365.tfjellstrom@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: tfjellstrom@shaw.ca
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Oct 24, 2009 at 10:26 PM, Thomas Fjellstrom <tfjellstrom@shaw.c=
a> wrote:
> On Sat October 24 2009, Leslie Rhorer wrote:
>> > On Sat, Oct 24, 2009 at 6:52 PM, Leslie Rhorer <lrhorer@satx.rr.co=
m>
>> > I'm not so sure about the speed--you can stream 100MB/sec to a sin=
gle
>> > tape drive, and if you have multiple in a library, it just scales
>> > horizontally.
>>
>> =A0 =A0 =A0 First of all, that assumes the tape is loaded and ready.=
 =A0It can
>> take hours or even days to retrieve a tape and load it. =A0Secondly,=
 while
>> =A0the tape can stream 100MB/sec, it isn't random access. =A0Finding=
 a 200 byte
>> =A0file in the middle of a 1T tape backup is going to take a while. =
=A0Getting
>> =A0it from an online backup server takes perhaps 10ms after the admi=
n
>> =A0finishes typing the copy command.
>
> Wouldn't you use some 'tar' like format on the tape so there's a file=
 index
> you can search without having to scan the entire tape? Then you can j=
ust
> "ffwd" (seek) to the position. _should_ be lots faster than reading a=
ll of the
> data from the beginning to the files location trying to find it. Or m=
aybe
> there's something I'm missing about tapes?

Yeah, these are all concerns. The last few jobs I've been at have
automatic libraries that hold about a hundred tapes, so, it wasn't
much of an issue. The operator would swap them out on a daily basis,
but there were always tapes ready. And, the library had at least four
drives in it, so, you can imagine the aggregate throughput.

Like I said before, this is a entirely different scale than what most
people deal with.

Thomas, I think Leslie meant the seek time to get to the file. With
most backup systems, file metadata is kept in databases so the catalog
can be queried to find the right tape, etc, etc.

Anyway, yes, not really pertinent to the concerns of a guy with a 1G
ethernet multi-room raid 10.

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
