From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID-0/5/6 performances
Date: Fri, 06 Dec 2013 03:24:18 -0600
Message-ID: <52A197C2.1090805@hardwarefreak.com>
References: <20131205192454.GA5695@lazy.lzy>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131205192454.GA5695@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/5/2013 1:24 PM, Piergiorgio Sartor wrote:

> The "stripe_cache_size" was set to the max 32768.

You don't want to set this so high.  Doing this will:

1.  Usually decrease throughput
2.  Eat a huge amount of memory.  With 5 drives:

    ((32768*4096)*5)/1048576 = 640 MB RAM consumed for the stripe buffer

For 5 or fewer pieces of spinning rust a value of 2048 or less should be
sufficient.  Test 512, 1024, 2048, 4096, and 8192.  You should see your
throughput go up and then back down.  Find the sweet spot and use that
value.  If two of these yield throughput within 5% of one another, use
the lower value as it eats less RAM.

-- 
Stan
