From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RFC - new raid superblock layout for md driver
Date: Thu, 21 Nov 2002 10:11:43 +1100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <15836.5807.792124.255167@notabene.cse.unsw.edu.au>
References: <15835.2798.613940.614361@notabene.cse.unsw.edu.au>
	<1037801381.3267.17.camel@irongate.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: message from Alan Cox on  November 20
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On  November 20, alan@lxorguk.ukuu.org.uk wrote:
> On Wed, 2002-11-20 at 04:09, Neil Brown wrote:
> >     u32  set_uuid[4]
> 
> Wouldnt u8 for the uuid avoid a lot of endian mess

Probably....
This makes it very similar to 'name'.  
The difference if partly the intent for how user-space would use it,
and partly that set_uuid must *never* change, while you would probably
want name to be allowed to change.


> 
> >     u32  ctime
> 
> Use some padding so you can go to 64bit times
> 
Before or after?  Or just make it 64bits of seconds now?
This brings up endian-ness?  Should I assert 'little-endian' or should
the code check the endianness of the magic number and convert if
necessary?
The former is less code which will be exercised more often, so it is
probably safe.

So:
  All values shall be little-endian and times shall be stored in 64
  bits with the top 20 bits representing microseconds (so we & with
  (1<<44)-1  to get seconds.

Thanks.

NeilBrown
