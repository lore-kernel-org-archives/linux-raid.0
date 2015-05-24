From: Brad Campbell <brad@fnarfbargle.com>
Subject: Re: Fwd: Installing Linux directly onto RAID6 Array...........
Date: Sun, 24 May 2015 21:48:09 +0800
Message-ID: <5561D699.80403@fnarfbargle.com>
References: <CAOS+5GFwGJouUfZ_RWhtRVXw7wnoP1Ry4doHTJmkruFoccmqRg@mail.gmail.com> <555294A0.6040703@websitemanagers.com.au> <CAOS+5GEP6+7OAHkqQjeyGHAB5u-_-Vq2JWGpcOemYHdCjmR5Lg@mail.gmail.com> <CAOS+5GHKwQRPfNAw0EpSjjDUt=9PmjjrkUg+dhGxFS+uOWWVug@mail.gmail.com> <alpine.DEB.2.02.1505241032210.9487@uplift.swm.pp.se> <5561B237.4040709@youngman.org.uk> <5561BCA4.4060904@fnarfbargle.com> <5561C6E9.3060706@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5561C6E9.3060706@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Mikael Abrahamsson <swmike@swm.pp.se>, Another Sillyname <anothersname@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 24/05/15 20:41, Wols Lists wrote:

> aiui raid won't help you at all here, will it?

Of course it will.

> Firstly, if you get write failures, the hard drive should swap the
> block, or the write layer should swap it. Nothing to do with raid
> whatsoever.

Yep..

> And if you get read errors, well, aiui, raid won't help here either -
> especially with mirrored raid, you just get a read failure. Raid does
> NOT give you error recovery unless the drive physically fails, and if
> it's a bad block it gets fixed at the disk or disk driver level - well
> below the raid driver.

Nope. If you get a read failure it will try and pull from another 
mirror, and *that* will succeed. Drives don't return dud* data. They 
either succeed or fail.

* Of course I've heard anecdotes from people about that happening, but 
it's not supposed to happen under *any* circumstances.

-- 
Dolphins are so intelligent that within a few weeks they can
train Americans to stand at the edge of the pool and throw them
fish.
