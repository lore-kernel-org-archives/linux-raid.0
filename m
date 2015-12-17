From: Dallas Clement <dallas.a.clement@gmail.com>
Subject: Re: best base / worst case RAID 5,6 write speeds
Date: Thu, 17 Dec 2015 17:28:58 -0600
Message-ID: <CAE9DZUS+gmgTLr_4EUgLcPCPWknoqg640mCMZX46cxXeyT6RQA@mail.gmail.com>
References: <CAE9DZUR=uSzYfdqFkVFdyXx+iKb1SeXxo5eX7M_nTw-fnWBwNA@mail.gmail.com>
	<CAK2H+ed-3Z8SR20t8rpt3Fb48c3X2Jft=qZoiY9emC2nQww1xQ@mail.gmail.com>
	<CAE9DZUQHBycc5+Z2YrJtWZRYxOUMu3pgnaEQSrsyeCZEv8vndA@mail.gmail.com>
	<CAE9DZUT1v+CFZOs33CC+JrWcX_WHBu+WW78AynkWqJN+LLoqDA@mail.gmail.com>
	<CAK2H+ecMvDLdYLhMtMQbP7Ygw-VohG7LGZ2n7H+LAXQ1waJK3A@mail.gmail.com>
	<CAE9DZUSbt7Kfwd9S3K_SXY7fVRk-vq5RhrPzKs4XO8uhyfPh3Q@mail.gmail.com>
	<CAE9DZUQxT_5L0bW5m9SZ_d2GU6sZS8k0qD=g+o112qM4V=cJkw@mail.gmail.com>
	<22128.11867.847781.946791@quad.stoffel.home>
	<CAE9DZURepRB3k-pBnRg2Tx8GCzAr6zCzv+LJy4mK4CDdAkBYVQ@mail.gmail.com>
	<22128.35881.182823.556362@quad.stoffel.home>
	<CAE9DZUQNBPNXFs69JRU0Q82TQ4RjAgpsc7voMgEzuhSZhmDjig@mail.gmail.com>
	<CAE9DZUQqeCY__+8Fwg51PJc6zAk0J2Apm2TE3CRvxbFUf-xDKQ@mail.gmail.com>
	<CAK2H+eeD2k4yzuvL4uF_qKycp6A=XPe8pVF_J-7Agi8Ze89PPQ@mail.gmail.com>
	<5672BB7A.4050808@turmel.org>
	<CAE9DZUQj2TNX4Wpk5xbaCVzEgPq2D6Co7ZDNaAy-TOaB4hwZeA@mail.gmail.com>
	<567339F0.9000209@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <567339F0.9000209@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Mark Knecht <markknecht@gmail.com>, John Stoffel <john@stoffel.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Dec 17, 2015 at 4:40 PM, Phil Turmel <philip@turmel.org> wrote:
> On 12/17/2015 04:08 PM, Dallas Clement wrote:
>> I am still in the process of collecting a bunch of performance data.
>> But so far, it is shocking to see the throughput difference when
>> blocks written are stripe aligned.
>
> Random writes unaligned has at least a 4x multiplier on raid5 and 6x on
> raid6 per my earlier explanation.  Why does this surprise you?  It's
> parity raid.  This is why users with heavy random workloads are pointed
> at raid1 and raid10.  I like raid10,f3 for VM host images and databases.
>
>> However, in the non-ideal world it
>> is not always possible to ensure that clients are writing blocks of
>> data which are stripe aligned.
>
> Hardly possible at all, except for bulk writes of large media files, and
> then only if you are writing one stream at a time to an otherwise idle
> storage stack.  Not very realistic in a general-purpose storage
> appliance.  "General purpose" just isn't very sequential.
>
>> If the goal is to reduce the # of RMWs
>> it seems like writing big blocks would also help for sequential
>> workloads where large quantities of data are being written.
>
> The goal is to be able to read later what you need to write now.  Unless
> you have unlimited $ to spend, you have to balance speed, redundancy,
> and capacity.  As they say, pick two.
>
> Lots of spindles is generally good.  Raid5 is great for capacity, good
> for redundancy, and marginal for speed.  Raid6 is great for capacity,
> great for redundancy, and pitiful for speed.  Raid10,f2 is great for
> speed, poor for capacity, and good for redundancy.  Raid10,f3 is great
> for speed, pitiful for capacity, and great for redundancy.
>
>> Can any
>> of you think of anything else that can be tuned in the kernel to
>> reduce # of RMWs in the case where blocks are not stripe aligned?  Is
>> it a bad idea to mess with the timing of the stripe cache?
>
> You can't really hold those writes for long, as any serious application
> is going to call fdatasync at short intervals, for algorithmic integrity
> reasons.  On random workloads, you simply have no choice but to do RMWs.
>  Your only out is to make complete chunk stripes smaller than your
> application's typical write size.  That raises the odds that any
> particular write will be aligned or mostly aligned.  Have you tried 4k
> chunks?
>
> Phil
>

Hi Phil.  Thanks for the explanation.

> Random writes unaligned has at least a 4x multiplier on raid5 and 6x on
> raid6 per my earlier explanation.  Why does this surprise you?  It's
> parity raid.  This is why users with heavy random workloads are pointed
> at raid1 and raid10.  I like raid10,f3 for VM host images and databases.

It really shouldn't surprise me.  I should have said I am very HAPPY
to see such relatively good performance when the writes are stripe
aligned. :)

> Have you tried 4k chunks?

No not yet.  I've been taking some measurements with 16k, 32k, 64k,
128k, 256k.  So far it looks like 64k has the highest speeds for RAID
5 sequential writes.
