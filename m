From: Neil Brown <neilb@suse.de>
Subject: Re: Reading takes 100% precedence over writes for mdadm+raid5?
Date: Mon, 3 Dec 2007 10:18:52 +1100
Message-ID: <18259.15708.870492.17273@notabene.brown>
References: <Pine.LNX.4.64.0712021807260.10289@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Justin Piszcz on Sunday December 2
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday December 2, jpiszcz@lucidpixels.com wrote:
> 
> Was curious if when running 10 DD's (which are writing to the RAID 5) 
> fine, no issues, suddenly all go into D-state and let the read/give it 
> 100% priority?

So are you saying that the writes completely stalled while the read
was progressing?  How exactly did you measure that?

What kernel version are you running.

> 
> Is this normal?

It shouldn't be.

NeilBrown
