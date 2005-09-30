From: Robin Bowes <robin-lists@robinbowes.com>
Subject: Best way to achieve large, expandable, cheap storage?
Date: Fri, 30 Sep 2005 14:20:11 +0100
Message-ID: <dhje16$tmq$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have a business opportunity which would involve a large amount of 
storage, possibly growing to 10TB in the first year, possibly more. This 
would be to store media files - probably mainly .flac or .mp3 files.

Concurrency wouldn't be particularly important as I'd be the only person 
access the storage and I have no need for lightning speed.

It would be nice to be able to start smallish and grow as required, but 
my experience of linux raid to date is that it's not possible to resize 
arrays. (I have a 1TB array built from 6 x 250GB SATA discs on Promise 
SATA150 TX4 controllers).

Can anyone offer recommendations as to the most cost-effective way to 
achieve this sort of storage?

Are there any limitations I might run into using md on Linux?

For example, suppose I get something like this [1] and throw in an 
appropriate mobo/processor etc and 24 x 500 GB SATA discs; would 
md/mdadm be able to create a single 11TB RAID5 partition, ie (23-1) x 
500, with a hot-spare? Would this be a sensible thing to do?

What about file-system limitations, e.g. would ext3/reiser/XFS support 
an 11TB partition?

Would I be better off creating smaller volumes combining them with RAID0?

I'd appreciate any tips/suggestions/advice/pointers to further sources 
of information.

Thanks,

R.
-- 
http://robinbowes.com

If a man speaks in a forest,
and his wife's not there,
is he still wrong?

