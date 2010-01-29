From: Neil Brown <neilb@suse.de>
Subject: Re: woes with... mdadm ?
Date: Fri, 29 Jan 2010 21:42:59 +1100
Message-ID: <20100129214259.27409fd8@notabene>
References: <4B5F6C5D.8020202@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B5F6C5D.8020202@ultratux.net>
Sender: linux-raid-owner@vger.kernel.org
To: Maarten <maarten@ultratux.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 26 Jan 2010 23:27:41 +0100
Maarten <maarten@ultratux.net> wrote:

> Hi Folks,
> 
> I'm having no end of trouble with a freshly built x86_64 system. After 
> reboots checksums are corrupted, I cannot add drives back in, etc. I've 
> downgraded from mdadm 3.0 to 2.6.8 but that doesn't change anything. 
> First of all, maybe I'm missing something obvious. Does anyone spot an 
> error in the following ?
> 

It looks to me like you have a very nasty hardware problem somewhere,
possibly in a sata controller, but I cannot be sure.

You write data out to the disk and read it back in, and find you have
slightly different data.  This is showing up as a wrong checksum.

You results are begin confused by the fact that writes are cached and when
you read you might be reading from the device or you might be reading from
the cache.

I would suggest that you write a known pattern to the device.
Flush all caches
   echo 3 > /proc/sys/vm/drop_caches
then read back and compare.
That should confirm that it is a device problem..

I cannot think of anything else that would explain your symptoms.

NeilBrown
