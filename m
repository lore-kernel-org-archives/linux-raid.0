From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Wrong device name after hot-swap
Date: Sat, 23 Jan 2016 14:45:56 +0000
Message-ID: <56A39224.403@youngman.org.uk>
References: <n7u8gr$1bv$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <n7u8gr$1bv$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Paul van der Vlis <paul@vandervlis.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22/01/16 21:55, Paul van der Vlis wrote:
> Hello,
> 
> I want to put bigger disks into my server. What I want to do is replace
> the first disk, rebuild the raid, replace the second disk, rebuild the
> raid. The machine has two disks, sda and sdb.

Have you only got two slots?
> 
> But, when I replace a disk, it gets a new device name. E.g. /dev/sdb
> becomes /dev/sdc. After a reboot it's good again, but I prefer not to
> reboot this machine!

Sounds like you're pulling a drive then replacing it. Can't you replace
it then pull?

That'll mean that when the array is at its most vulnerable, ie it's
rebuilding, you'll have three drives on line not one.

How new is your mdadm? You'll need one that supports the "--replace" syntax.

Cheers,
Wol
