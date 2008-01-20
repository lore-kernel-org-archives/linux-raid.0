From: Moshe Yudkowsky <moshe@pobox.com>
Subject: Performance of RAID 10 vs. using LVM?
Date: Sun, 20 Jan 2008 14:34:35 -0600
Message-ID: <4793B05B.5060008@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Let's assume that I have 4 drives; they are set up in mirrored pairs as 
RAID 1, and then aggregated together to create a RAID 10 system (RAID 1 
followed by RAID 0). That is, 4 x N disks become a 2N size filesystem.

Question: Is this higher or lower performance than using LVM to 
aggregate the disks?

LVM allows the creation of unitary file system from disparate physical 
drives, and has the advantage that filesystems can be expanded or shrunk 
with ease. I'll be using LVM on top of the RAID 1 or RAID 10 regardless.

Therefore, I can use LVM to create a "1L" system, to coin an acronym. 
This would have the same 2N size, but would be created by LVM instead of 
RAID 0. Is there a performance advantage to using RAID 10 instead of 
RAID 1L? (The other question is whether the hypothetical performance 
advantage of 10 outweighs the flexibility advantage 1L, a question that 
only an individual user can answer... perhaps.)

Comments extremely welcome.

-- 
Moshe Yudkowsky * moshe@pobox.com * www.pobox.com/~moshe
  "The sharpest knives are also the quietest."
    			 -- John M. Ford, _The Final Reflection_
