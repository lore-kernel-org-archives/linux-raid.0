From: Roman Mamedov <rm@romanrm.net>
Subject: Re: performance of raid5 on fast devices
Date: Tue, 17 Jan 2017 10:10:43 +0500
Message-ID: <20170117101043.78e80bdc@natsu>
References: <CA+Dh761_kVPEcRdFEAo72Wif_t-G7RpgyoKGetEFveyMpaYD1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+Dh761_kVPEcRdFEAo72Wif_t-G7RpgyoKGetEFveyMpaYD1w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jake Yao <jgyao1@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 16 Jan 2017 21:35:21 -0500
Jake Yao <jgyao1@gmail.com> wrote:

> I have a raid5 array on 4 NVMe drives, and the performance on the
> array is only marginally better than a single drive. Unlike a similar
> raid5 array on 4 SAS SSD or HDD,  the performance on array is 3x
> better than a single drive, which is expected.
> 
> It looks like when the single kernel thread associated with the raid
> device running at 100%, the array performance hit its peak. This can
> happen easily for fast devices like NVMe.
> 
> This can reproduced by creating a raid5 with 4 ramdisks as well, and
> comparing performance on the array and one ramdisk. Sometimes the
> performance on the array is worse than a single ramdisk.
> 
> The kernel version is 4.9.0-rc3 and mdadm is release 3.4, no write
> journal is configured.
> 
> Is this a known issue?

How do you measure the performance?

Sure it may be CPU-bound in the end, but also why not try the usual
optimization tricks, such as:

  * increase your stripe_cache_size, it's not uncommon that this can speed up
    linear writes by as much as several times;

  * if you meant reads, you could look into read-ahead settings for the array;

  * and in both cases, try experimenting with different stripe sizes (if you
    were using 512K, try with 64K stripes).

-- 
With respect,
Roman
