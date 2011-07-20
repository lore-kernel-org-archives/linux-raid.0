From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: standard performance (write speed 20Mb/s)
Date: Wed, 20 Jul 2011 07:31:35 -0500
Message-ID: <4E26CAA7.8030201@hardwarefreak.com>
References: <201107181403.49563.raid1@fuckaround.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201107181403.49563.raid1@fuckaround.org>
Sender: linux-raid-owner@vger.kernel.org
To: Pol Hallen <raid1@fuckaround.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 7/18/2011 7:03 AM, Pol Hallen wrote:
>> Then you have multiple problems causing poor performance.  Now is the
>> time for you to post your  hardware configuration, drive model
>> number(s), mdadm config, and filesystem.  You should have done all of
>> this in your initial post.
> 
> hello and sorry for the late :-(
> 
> now is a resync in progress, I can't stop it. Try /usr/share/mdadm/checkarray 
> -x md0 but nothing..
> 
> fs is ext3 (done less 10 days ago)
> 
>> You've been on this list long enough to have known of the WD Green
>> sector alignment issue and avoided it, and to know better than to run
>> performance tests while an array is still in its initial sync.  Thus I
>> initially assumed your problem was merely the insane dd block size.
> 
> when I wrote a post there was not resync in progress..
> 
> tell me if you need known other things, thanks

I can't see how.  You dumped the entire system.  Which is probably why
no one has responded until now.  Never provide all this garbage.  It
takes too long to sift through and grab the relevant bits, which is only
this:


> Device Model:     ST31500341AS
> User Capacity:    1,500,301,910,016 bytes

> Device Model:     ST31500341AS
> User Capacity:    1,500,301,910,016 bytes

> Device Model:     ST3500418AS
> User Capacity:    500,107,862,016 bytes

> Device Model:     WDC WD20EARS-00MVWB0
> User Capacity:    2,000,398,934,016 bytes

> Device Model:     WDC WD20EARS-00MVWB0
> User Capacity:    2,000,398,934,016 bytes

This mishmash combo of drives, including two WD Green Advanced Format
drives, is likely the cause of the horrible write performance.  You're
assembling the array from partitions.  The partitions on the WD20EARS
drives are undoubtedly not 4KB sector aligned, causing excessive
read-modify-write cycles.  See:

http://en.wikipedia.org/wiki/Advanced_Format

Repartition the Green drives with proper alignment.  If you still have
issues we'll go from there.  Note:  Having 3 dissimilar drives in an
array is never going to be an optimally performing solution.

-- 
Stan
