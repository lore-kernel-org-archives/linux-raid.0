From: Trey Scarborough <trey@treyworld.com>
Subject: raid 5 mismatch_cnt errors
Date: Thu, 20 May 2010 11:58:48 -0500
Message-ID: <4BF56A48.4080507@treyworld.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a raid 5 array with 9 disks and I have a mismatch_cnt that keeps 
growing. This is causing file corruption on the underlaying file systems 
as well.  I can copy a group of 100 100mb files and then do a md5sum on 
them and 1-3 will be corrupt. If this is a drive that is bad is there 
anyway to run a report on the count per drive that these mismatches 
occur. I have run smarttools test and do not see one drive that stands 
out to be causing errors. Could something else be causing these errors?


