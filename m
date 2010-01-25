From: Asdo <asdo@shiftmail.org>
Subject: Re: Swapping a disk without degrading an array
Date: Mon, 25 Jan 2010 15:51:27 +0100
Message-ID: <4B5DAFEF.7090500@shiftmail.org>
References: <1264421475.30742.49.camel@test.apertos.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <1264421475.30742.49.camel@test.apertos.eu>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWljaGHFgiBTYXdpY3o=?= <michal@sawicz.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Micha=C5=82 Sawicz wrote:
> ... I wanted to start a discussion whether this at all makes sense, w=
hat can
> be the use cases etc. ...
This appears just a great feature to me, you get my vote.

I also was thinking about something similar. This is probably the most=20
desirable feature request for MD for me right now.


Use cases could be:

- 1 -  the obvious one: you are seeing some preliminary errors=20
(correctable read errors, or SMART errors) on the disk and you want to=20
replace it without making the array degraded & temporarily vulnerable.

- 2 - recoverying from a really bad array having multiple read errors i=
n=20
different places in multiple disks (replacing one disk at a time with=20
the feature you suggest): consider that while filling each sector of th=
e=20
the hot-spare the algorithm has 2 places where to read data from:=20
firstly it can try read from the drive being replaced, and then if that=
=20
one returns read errors it can get the information from parity.=20
Currently there is no other way to do this with this level of redundanc=
y=20
AFAIK, at least not automatically and not with the array online.=20
Consider that if you have a bad array as described, doing a full scrub=20
would take the array down, i.e. the scrub would never successfully=20
finish, and the new drive could never be filled with data. While with=20
the feature you suggest, there is no scrub on the whole array: data is=20
taken only from the drive being replaced for all the sectors (that's th=
e=20
only disk being scrubbed), except possibly for a few sectors being=20
defective on that disk, for which parity is used.


Thank you
Asdo
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
