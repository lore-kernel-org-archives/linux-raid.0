From: Dallas Clement <dallas.a.clement@gmail.com>
Subject: Re: best base / worst case RAID 5,6 write speeds
Date: Thu, 17 Dec 2015 15:08:01 -0600
Message-ID: <CAE9DZUQj2TNX4Wpk5xbaCVzEgPq2D6Co7ZDNaAy-TOaB4hwZeA@mail.gmail.com>
References: <CAE9DZUR=uSzYfdqFkVFdyXx+iKb1SeXxo5eX7M_nTw-fnWBwNA@mail.gmail.com>
	<CAE9DZURBQxteib=hW6FskuJCJTxZDWhy5kMVy2u1hU5Nkg8Khg@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5672BB7A.4050808@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Mark Knecht <markknecht@gmail.com>, John Stoffel <john@stoffel.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I am still in the process of collecting a bunch of performance data.
But so far, it is shocking to see the throughput difference when
blocks written are stripe aligned.  However, in the non-ideal world it
is not always possible to ensure that clients are writing blocks of
data which are stripe aligned.  If the goal is to reduce the # of RMWs
it seems like writing big blocks would also help for sequential
workloads where large quantities of data are being written.  Can any
of you think of anything else that can be tuned in the kernel to
reduce # of RMWs in the case where blocks are not stripe aligned?  Is
it a bad idea to mess with the timing of the stripe cache?
