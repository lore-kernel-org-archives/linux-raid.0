From: Robert L Mathews <lists@tigertech.com>
Subject: Re: Why are reads not balanced across my RAID-1?
Date: Sat, 25 Jan 2014 09:52:44 -0800
Message-ID: <52E3F9EC.3000901@tigertech.com>
References: <20140124104757.8256.qmail@science.horizon.com>	<20140124120448.GA19163@www5.open-std.org>	<CAJvUf-BfK-CeLFZ3WmRFbSpjr_x8x1FO7pDX5gmAJyw2RpekxA@mail.gmail.com>	<20140124174904.GA6884@www5.open-std.org> <CAH3kUhGA8x_5hDbqxcskHQq+5YXFrz4XspmzeTq0O8dQci8zzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH3kUhGA8x_5hDbqxcskHQq+5YXFrz4XspmzeTq0O8dQci8zzw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1/24/14, 10:22 AM, Roberto Spadim wrote:

> i don't know there's space to improvement here, i got 1% of speed up
> doing a mix of disk speed (7.2k rpm 5k rpm and 15k rpm and a ssd) and
> changing the read balance algorithm

If your RAID1 array contains both spinning disks and SSDs, you can (and
should) simply set the spinning disks as "write-mostly":

 http://tansi.info/hybrid/

This causes all reads to come from the SSD if possible.

After doing this, all reads should be at the SSD speed, although all
writes will still be at spinning disk speeds. We have been doing this on
all our database servers for years with zero problems (although we
finally now trust SSDs enough to switch all array members to SSDs, so
we're phasing it out).

If your workload consists of lots of scattered reads, you'll get far
more than a 1% read performance increase from this, with no tweaking of
read balancing algorithm necessary.

-- 
Robert L Mathews, Tiger Technologies, http://www.tigertech.net/
