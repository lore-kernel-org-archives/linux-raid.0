From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: libata
Date: Sun, 15 Feb 2004 15:34:18 -0500
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <402FD7CA.8080900@pobox.com>
References: <402F2A22.8080204@wasp.net.au> <1076833840.28006.3.camel@stoneburner.xwredwing.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1076833840.28006.3.camel@stoneburner.xwredwing.net>
To: Matt Thrailkill <xwred1@modestolan.com>, Brad Campbell <brad@wasp.net.au>
Cc: linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

Matt Thrailkill wrote:
> This is the same card I've got in my box, the one I happened to trip a
> hpt366 driver bug with that I mention in my other mailing.
> 
> Does the Highpoint driver do hotswap and all that goodness?  My
> understanding is that the 1540 card is just a hpt374 with pata->sata
> converters soldered on, rather than a "true" sata controller.

If that's true, and it provides no SATA-specific features (there are 
SATA-specific phy registers you need to talk to, to do hotplug and other 
fun) then it would be better to do it under the auspices of the "old IDE 
driver" a.k.a. CONFIG_IDE.


> I think for a short time I tried doing some simple hotswapping in
> Windows and it didn't work, does that (or any hotswapping) work for you?
> 
> The e.sata ports on the back of the card is just begging for hotswap
> support.
> 
> Linux-ide.org is where the libsata work is at, I think.  Do they have a
> dedicated list?

Nope, libata was independent of linux-ide.org.  (I am the author)

linux-ide@vger.kernel.org or linux-scsi@vger.kernel.org seem to host the 
most libata discussions.

Feel free to ask me questions about the API.  There are API docs 
generated from the source code, posted here: 
http://www.kernel.org/pub/linux/kernel/people/jgarzik/libata/

	Jeff




