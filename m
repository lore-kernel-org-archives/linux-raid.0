From: Brad Campbell <brad@wasp.net.au>
Subject: Re: EVMS or md?
Date: Tue, 05 Apr 2005 10:17:00 +0400
Message-ID: <42522D5C.8000500@wasp.net.au>
References: <200504040708.j3478bm03863@www.watkins-home.com> <1112642928.25469.28.camel@dyn95395156> <200504041446.50337.kewley@gps.caltech.edu> <d2seal$ntf$1@terminus.zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d2seal$ntf$1@terminus.zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

H. Peter n wrote:
> No hiccups, data losses, or missing functionality.  At the end of the
> whole ordeal, the filesystem (1 TB, 50% full) was still quite prisine,
> and fsck confirmed this.  I was quite pleased :)

I second this. I endured numerous kernel crashes and other lockup/forced restart issues while 
setting up a 15 drive 3TB raid-6 (Crashes not really realted to the mb subsystem except for the 
oddity in the -mm kernel, and that was not raid-6 specific). I have popped out various drives and 
caused numerous failures/rebuilds with an ext3 system over 90% full while burn in testing and not 
experienced one glitch.
It has been used in production now for over a month and is performing flawlessly. I have run it in 
full/1-disk and 2-disk degraded mode for testing. I certainly consider it stable.

Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
