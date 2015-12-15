From: "John Stoffel" <john@stoffel.org>
Subject: Re: best base / worst case RAID 5,6 write speeds
Date: Tue, 15 Dec 2015 16:54:49 -0500
Message-ID: <22128.35881.182823.556362@quad.stoffel.home>
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
	<CAE9DZURepRB3k-pBnRg2Tx8GCzAr6zCzv+LJy4mK4CDdAkBYVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAE9DZURepRB3k-pBnRg2Tx8GCzAr6zCzv+LJy4mK4CDdAkBYVQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dallas Clement <dallas.a.clement@gmail.com>
Cc: John Stoffel <john@stoffel.org>, Mark Knecht <markknecht@gmail.com>, Phil Turmel <philip@turmel.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Dallas" == Dallas Clement <dallas.a.clement@gmail.com> writes:

Dallas> Thanks guys for all the ideas and help.
Dallas> Phil,

>> Very interesting indeed. I wonder if the extra I/O in flight at high
>> depths is consuming all available stripe cache space, possibly not
>> consistently. I'd raise and lower that in various combinations with
>> various combinations of iodepth.  Running out of stripe cache will cause
>> premature RMWs.

Dallas> Okay, I'll play with that today.  I have to confess I'm not
Dallas> sure that I completely understand how the stripe cache works.
Dallas> I think the idea is to batch I/Os into a complete stripe if
Dallas> possible and write out to the disks all in one go to avoid
Dallas> RMWs.  Other than alignment issues, I'm unclear on what
Dallas> triggers RMWs.  It seems like as Robert mentioned that if the
Dallas> I/Os block size is stripe aligned, there should never be RMWs.

Remember, there's a bounding limit on both how large the stripe cache
is, and how long (timewise) it will let the cache sit around waiting
for new blocks to come in.  That's probably what you're hitting at
times with the high queue depth numbers.

I assume the blocktrace info would tell you more, but I haven't really
a clue how to interpret it.  


Dallas> My stripe cache is 8192 btw.

Dallas> John,

>> I suspect you've hit a known problem-ish area with Linux disk io, which is that big queue depths aren't optimal.

Dallas> Yes, certainly looks that way.  But maybe as Phil indicated I might be
Dallas> exceeding my stripe cache.  I am still surprised that there are so
Dallas> many RMWs even if the stripe cache has been exhausted.

>> As you can see, it peaks at a queue depth of 4, and then tends
>> downward before falling off a cliff.  So now what I'd do is keep the
>> queue depth at 4, but vary the block size and other parameters and see
>> how things change there.

Dallas> Why do you think there is a gradual drop off after queue depth
Dallas> of 4 and before it falls off the cliff?

I think because the in-kernel sizes start getting bigger, and so the
kernel spends more time queuing and caching the data and moving it
around, instead of just shoveling it down to the disks as quick as it
can.

Dallas> I with this were for fun! ;) Although this has been a fun
Dallas> discussion.  I've learned a ton.  This effort is for work
Dallas> though.  I'd be all over the SSDs and caching otherwise.  I'm
Dallas> trying to characterize and then squeeze all of the performance
Dallas> I can out of a legacy NAS product.  I am constrained by the
Dallas> existing hardware.  Unfortunately I do not have the option of
Dallas> using SSDs or hardware RAID controllers.  I have to rely
Dallas> completely on Linux RAID.

Ah... in that case, you need to do your testing from the NAS side,
don't bother going to this level.  I'd honestly now just set your
queue depth to 4 and move on to testing the NAS side of things, where
you have one, two, four, eight, or more test boxes hitting the NAS
box.

Dallas> I also need to optimize for large sequential writes (streaming
Dallas> video, audio, large file transfers), iSCSI (mostly used for
Dallas> hosting VMs), and random I/O (small and big files) as you
Dallas> would expect with a NAS.

So you want to do everything at all once.  Fun.  So really I'd move
back to the Network side, because unless your NAS box has more than
1GigE interface, and supports Bonding/trunking, you've hit the
performance wall.

Also, even if you get a ton of performance with large streaming
writes, when you sprinkle in a small set of random IO/s, you're going
to hit the cliff much sooner.  And in that case... it's another set of
optimizations.

Are you going to use NFSv3?  TCP?  UDP?  1500 MTU, 9000 MTU?  How many
clients?  How active?

Can you give up disk space for IOP/s?  So get away from the RAID6 and
move to RAID1 mirrors with a strip atop it, so that you maximize how
many IOPs you can get.

