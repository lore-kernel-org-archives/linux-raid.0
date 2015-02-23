From: Christer Solskogen <christer.solskogen@gmail.com>
Subject: Re: Optimal chunk size for RAID5?
Date: Mon, 23 Feb 2015 02:36:18 +0100
Message-ID: <mce06j$i2h$1@ger.gmane.org>
References: <mccemd$8pi$1@ger.gmane.org>	<20150222173047.1ea65d67@natsu>	<CAB-428=7y-KSbCeXo6y6o5Jfzgf-5h6pfYxY+4Z74bqYp=oMUg@mail.gmail.com> <20150223085358.302830d1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150223085358.302830d1@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22.02.2015 22:53, NeilBrown wrote:

> There is no "Optimal" without reference to a particular work load.  Or
> particular hardware.
>

Do you know of such a reference? I mean, some stats that show type of 
workload / chunk size. The only one I've found is the 5 year old 
benchmark that was done ( 
http://louwrentius.com/linux-raid-level-and-chunk-size-the-benchmarks.html) 
- which shows that under benchmarking with dd that 64 is preferred.

-- 
chs


