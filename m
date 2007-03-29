From: Neil Brown <neilb@suse.de>
Subject: Re: LILO 22.6.1-9.3 not compatible with SW RAID1 metdata >= 1.0
Date: Thu, 29 Mar 2007 16:33:34 +1000
Message-ID: <17931.23998.484806.368702@notabene.brown>
References: <Pine.LNX.4.64.0703260741270.18194@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Justin Piszcz on Monday March 26
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, johninsd@san.rr.com
List-Id: linux-raid.ids

On Monday March 26, jpiszcz@lucidpixels.com wrote:
> Neil,
> 
> Using: Debian Etch.
> 
> I picked this up via http://anti.teamidiot.de/nei/2006/10/softraid_lilo/ 
> via google cache.  Basically, LILO will not even run correctly if the 
> metadata is not 0.90.  After I had done that, LILO ran successfully for 
> the boot md device, but I still could not boot my system until I made all of
> the root raid array volumes with 0.90 metadata.
> 
> Any chance the LILO guys will fix this so it works with all forms of MD 
> metadata?

I'm not sure why you address this to me.  I don't have any control
over lilo.  I don't even use it any more (not that grub is immensely
better in this area, just different).

I'm surprised that LILO cares about the metadata.  It should just try
to map blocks on a file to blocks on the device.  That obviously needs
to know something about how md works, but the metadata shouldn't be an
issue.
If the filesystem in on an md device, then check that it is raid1 and
reject if not.  If it is, find the underlying devices from
GET_DISK_INFO (they might be partitions or whole devices) and possibly
add the data_offset found in sysfs is the kernel is new enough to have
that entry in sysfs.  Add to that various partition mappings and you
should have a reliable mapping from file-block to device-block,
without needing to know about metadata.

NeilBrown
