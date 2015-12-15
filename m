From: Dallas Clement <dallas.a.clement@gmail.com>
Subject: Re: best base / worst case RAID 5,6 write speeds
Date: Tue, 15 Dec 2015 11:30:13 -0600
Message-ID: <CAE9DZURepRB3k-pBnRg2Tx8GCzAr6zCzv+LJy4mK4CDdAkBYVQ@mail.gmail.com>
References: <CAE9DZUR=uSzYfdqFkVFdyXx+iKb1SeXxo5eX7M_nTw-fnWBwNA@mail.gmail.com>
	<CAE9DZUR1Nka=5mAB2WQHeFkinO0CzuH_GT1gRiVsuREQfgdGcQ@mail.gmail.com>
	<CAK2H+efF2dM1BsM7kzfTxMdQEHvbWRaVe7zJLTGcPZzafn2M6A@mail.gmail.com>
	<CAE9DZUQ+LOFWNQ2MpKoSx8j8RHVqkL15PO+jVjs7EkCQykG6VA@mail.gmail.com>
	<CAE9DZUQo4CojhuVkQ6y=gTEWG5qUkeu57wcZsqbXZtGD_V5JCQ@mail.gmail.com>
	<CAK2H+ec-zMbhxoFyHXLkdM-z-9cYYzNbPFhn19XjTHqrOMDZKQ@mail.gmail.com>
	<CAE9DZURK+bZ=4czbGojzW815Du1ascr5vzAPtQBw4ZDGyq0MAQ@mail.gmail.com>
	<22122.64143.522908.45940@quad.stoffel.home>
	<CAE9DZUQ=QynBKYJvq2JSnMaACKNpm+5yrhz+5x9Tx6_TK78mCg@mail.gmail.com>
	<22123.9525.433754.283927@quad.stoffel.home>
	<CAE9DZUTMnwpUX1e95c_i04uWREHd+aR8P2yCE_W-WmEbL6YRkw@mail.gmail.com>
	<CAE9DZUTTP1VhVgT56dyv6aLaM2V8peWSHaBg4xvXzGGUZcJ_hw@mail.gmail.com>
	<CAE9DZURuPGEL4bG=44ntbjp+51jktn36LFGfn11xFR-X9O9POw@mail.gmail.com>
	<566B6C8F.7020201@turmel.org>
	<CAE9DZURoHBRHq2M0spkTrBGoXmw9QjoARb_Gc6C6OvM9940aMA@mail.gmail.com>
	<566BA6E5.6030008@turmel.org>
	<CAE9DZUT42rCgjSacbs170ftzBtC4i83TRvk7CGeELqpYg3hVzw@mail.gmail.com>
	<CAK2H+edazVORrVovWDeTA8DmqUL+5HRH-AcRwg8KkMas=o+Cog@mail.gmail.com>
	<CAE9DZURBQxteib=hW6FskuJCJTxZDWhy5kMVy2u1hU5Nkg8Khg@mail.gmail.com>
	<CAK2H+ed-3Z8SR20t8rpt3Fb48c3X2Jft=qZoiY9emC2nQww1xQ@mail.gmail.com>
	<CAE9DZUQHBycc5+Z2YrJtWZRYxOUMu3pgnaEQSrsyeCZEv8vndA@mail.gmail.com>
	<CAE9DZUT1v+CFZOs33CC+JrWcX_WHBu+WW78AynkWqJN+LLoqDA@mail.gmail.com>
	<CAK2H+ecMvDLdYLhMtMQbP7Ygw-VohG7LGZ2n7H+LAXQ1waJK3A@mail.gmail.com>
	<CAE9DZUSbt7Kfwd9S3K_SXY7fVRk-vq5RhrPzKs4XO8uhyfPh3Q@mail.gmail.com>
	<CAE9DZUQxT_5L0bW5m9SZ_d2GU6sZS8k0qD=g+o112qM4V=cJkw@mail.gmail.com>
	<22128.11867.847781.946791@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22128.11867.847781.946791@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Mark Knecht <markknecht@gmail.com>, Phil Turmel <philip@turmel.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks guys for all the ideas and help.

Phil,

> Very interesting indeed. I wonder if the extra I/O in flight at high
> depths is consuming all available stripe cache space, possibly not
> consistently. I'd raise and lower that in various combinations with
> various combinations of iodepth.  Running out of stripe cache will cause
> premature RMWs.

Okay, I'll play with that today.  I have to confess I'm not sure that
I completely understand how the stripe cache works.  I think the idea
is to batch I/Os into a complete stripe if possible and write out to
the disks all in one go to avoid RMWs.  Other than alignment issues,
I'm unclear on what triggers RMWs.  It seems like as Robert mentioned
that if the I/Os block size is stripe aligned, there should never be
RMWs.

My stripe cache is 8192 btw.

John,

> I suspect you've hit a known problem-ish area with Linux disk io, which is that big queue depths aren't optimal.

Yes, certainly looks that way.  But maybe as Phil indicated I might be
exceeding my stripe cache.  I am still surprised that there are so
many RMWs even if the stripe cache has been exhausted.

> As you can see, it peaks at a queue depth of 4, and then tends
> downward before falling off a cliff.  So now what I'd do is keep the
> queue depth at 4, but vary the block size and other parameters and see
> how things change there.

Why do you think there is a gradual drop off after queue depth of 4
and before it falls off the cliff?

> Now this is all fun, but I also think you need to backup and re-think
> about the big picture.  What workloads are you looking to optimize
> for?  Lots of small file writes?  Lots of big file writes?  Random
> reads of big/small files?

> Are you looking for backing stores for VMs?

I with this were for fun! ;)  Although this has been a fun discussion.
I've learned a ton.  This effort is for work though.  I'd be all over
the SSDs and caching otherwise.  I'm trying to characterize and then
squeeze all of the performance I can out of a legacy NAS product.  I
am constrained by the existing hardware.  Unfortunately I do not have
the option of using SSDs or hardware RAID controllers.  I have to rely
completely on Linux RAID.

I also need to optimize for large sequential writes (streaming video,
audio, large file transfers), iSCSI (mostly used for hosting VMs), and
random I/O (small and big files) as you would expect with a NAS.
