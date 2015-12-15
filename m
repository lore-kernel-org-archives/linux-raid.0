From: "John Stoffel" <john@stoffel.org>
Subject: Re: best base / worst case RAID 5,6 write speeds
Date: Tue, 15 Dec 2015 10:14:35 -0500
Message-ID: <22128.11867.847781.946791@quad.stoffel.home>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAE9DZUQxT_5L0bW5m9SZ_d2GU6sZS8k0qD=g+o112qM4V=cJkw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dallas Clement <dallas.a.clement@gmail.com>
Cc: Mark Knecht <markknecht@gmail.com>, Phil Turmel <philip@turmel.org>, John Stoffel <john@stoffel.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Dallas,

I suspect you've hit a known problem-ish area with Linux disk io,
which is that big queue depths aren't optimal.  They're better for
systems where you're talking to a big backend disk array with lots of
cache/memory which is all battery backed, and which can acknowledge
those writes immmediately, but then retire them to disk in a more
optimal manner.

So using a queue depth of 4, which is per-device, means that you can
have upto 48 writes outstanding at a time.  Just doubling that to 8,
means you can have 96 writes outstanding, which takes up memory
buffers on the system, etc.

As you can see, it peaks at a queue depth of 4, and then tends
downward before falling off a cliff.  So now what I'd do is keep the
queue depth at 4, but vary the block size and other parameters and see
how things change there.

Now this is all fun, but I also think you need to backup and re-think
about the big picture.  What workloads are you looking to optimize
for?  Lots of small file writes?  Lots of big file writes?  Random
reads of big/small files?

Are you looking for backing stores for VMs?

Have you looked into battery backed RAID cards?  They used to be alot
common, but these days CPUs are more than fast enough, and JBOD works
really well with more flexibility and less chance of your data getting
lost due to vendor-lockin.

Another option, if you're looking for performance might be using
lvmcache with a pair of mirrored SSDs, and if you KNOW you have UPS
support on the system, you could change the cache policy from
writeback (both SSDs and backing store writes need to complete) to
write through (SSDs writes done, backing store later...) so that you
get the most speed.

I've just recently done this setup on my home machine (not nearly as
beefy as this) and my off the cuff feeling is that it's a nice
speedup.

But back to the task at hand, what is the goal here?  To find the
sweet spot for your hardware?  For fun?  I'm all up for fun, this is a
great discussion.

It's too bad there's no auto-tuning script for testing a setup and
running fio to get test results, and then having the next knob tweaked
and tested in an automated way.


