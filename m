From: Wayne Gemmell <wayne@flashmedia.co.za>
Subject: Wierd critical node problem
Date: Tue, 10 Jun 2008 09:24:48 +0200
Message-ID: <200806100924.48763.wayne@flashmedia.co.za>
Reply-To: wayne@flashmedia.co.za
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all

I run a 4 disk array with 6 RAID 1 partitions. This is a very simple 
configurations which has served me well through multiple drive failures. I 
now have a wierd problem. One of the disks has become a critical node. My 
server does not boot without this disk no matter which disk is my primary 
boot disk (bios). I've changed the order of the disks and it makes no 
difference. 

When this disk is not in booting from some of the other disks gives me a 
warning that there is an invalid superblock magic on sda. They all end up 
with an error on stdin and modprobe failing.


Any ideas how to resolve this? I'm leaning towards nukeing sd[acd] and 
re-adding them.


-- 
Regards
Wayne
