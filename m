From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: RFC - new raid superblock layout for md driver
Date: 21 Nov 2002 00:30:52 +0000
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1037838652.3241.108.camel@irongate.swansea.linux.org.uk>
References: <15835.2798.613940.614361@notabene.cse.unsw.edu.au>
	<1037801381.3267.17.camel@irongate.swansea.linux.org.uk>
	<15836.5807.792124.255167@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <15836.5807.792124.255167@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2002-11-20 at 23:11, Neil Brown wrote:
> This brings up endian-ness?  Should I assert 'little-endian' or should
> the code check the endianness of the magic number and convert if
> necessary?
> The former is less code which will be exercised more often, so it is
> probably safe.

From my own experience pick a single endianness otherwise some tool will
always get one endian case wrong on one platform with one word size.

> 
> So:
>   All values shall be little-endian and times shall be stored in 64
>   bits with the top 20 bits representing microseconds (so we & with
>   (1<<44)-1  to get seconds.

Could do - or struct timeval or whatever
