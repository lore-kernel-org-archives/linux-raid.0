From: Richard Ray <rray@mstc.state.ms.us>
Subject: how to pick good data when mismatch_count shows failure
Date: Mon, 14 Jun 2010 09:31:44 -0500 (CDT)
Message-ID: <alpine.LRH.2.00.1006140923220.13822@rray.drdc.mstc.ms.gov>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From /etc/sysconfig/raid-check

This allows the sysadmin to inspect the data in the sector
and the data that would be produced by rebuilding the
sector from redundant information and pick the correct
data to keep.

In the case that mismatch_count is not 0 how would I go about 'picking' 
the correct data. If possible please point me to documentation and/or 
tools
Using CentOS 5.5 and ext3 fs

Thanks
Richard
