From: John Adams <johna@onevista.com>
Subject: Re: RFC - new raid superblock layout for md driver
Date: Wed, 20 Nov 2002 19:10:17 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200211210010.TAA16071@onevista.com>
References: <15835.2798.613940.614361@notabene.cse.unsw.edu.au> <15836.5807.792124.255167@notabene.cse.unsw.edu.au> <1037838652.3241.108.camel@irongate.swansea.linux.org.uk>
Reply-To: johna@onevista.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1037838652.3241.108.camel@irongate.swansea.linux.org.uk>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday 20 November 2002 07:30 pm, Alan Cox wrote:
> On Wed, 2002-11-20 at 23:11, Neil Brown wrote:
> > This brings up endian-ness?  Should I assert 'little-endian' or should
> > the code check the endianness of the magic number and convert if
> > necessary?
> > The former is less code which will be exercised more often, so it is
> > probably safe.
>
> From my own experience pick a single endianness otherwise some tool will
> always get one endian case wrong on one platform with one word size.
>
Use network byte order. hton[sl] macros already exist.
