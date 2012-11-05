From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: is "replaceable" in 3.2 considered stable
Date: Mon, 5 Nov 2012 05:51:18 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1211050546420.13802@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello.

I have an ubuntu 12.04 system, (running ubuntu kernel 3.2), and I have a 
drive I want to swap out that has a lot of offline uncorrectable block on 
my raid6 mdadm-raid with superblock v1.2, the drive is failing.

I remembered Neil announcing the "replaceable" option, and it seems this 
came in 3.2 according to <https://lwn.net/Articles/465048/>.

Has this function as implemented in 3.2 received a lot of testing and can 
be considered safe for production use, or is it still as said in the 
email, for testing only?

My kernel:

3.2.0-32-generic #51-Ubuntu SMP Wed Sep 26 21:33:09 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
