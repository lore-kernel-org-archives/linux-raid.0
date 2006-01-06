From: Francois Barre <francois.barre@gmail.com>
Subject: Re: Fwd: Linux MD raid5 and reiser4... Any experience ?
Date: Fri, 6 Jan 2006 11:50:25 +0100
Message-ID: <fd8d0180601060250te7a07c7s@mail.gmail.com>
References: <fd8d0180601050104x15079396h@mail.gmail.com>
	 <fd8d0180601050106s5f5b4306o@mail.gmail.com>
	 <87oe2r2d93.fsf@rimspace.net>
	 <fd8d0180601050321k19f12f53r@mail.gmail.com>
	 <43BE3C99.4050706@ieee.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43BE3C99.4050706@ieee.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>  AFAIK, ext3 volume cannot be bigger than 4TB on a 32 bits system.
> I think it is important you know that in case it could be a concern
> for you.

What ? What ? .... What ?
<dased_and_confused>Are you sure ? I may search for it more
extensively... Anyway, the total size cannot be more than sizeof(block
size) * block size, and with 32bits systems and 4k pages, that makes
16TB. Are you sure ?</dased_and_confused>

>  XFS is finally much faster than EXT3 and self-defragmenting, but
> that was not a concern for you anyway.

Well, I'm currently looking at this solution... Never used XFS before,
but I always been tought of it for as a good thing...
