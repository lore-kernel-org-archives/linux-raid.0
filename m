From: Ian Pilcher <i.pilcher@comcast.net>
Subject: Measuring RAID-0 CPU load
Date: Mon, 08 Mar 2004 11:15:20 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <404CAA28.6030502@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I need to quantify the additional CPU load that RAID-0 adds (vs. the
boost in I/O performance).  I don't need to do anything fancy;
'dd if=/dev/zero of=/dev/md?" should do the trick, but I'm not sure how
to track the processor utilization during the run.

Any ideas?

Thanks!
-- 
========================================================================
Ian Pilcher                                        i.pilcher@comcast.net
========================================================================

