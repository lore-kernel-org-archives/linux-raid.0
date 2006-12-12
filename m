From: Bill Davidsen <davidsen@tmr.com>
Subject: Relabeling UUID
Date: Tue, 12 Dec 2006 18:30:53 -0500
Message-ID: <457F3BAD.6060206@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I needed to move an array to other drives, and because of the way the 
array is used, want to keep the UUID on the new array. It doesn't appear 
that uuid= works with create (why?), or that stopping the array and then 
using assemble with uuid= will renumber the array in the superblock.

What's the correct way to do this, or is it broken? And why can't I 
specify uuid= in create?

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

