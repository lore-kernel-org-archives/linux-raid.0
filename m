From: hpa@zytor.com (H. Peter Anvin)
Subject: Re: Forcing a more random uuid (random seed bug)
Date: Tue, 22 Feb 2005 23:58:06 +0000 (UTC)
Message-ID: <cvggue$73n$1@terminus.zytor.com>
References: <20050208140538.12557.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Followup to:  <20050208140538.12557.qmail@science.horizon.com>
By author:    linux@horizon.com
In newsgroup: linux.dev.raid
>
> +        if ((my_fd = open("/dev/random", O_RDONLY)) != -1) {
> 
> Please use /dev/urandom for such applications.  /dev/random is the
> highest-quality generator, but will block if entropy isn't available.
> /dev/urandom provides the best available, immediately, which is what
> this application wants.

Not 100% clear; the best would be to make it configurable.

Either way you must not use read() in the way described.  Short reads
happen, even with /dev/urandom.
 
> Also, this will only produce 2^32 possible UUIDs, since that's the
> size of the seed.  Meaning that after you've generated 2^16 of them,
> the chances are excellent that they're not UU any more.
> 
> You might just want to get all 128 (minus epsilon) bits from /dev/urandom
> directly.

You *do* want to get all bits from /dev/urandom directly.

	-hpa
