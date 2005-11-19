From: Neil Brown <neilb@suse.de>
Subject: Re: no reconstruction in 2.6.14.2?
Date: Sun, 20 Nov 2005 09:22:17 +1100
Message-ID: <17279.42393.361867.525681@cse.unsw.edu.au>
References: <17279.33939.476421.616066@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Carlos Carvalho on Saturday November 19
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Carvalho <carlos@fisica.ufpr.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday November 19, carlos@fisica.ufpr.br wrote:
> I've just installed a new server with a 5-disk raid5 and kernel
> 2.6.14.2. To check something I did a hard reset without shutdown and
> on reboot the machine didn't do any automatic resync; all arrays are
> shown clean.
> 
> Is this some automatic intent-logging or another 2.6 feature (the
> machine had been really idle for minutes before the reset)??? This is
> my first 2.6 raid5 and with 2.4 resync does happen...

You could put it this way:
  2.6 has a default 'intend log' of 1 bit that covers the whole
  array.  Before writing, it sets the bit.  20msecs after there has
  been no write activity, it clears the bit.

This bit is always known as the 'dirty' or 'active' bit.

(When you have full bitmap intent logging, each bit covers much less
space, and the timeout for clearing bits is about 10seconds (by
default) rather than 20msecs)

NeilBrown
