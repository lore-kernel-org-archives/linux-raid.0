From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: Re: raid1 bitmap code [Was: Re: Questions answered by Neil Brown]
Date: Thu, 27 Feb 2003 18:18:41 +0100 (MET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200302271718.h1RHIfF32315@oboe.it.uc3m.es>
References: <3E5E41FE.B3E434D3@SteelEye.com>
Reply-To: ptb@it.uc3m.es
Mime-Version: 1.0
Content-Type: text/plain; charset=UNKNOWN-8BIT
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3E5E41FE.B3E434D3@SteelEye.com> from Paul Clements at "Feb 27,
 2003 11:51:10 am"
To: Paul Clements <Paul.Clements@SteelEye.com>
Cc: ptb@it.uc3m.es, Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Paul Clements wrote:"
> "Peter T. Breuer" wrote:
> > "Paul Clements wrote:"
> > We cannot account for how many bits are really dirty in this chunk.=
=20
>=20
> That's OK, we don't need to know. We really just want to know if ther=
e
> are any outstanding writes for that chunk. We increment the chunk

OK. That's a fine semantics.

> So we really don't care how many blocks are dirty, just that there ar=
e
> or are not dirty blocks in the chunk. Does that make sense?

Well, yes.  We would have tried to mark the bitmap before each write,
and I suppose we would have failed for out of memory in creating the
bitmap page, and now you are saying that OK, so let's just count
outstanding writes to th=E6t bitmap zone.

I suppose that if the write fails we don't decrement the count?
Otherwise we do?

So when we do a mark we increment the count on the bitmap zone, and whe=
n
we do a clear we decrement the count, and when the write fails we never
try and clear on the bitmap?  Then what we have is a count of the
unbalance between marks and clears on the bitmap per zone.  And you wan=
t
the

Yes, I can go with that.


Peter
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
