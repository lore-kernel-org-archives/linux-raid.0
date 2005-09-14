From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: Implementing Encryption and Decryption in Raid Device Driver.
Date: Wed, 14 Sep 2005 19:37:08 +0000
Message-ID: <62b0912f050914123756d1f3d@mail.gmail.com>
References: <20050914080425.GA11729@percy.comedia.it>
	 <20050914101640.46658.qmail@web54713.mail.yahoo.com>
Reply-To: molle.bestefich@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050914101640.46658.qmail@web54713.mail.yahoo.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: vinnakota chaitanya <chaitanyaa_v@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

vinnakota chaitanya wrote:
> Actually I forgot to mention the kernel I'am working
> on, it is Montavista Kernel 2.4.19. In 2.4.19 there is
> not support for dm_crypt i.e CONFIG_DM_CRYPT.

Use loop-aes, it's absolutely fabulous.

It works great with 2.4 as well as 2.6.

Instructions here.
http://loop-aes.sourceforge.net/loop-AES.README
