From: Roy Waldspurger <rlists@frameandfocus.com>
Subject: read-ahead cache on indiv. raid members and entire md device
Date: Tue, 18 Jul 2006 02:33:21 -0700
Message-ID: <44BCAAE1.4070205@frameandfocus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm looking for advice on tuning the read-ahead cache for an md device...

for example, should I merely set the read-ahead for the md device:

blockdev --setra ### /dev/md2

or should I start touching the individual raid member devices:

blockdev --setra ### /dev/sdc1
blockdev --setra ### /dev/sdd1
blockdev --setra ### /dev/sde1, etc.

I'm not sure about the relation between the two caches.

Also, does the read-ahead cache for the entire md device show-up in 
/proc/ or /sys/block/mdX?  I of course find the read-ahead for the 
individual devices under, for example:

/sys/block/sdc/queue/read_ahead_kb

Many thanks in advance.

Cheers,

-- roy


