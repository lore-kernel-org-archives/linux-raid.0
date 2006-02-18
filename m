From: Jeff Hardy <hardyjm@potsdam.edu>
Subject: component devices too large
Date: Sat, 18 Feb 2006 16:28:21 -0500
Message-ID: <1140298102.2932.23.camel@fritzdesk.potsdam.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm running 2.6.14.6 with CONFIG_LBD yes, with access to some pretty
large AoE block devices.  When I try to create a RAID1 between a couple
of block devices larger than 4TB, mdadm complains with:

mdadm: devices too large for RAID level 1

As long as I back the size down to 4TB or less, it will work.  This is a
bit confusing, because I searched through the archives and did not find
much mention of max RAID size limits except for this about a 2TB maximum
size for RAID5 component devices:

http://marc.theaimsgroup.com/?l=linux-raid&m=112782802028969&w=2

Mdadm (1.11.0 and newer) does this maximum size check for anything
higher than RAID level 0, so I would assume RAID1 and RAID5 would be the
same.

Apologies if this is obvious but: what is the current actual size limit
for component devices in RAID levels greater than zero?


-- 
Jeff Hardy
Systems Analyst
hardyjm at potsdam dot edu

