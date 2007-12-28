From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: raid5 grow reshaping speed is unchangeable
Date: Fri, 28 Dec 2007 16:13:23 +1300
Message-ID: <477469D3.2030202@sauce.co.nz>
References: <380-220071242752242883@mochamail.com> <47744926.6010808@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47744926.6010808@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> Cody Yellan wrote:
>> I had a 4x500GB SATA2 array, md0.  I added one 500GB drive and
>> reshaping began at ~2500K/sec.  Changing
>> /proc/sys/dev/raid/speed_limit_m{in,ax} or
>> /sys/block/md0/md/sync_speed_m{in,ax} had no effect.  I shut down all
>> unnecessary services and the array is offline (not mounted).  I have
>> read that the throttling code is "fragile" (esp. with regard to
>> raid5) but does this make sense?  I will wait (in)patiently for it to
>> finish, but I do wonder why the configuration parameters have no
>> effect.  This is a dual quad 2GHz Xeon machine with 8GB of memory
>> running RHEL5.  Is this the maximum speed?

Are you running a non-standard /sys/block/md5/md/stripe_cache_size?

I found when running a kernel of about that vintage on FC6 (which I 
guess became RHEL5), that with a stripe_cache_size of 16384, resyncs 
dropped down to about the speed you are seeing.

This changed back to more normal speeds with a later kernel, but I do 
not recall which.

Regards,

Richard
