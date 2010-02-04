From: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Subject: Re: problem changing raid level with Ubuntu 10.04 / 2.6.32 / mdadm
	3.1.1
Date: Thu, 4 Feb 2010 08:31:53 +0000
Message-ID: <73e903671002040031ra853431mf34654b70b28bac9@mail.gmail.com>
References: <alpine.DEB.1.10.1002031944020.31777@uplift.swm.pp.se>
	<alpine.DEB.1.10.1002032009410.31777@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1002032009410.31777@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>
List-Id: linux-raid.ids

On Wed, Feb 3, 2010 at 7:12 PM, Mikael Abrahamsson <swmike@swm.pp.se> wrote:
>
> Any reason this doesn't work with a bitmap, and if it doesn't, then perhaps
> this should be documented somewhere or at least mdadm should throw an error
> message?

Hi, I just wanted to say 'me too' ... I was doing a similar reshape and indeed
the bitmap stopped me. I only figured it out because I came across a random
blog post somewhere saying "turn off the bitmap first".

So as not to just spam the list with me-toos, this is another verification that
A) the reshaping works super, and B) it needs some assorted printf()s.

-- Kristleifur
