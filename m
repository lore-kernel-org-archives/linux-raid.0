From: Dallas Clement <dallas.a.clement@gmail.com>
Subject: Re: best base / worst case RAID 5,6 write speeds
Date: Thu, 17 Dec 2015 18:54:05 -0600
Message-ID: <CAE9DZUQoYtt3U5rGBAUtTuLS2N2uA80e=EcDD73fHq0qn6YH2w@mail.gmail.com>
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
	<CAE9DZUS+gmgTLr_4EUgLcPCPWknoqg640mCMZX46cxXeyT6RQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAE9DZUS+gmgTLr_4EUgLcPCPWknoqg640mCMZX46cxXeyT6RQA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Mark Knecht <markknecht@gmail.com>, John Stoffel <john@stoffel.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>> Have you tried 4k chunks?
>
> No not yet.  I've been taking some measurements with 16k, 32k, 64k,
> 128k, 256k.  So far it looks like 64k has the highest speeds for RAID
> 5 sequential writes.

Correction.  It looks like a 32k chunk size gives the best performance
overall for RAID 5 sequential and random access.  I'm checking this on
RAID 0, 1, and 6 as well.
