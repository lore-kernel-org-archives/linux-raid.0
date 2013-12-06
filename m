From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: RAID-0/5/6 performances
Date: Fri, 6 Dec 2013 19:13:30 +0100
Message-ID: <20131206181330.GA4161@lazy.lzy>
References: <20131205192454.GA5695@lazy.lzy>
 <52A197C2.1090805@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52A197C2.1090805@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Dec 06, 2013 at 03:24:18AM -0600, Stan Hoeppner wrote:
> On 12/5/2013 1:24 PM, Piergiorgio Sartor wrote:
> 
> > The "stripe_cache_size" was set to the max 32768.
> 
> You don't want to set this so high.  Doing this will:
> 
> 1.  Usually decrease throughput
> 2.  Eat a huge amount of memory.  With 5 drives:
> 
>     ((32768*4096)*5)/1048576 = 640 MB RAM consumed for the stripe buffer
> 
> For 5 or fewer pieces of spinning rust a value of 2048 or less should be
> sufficient.  Test 512, 1024, 2048, 4096, and 8192.  You should see your
> throughput go up and then back down.  Find the sweet spot and use that
> value.  If two of these yield throughput within 5% of one another, use
> the lower value as it eats less RAM.

Hi Stan,

thanks for the reply, I was looking forward to it,
since you always provide useful information.

I checked two systems, one, different, with RAID-5,
the other the actual RAID-6.

In the first one, 2048 seems to be the best stripe
cache size, while more results in slower writing
speed, albeit not too much.

For the RAID-6, it seems 32768 is the best value.

There is one difference, the RAID-5 has chunk size
of 512k (default), while the RAID-6 has still the 64k.

BTW, why is that? I mean why large stripe cache
results in lower writing speed?

Thanks,

bye,

-- 

piergiorgio
