From: <me@heyjay.com>
Subject: Re: Gigabyte GA-7N400 Pro2 and raid
Date: Thu, 29 Apr 2004 00:48:41 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <000d01c42dad$a2073530$6705a8c0@a30>
References: <000901c42da1$bdbc8610$6705a8c0@a30> <200404290638.44608.dhill@cricalix.net>
Reply-To: <me@heyjay.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Duncan Hill <dhill@cricalix.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Duncan,

It is ITE 8212 (I'm not sure if it is an "F" though).  The driver for RedHat
and Mandrake are available on giga-byte.com.  When you say I'm out of luck,
what exactly does that mean?

- I have to wait until linux boots before I can see those drives as plain
old IDE drives (which means I can boot off those drives)
- I have to wait until the kernel is loaded (and subsequently the raid
driver) in order to see the raid device (ie. after I've configured a raid
device during the bios raid config util)?
- I'll never be able to see those drives regardless if they are raid or
plain?
- Maybe something completely different

Thanks
Jay
----- Original Message ----- 
From: "Duncan Hill" <dhill@cricalix.net>
To: <me@heyjay.com>
Sent: Thursday, April 29, 2004 12:38 AM
Subject: Re: Gigabyte GA-7N400 Pro2 and raid


> On Thursday 29 April 2004 05:19, me@heyjay.com wrote:
> > This is sorta a pre-software-raid question.
> >
> > I just bought and built a box around the Gigabyte GA-7N400 Pro2 Mobo.
It
> > has 4 IDE ports, 2 normal, and 2 upon a raid controller.  I figured I
could
> > avoid using Gigabyte's raid, and do software raid upon the 2 extra
ports.
>
> If the chipset is the ITE 8212F, you're probably up a creek.  However,
> www.ite.com.tw do have a driver you can download - I have an exact URL if
> their site doesn't work for you.
>
>

