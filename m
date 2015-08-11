From: Christian Balzer <chibi@gol.com>
Subject: Re: RAID5 TRIM/DISCARD user land support (fstriim and mkfs)
Date: Tue, 11 Aug 2015 14:20:05 +0900
Message-ID: <20150811142005.5e21eca2@batzmaru.gol.ad.jp>
References: <20150810164657.75bae079@batzmaru.gol.ad.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150810164657.75bae079@batzmaru.gol.ad.jp>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Gotta love talking to oneself.

This seems to be related to discard_granularity, the RAID5s I tested this
with had 32KB or 64KB chunks.
When using 8KB or 4KB chunks the resulting discard_granularity is 64KB or
32KB respectively and at that size all of a sudden mkfs does the
initial discard and fstrim starts working as well.

However this is a pretty slow process, at about 3.5GB/s, whereas a single
of those SSDs can do 12GB/s TRIM.

Christian

On Mon, 10 Aug 2015 16:46:57 +0900 Christian Balzer wrote:

> 
> Hello,
> 
> Debian system, tested both Wheezy and Jessie, thus 3.16 kernel with
> backports.
> 
> 8 SSD RAID5, of course with raid456.devices_handle_discard_safely set to
> 1. I can re-mount it with discard w/o a problem:
> ---
> EXT4-fs (md4): re-mounted. Opts: stripe=112,data=ordered,discard
> ---
> 
> However fstrim whines about "FITRIM ioctl failed: Operation not
> supported" and mkfs.ext4 unsurprisingly doesn't discard things when
> invoked.
> 
> The same HW/OS combo works fine with RAID10.
> 
> When looking at the sysfs entries for that MD device the fact
> that /sys/class/block/md4/queue/discard_zeroes_data is 0 doesn't instill
> me with hope or confidence 
> 
> Now while the SSDs in question (Intel DC S3610s) don't really need TRIM
> really would have liked them to be able to start with a clean slate so to
> speak.
> 
> Any insights?
> 
> Christian


-- 
Christian Balzer        Network/Systems Engineer                
chibi@gol.com   	Global OnLine Japan/Fusion Communications
http://www.gol.com/
