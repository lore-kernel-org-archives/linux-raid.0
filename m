From: Mitchell Laks <mlaks@post.harvard.edu>
Subject: raid 1 single drive failure. rebuilt with replacement drive.
	missing 20G of data
Date: Wed, 11 Mar 2009 22:10:24 -0400
Message-ID: <20090312021024.GA31067@earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have used linux software raid1 for many years without any data loss. Now I seem to have a problem.

I run a server with a pair of WD 400G drives that I keep in a raid 1 configuration. The raid became degraded
but continued to function and continue to store data on the remaining  drive. 

I simply replaced the faulty drive and rebuilt the raid. All seemed to be   ok,  however now I notice that 20G of data are 
missing from the raid. I see this by comparing to a backup device that I mirror to every night.

Any idea on how can this have happened? These are the most recent 20G of data. Perhaps this is the last 20 G since the 
raid went bad,  however that the data was clearly stored initially - I see it on the backup device I copied to.

Could the data   have been lost in the rebuild process? seems strange. Total of 220G of data on the device at present.

The server is  running debian 4.0 (etch) which runs mdadm-2.5.6-9 (debian). Linux kernel 2.6.18-5-686


Thanks

Mitchell Laks
