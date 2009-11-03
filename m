From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: unbelievably bad performance: 2.6.27.37 and raid6
Date: Mon, 2 Nov 2009 22:46:03 -0800
Message-ID: <4877c76c0911022246m78736f5co412530c456031139@mail.gmail.com>
References: <cccedfc60910310855l5ca6c42aj503fb0e4fd6232ad@mail.gmail.com>
	 <4AEEF29C.10309@tmr.com>
	 <cccedfc60911020703s3188ebcsac867922f937bb39@mail.gmail.com>
	 <9e52db7bed791d8c8f5653b1958b1874.squirrel@neil.brown.name>
	 <4877c76c0911022209g60e40364i2cb82909e31f707d@mail.gmail.com>
	 <763d89fcf9c0164cbe8b6245dc3d2d7f.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <763d89fcf9c0164cbe8b6245dc3d2d7f.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Jon Nelson <jnelson-linux-raid@jamponi.net>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> It is possible to get it fast than it is by increasing the
> array's stripe_cache_size and also increasing the 'backup' size
> that mdadm uses. =A0mdadm-3.1.1 will try to do better in this respect=
=2E
> However it will still be significantly slower than e.g. a resync.
>
> NeilBrown
>

Sorry, one more Q: I was able to find strip_cache_size, and already
asked about stripe_cache_active (and if setting it to 1 was safe); but
I can't seem to even find the 'backup' size variable mentioned
anywhere.  I'm going to start looking at the code next, but is it
supposed to be in documentation?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
