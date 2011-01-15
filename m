From: NeilBrown <neilb@suse.de>
Subject: Re: Question with --assume-clean
Date: Sat, 15 Jan 2011 15:48:05 +1100
Message-ID: <20110115154805.6e1b1f5a@notabene.brown>
References: <alpine.DEB.2.00.1101142049080.18350@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1101142049080.18350@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 14 Jan 2011 20:49:52 -0500 (EST) Justin Piszcz
<jpiszcz@lucidpixels.com> wrote:

> Hi,
> 
> If I use --assume-clean and then run a check, will this perform the 
> initialization when using a RAID-1/RAID-6?
> 

No - check doesn't write anything.

But if you use --assume-clean then run a 'repair', it will perform the
initialisation that --assume-clean deliberately avoided.

NeilBrown
