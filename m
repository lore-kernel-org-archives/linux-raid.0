From: AndyLiebman@aol.com
Subject: RAID 10 and Persistent Superblock
Date: Fri, 31 Oct 2003 10:23:08 EST
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <c6.2446066e.2cd3d85c@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

A "simple" question regarding RAID 10. When I make a RAID 0 on top of three 
RAID 1 arrays, should I use "persistent superblock = 1" in that top level 
array? Won't that confuse the RAID software by putting two different UUIDs on the 
drives -- one for the RAID 1 arrays and one for the RAID 0 array? 

As long as I have UUIDs for the three lower level RAID 1 arrays, I should be 
able to start those arrays with mdadm even if my device ids change. 

Then shouldn't I be able to start the top level array without a UUID -- just 
by referring to the mdX numbers? In other words, if md0, md1, md2 start, there 
shouldn't be any confusion about which are the correct devices to start up 
md3. Or am I missing something?

Appreciate your answers. 

Andy Liebman
