From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Very long raid5 init/rebuild times
Date: Wed, 22 Jan 2014 20:37:49 -0600
Message-ID: <52E0807D.2030608@hardwarefreak.com>
References: <20140121073540.GF10140@merlins.org> <20140121163755.GG10140@merlins.org> <52DF7976.6070808@hardwarefreak.com> <20140122174854.GF26014@merlins.org>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140122174854.GF26014@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/22/2014 11:48 AM, Marc MERLIN wrote:
...
> If crypt is on top of raid5, it seems (and that makes sense) that no
> encryption is neded for the rebuild. However in my test I can confirm that
> the rebuild time is exactly the same. I only get 19MB/s of rebuild bandwidth
> and I think tha'ts because of the port multiplier.

I didn't address this earlier as I assumed you, and anyone else reading
this thread, would do a little background reading and realize no SATA
PMP would behave in this manner.  No SATA PMP, not Silicon Image, not
Marvell, none of them, will limit host port throughput to 20MB/s.  All
of them achieve pretty close to wire speed throughput.

-- 
Stan
