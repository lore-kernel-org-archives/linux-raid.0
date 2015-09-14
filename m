From: Shaohua Li <shli@fb.com>
Subject: Re: raid5-cache I/O path improvements V2
Date: Mon, 14 Sep 2015 19:11:22 +0000
Message-ID: <D21C6812.74CB%shli@fb.com>
References: <1442038638-6947-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1442038638-6947-1-git-send-email-hch@lst.de>
Content-Language: en-US
Content-ID: <77E12A3A7CA9624BBD5B5DEB67BA1F4D@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "neilb@suse.de" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>
List-Id: linux-raid.ids



On 9/11/15, 11:17 PM, "Christoph Hellwig" <hch@lst.de> wrote:

>Hi Shaohua, hi Neil,
>
>this series contains a few updates to the raid5-cache feature.
>
>The first patch just ports it to the post-4.2 block layer.  As part of
>that
>I noticed that it currently doesn't handle I/O errors - fixes for that
>will
>follow.
>
>The second and third patch simplify the I/O unit state machine and reduce
>latency and memory usage for the I/O units.  The remainder are just a
>couple
>of cleanups in this area that I stumbled upon.
>
>Changes since V1:
> - only use REQ_FUA if supported natively by the log device

Hi Christoph,

I finally got some data with a Samsung SSD, which supports fua. Controller
is ahci.
Test is a simple fio with all full stripe write.

libata.fua=0, throughput 247m/s
libata.fua=1, throughput 74m/s

fua is significantly slower. I think we need a sysfs config to enable fua.

Thanks,
Shaohua

