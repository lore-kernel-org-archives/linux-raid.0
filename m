From: Darryl Barlow <darrylb@iprimus.com.au>
Subject: Re: Software Raid Autodetection Problem
Date: Wed, 17 Sep 2003 03:04:02 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200309170304.03853.darrylb@iprimus.com.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: neilb@cse.unsw.edu.au
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,

Thanks for your help.  I seem to have solved the problem, but can only 
speculate both as to the problem and the solution.  I updated to kernel 
2.4.22, but it still failed to autodetect properly.  I then dumped raidtools2 
and went to mdadm as per your suggestion.  I then generated an mdadm.conf 
file which I altered to refer to the partitions on the raid consistently by 
their devfs names rather than hde2 and hdg2.  I suspect this may have been 
the problem.  I am not sufficiently informed as to the boot process to tell 
for sure, but suspect that autodetection may have been having problems with 
devfs when the config files referred to the old device names.

Whatever the reason, it is now working.

regards,

Darryl

