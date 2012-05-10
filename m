From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: thanks md raid
Date: Thu, 10 May 2012 16:49:13 -0500
Message-ID: <4FAC37D9.6040403@hardwarefreak.com>
References: <4FAC0ED2.2000201@pocock.com.au>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FAC0ED2.2000201@pocock.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Pocock <daniel@pocock.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/10/2012 1:54 PM, Daniel Pocock wrote:
> 
> I'm glad my RAID1 worked as expected... just hoping I don't encounter
> any read timeouts on the non-TLER drive before my rebuild finishes:

You have an inverse understanding of ERC.  Drives without ERC will retry
forever, or until an upper layer puts a stop to its efforts.  Drives
with a 7 second ERC will return a hard error after 7 seconds.

So the only way you'll get a timeout with your rebuild is if the healthy
drive spends 30 seconds retying a sector read.

-- 
Stan
