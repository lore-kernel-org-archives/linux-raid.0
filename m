From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: data recovery on raid5
Date: Sat, 22 Apr 2006 22:38:46 +0200
Message-ID: <62b0912f0604221338m6b9fc06do61d78ffa622523bc@mail.gmail.com>
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
> Well, the block sizes are back to 32k now, but I still had no luck
> mounting /dev/md0 once I created the array.

Ahem, I missed something.
Sorry, the 'a' was hard to spot.

Your array used layout : left-asymmetric, while the superblock you've
just created has layout: left-symmetric.

Try again, but add the option "--parity=left-asymmetric"
