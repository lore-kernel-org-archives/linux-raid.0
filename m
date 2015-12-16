From: Dallas Clement <dallas.a.clement@gmail.com>
Subject: Re: best base / worst case RAID 5,6 write speeds
Date: Wed, 16 Dec 2015 09:31:43 -0600
Message-ID: <CAE9DZUQqeCY__+8Fwg51PJc6zAk0J2Apm2TE3CRvxbFUf-xDKQ@mail.gmail.com>
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
	<22128.35881.182823.556362@quad.stoffel.home>
	<CAE9DZUQNBPNXFs69JRU0Q82TQ4RjAgpsc7voMgEzuhSZhmDjig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAE9DZUQNBPNXFs69JRU0Q82TQ4RjAgpsc7voMgEzuhSZhmDjig@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Mark Knecht <markknecht@gmail.com>, Phil Turmel <philip@turmel.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Phil, the 16k chunk size has really given a boost to my RAID 5
sequential write performance measured with fio, bs=1408k.

This is what I was getting with a 128k chunk size:

iodepth=4 => 605 MB/s
iodepth=8 => 589 MB/s
iodepth=16 => 634 MB/s
iodepth=32 => 635 MB/s

But this is what I'm getting with a 16k chunk size:

iodepth=4 => 825 MB/s
iodepth=8 => 810 MB/s
iodepth=16 => 851 MB/s
iodepth=32 => 866 MB/s
