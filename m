From: linux@horizon.com
Subject: Re: Forcing a more random uuid (random seed bug)
Date: 8 Feb 2005 14:05:38 -0000
Message-ID: <20050208140538.12557.qmail@science.horizon.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, niccolo@texnet.it
List-Id: linux-raid.ids

+        if ((my_fd = open("/dev/random", O_RDONLY)) != -1) {

Please use /dev/urandom for such applications.  /dev/random is the
highest-quality generator, but will block if entropy isn't available.
/dev/urandom provides the best available, immediately, which is what
this application wants.

Also, this will only produce 2^32 possible UUIDs, since that's the
size of the seed.  Meaning that after you've generated 2^16 of them,
the chances are excellent that they're not UU any more.

You might just want to get all 128 (minus epsilon) bits from /dev/urandom
directly.
