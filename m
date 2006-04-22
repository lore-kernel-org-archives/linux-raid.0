From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: data recovery on raid5
Date: Sat, 22 Apr 2006 22:51:37 +0200
Message-ID: <62b0912f0604221351l40aa3c62w7ff094280c98eb1f@mail.gmail.com>
References: <444A7C99.80006@abhost.net>
	 <62b0912f0604221248s653843bfx363f346c7ef31a94@mail.gmail.com>
	 <444A8D04.20809@abhost.net>
	 <62b0912f0604221322k25c96c37q2bee9361a6316c1b@mail.gmail.com>
	 <444A92CF.70401@abhost.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <444A92CF.70401@abhost.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan <jrs@abhost.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jonathan wrote:
> how safe should the following be?
>
> mdadm --assemble /dev/md0 --uuid=8fe1fe85:eeb90460:c525faab:cdaab792
> /dev/etherd/e0.[01234]

You can hardly do --assemble anymore.
After you have recreated superblocks on some of the devices, those are
conceptually part of a different raid array.  At least as seen by MD.

> I am *really* not interested in making my situation worse.

We'll keep going till you got your data back..
Recreating superblocks again on e0.{0,2,3} can't hurt, since you've
already done this and thereby nuked the old superblocks.

You can shake your own hand and thank yourself now (oh, and Sam too)
for posting all the debug output you have.  Otherwise we would
probably never have spotted nor known about the parity/chunk size
differences :o).
