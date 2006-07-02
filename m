From: David Greaves <david@dgreaves.com>
Subject: Re: raid issues after power failure
Date: Sun, 02 Jul 2006 10:26:18 +0100
Message-ID: <44A7913A.1050409@dgreaves.com>
References: <49954.82.141.169.118.1151658773.squirrel@mail.tyrell.hu>	 <49971.82.141.169.118.1151659502.squirrel@mail.tyrell.hu>	 <fd8d0180606300250q6fbab5d3wdf343b530f3119a9@mail.gmail.com>	 <fd8d0180606300251p9129a8cr41c62bf87191cf39@mail.gmail.com>	 <fd8d0180606300256j324dbcbfnb9aa21432b22eba1@mail.gmail.com>	 <Pine.LNX.4.63.0606300827570.30060@turos>	 <fd8d0180606300540r3c957a7duf0c831917f55be7f@mail.gmail.com>	 <Pine.LNX.4.63.0606300842430.30060@turos>	 <17573.44678.188170.409349@cse.unsw.edu.au>	 <44A69496.9030109@tyrell.hu> <fd8d0180607020114m5e02e1ek553e5da2941eb6dd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fd8d0180607020114m5e02e1ek553e5da2941eb6dd@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francois Barre <francois.barre@gmail.com>
Cc: Neil Brown <neilb@suse.de>, =?ISO-8859-1?Q?=C1kos_Mar=F3y?= <darkeye@tyrell.hu>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

=46rancois Barre wrote:
> 2006/7/1, =C1kos Mar=F3y <darkeye@tyrell.hu>:
>> Neil Brown wrote:
>> > Try adding '--force' to the -A line.
>> > That tells mdadm to try really hard to assemble the array.
>>
>> thanks, this seems to have solved the issue...
>>
>>
>> Akos
>>
>>
>=20
> Well, Neil, I'm wondering,
> It seemed to me that Akos' description of the problem was that
> re-adding the drive (with mdadm not complaining about anything) would
> trigger a resync that would not even start.
> But as your '--force' does the trick, it implies that the resync was
> not really triggered after all without it... Or did I miss a bit of
> log Akos provided that did say so ?
> Could there be a place here for an error message ?
>=20
> More generally, could it be usefull to build up a recovery howto,
> based on the experiences on this list (I guess 90% of the posts a
> related to recoveries) ?
> Not in terms of a standard disk loss, but in terms of a power failure
> or a major disk problem. You know, re-creating the array, rolling the
> dices, and *tada !* your data is back again... I could not find a bit
> of doc about this.
>=20

=46rancois,
I have started to put a wiki in place here:
  http://linux-raid.osdl.org/

My reasoning was *exactly* that - there is reference information for md
but sometimes the incantations need a little explanation and often the
diagnostics are not obvious...

I've been subscribed to linux-raid since the middle of last year and
I've been going through old messages looking for nuggets to base some
docs around.

I haven't had a huge amount of time recently so I've just scribbled on
it for now - I wanted to present something a little more polished to th=
e
community - but since you're asking...

So don't consider this an official announcement of a useable work yet -
more a 'Please contact me if you would like to contribute' (just so I
can keep track of interested parties) and we can build something up...

David
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
