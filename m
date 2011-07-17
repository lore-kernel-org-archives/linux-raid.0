From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: standard performance (write speed 20Mb/s)
Date: Sun, 17 Jul 2011 18:03:09 -0500
Message-ID: <4E236A2D.3070307@hardwarefreak.com>
References: <201107162140.58883.raid1@fuckaround.org>    <4E226464.2030200@hardwarefreak.com> <ac6850f9420970de26472b6a9dcc2a82.squirrel@fuckaround.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ac6850f9420970de26472b6a9dcc2a82.squirrel@fuckaround.org>
Sender: linux-raid-owner@vger.kernel.org
To: Pol Hallen <raid1@fuckaround.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 7/17/2011 3:12 AM, Pol Hallen wrote:
> hello and thanks for the reply :-)
> 
> dd if=/dev/zero of=test bs=4096 count=262144
> 262144+0 records in
> 262144+0 records out
> 1073741824 bytes (1.1 GB) copied, 31.3475 s, 34.3 MB/s
> 
> I've 8Gb ddr3 of ram

Then you have multiple problems causing poor performance.  Now is the
time for you to post your  hardware configuration, drive model
number(s), mdadm config, and filesystem.  You should have done all of
this in your initial post.

You've been on this list long enough to have known of the WD Green
sector alignment issue and avoided it, and to know better than to run
performance tests while an array is still in its initial sync.  Thus I
initially assumed your problem was merely the insane dd block size.

-- 
Stan
