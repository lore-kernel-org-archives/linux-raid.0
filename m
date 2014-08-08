From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Add drives and restripe performance
Date: Fri, 08 Aug 2014 11:36:39 +0800
Message-ID: <53E445C7.8030909@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

G'day all,

We don't see a lot of speed/time estimates float past so I thought I'd 
put this out there for anyone contemplating this sort of thing.

I have a RAID 6 now comprised of 14 2TB drives (WD Green and Red).
The drives are connected via 3 LSI SAS2008 controllers and each on a 
single channel. On a good day I can get 7-800Mb/s to or from the array, 
so streaming performance is excellent.

It took approximately a day (+/-) to grow the array from 12 drives to 
14. It has taken approximately 10 days to re-stripe from 128k chunks to 
64k chunks with the backup file on a RAID-10 of SSD's (its not finished 
but I'm about 8 hours away).

Both of these operations were performed with the array as idle as was 
practical (all common users of the array were stopped). Based on the 
grow performance I had banked on about a week for the restripe so I 
wasn't massively far out in my estimation. If the array was under 
regular use then the estimate for the restripe was more like a month.

I had to stop the SMART daemon as the morning run of SMART tests was 
causing the estimate to blow out to a month while the tests were active, 
and the normally 90 minute tests were taking 18 hours.

Still much nicer than a 24TB backup/recreate/restore.
