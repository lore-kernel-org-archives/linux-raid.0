From: Neil Brown <neilb@suse.de>
Subject: Re: raid 5 mismatch_cnt errors
Date: Fri, 21 May 2010 07:16:45 +1000
Message-ID: <20100521071645.497cdcad@notabene.brown>
References: <4BF56B1F.9080205@locallinux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BF56B1F.9080205@locallinux.com>
Sender: linux-raid-owner@vger.kernel.org
To: Trey Scarborough <treys@locallinux.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 20 May 2010 12:02:23 -0500
Trey Scarborough <treys@locallinux.com> wrote:

> I have a raid 5 array with 9 disks and I have a mismatch_cnt that keeps 
> growing. This is causing file corruption on the underlaying file systems 
> as well.  I can copy a group of 100 100mb files and then do a md5sum on 
> them and 1-3 will be corrupt. If this is a drive that is bad is there 
> anyway to run a report on the count per drive that these mismatches 
> occur. I have run smarttools test and do not see one drive that stands 
> out to be causing errors. Could something else be causing these errors?


When RAID5 detects an inconsistency there is no way to know which device was
wrong.
SMART only detects some errors, not all.
I have had hard drives before which appears to have a single-bit error in
their internal buffer.  No error would be reported, but data you read would
sometimes be wrong.
RAID5 cannot help you with this sort of error.

I would suggest backing up all your data (if it isn't already to late),
breaking the array, and testing each device individually.
e.g. create a filesystem on the device and try copying data on and reading it
off.

NeilBrown
