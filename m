From: Andy Arvai <arvai@scripps.edu>
Subject: building a large/fast server
Date: Wed, 29 Jan 2003 12:12:16 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200301292012.MAA07478@astra.scripps.edu>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm in the process of designing a large server system. The primary
consideration will be i/o performance (block read and write of large
files and maximum i/o's per second) and a filesystem size of 2TB. I'm
planning to go with 2 3ware 7500-8's, 16 Maxtor 4G160J8's (160GB) and
do software raid0 between the 7500-8's (raid5). The filesystem will
either be Reiser or Ext3. Any suggestions for fast dual cpu
motherboards or comments are welcome. Thanks for any information.

Andy

