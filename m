From: Neil Brown <neilb@suse.de>
Subject: Re: Re-arranged Drives in MDADM?
Date: Fri, 29 Jan 2010 20:40:51 +1100
Message-ID: <20100129204051.320d1fa2@notabene>
References: <d80f793f1001281058g60228b6bo7fc001fcfedd4487@mail.gmail.com>
	<20100128213924.GA1664@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100128213924.GA1664@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Hill <robin@robinhill.me.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 28 Jan 2010 21:39:24 +0000
Robin Hill <robin@robinhill.me.uk> wrote:


> If you really want the two swapped (not sure why - any failure will
> cause this to change anyway), you can fail & remove sdd2, then re-add it
> after the recovery to sdc2 has completed.  This won't stop the array
> from running, but does leave you at risk of total failure until the
> rebuild completes.

Or possibly shut down, physically swap the devices, and the start up again.

NeilBrown
