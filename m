From: AndyLiebman@aol.com
Subject: Automatic Recovery Program?
Date: Fri, 23 Apr 2004 12:55:16 EDT
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <190.28ac9dc5.2dbaa474@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Does anybody know of a program that will: 
-- analyze linux RAID arrays (in my case, RAID 5 arrays) and figure out 
whether all drives are active or whether some drives have been set as faulty and 
removed;
-- if one or more drives are faulty and removed, automatically perform a 
reasonable diagnostic test on the missing drives to see if they are physically 
okay;
-- if the drives are okay, hot add the drives back into the appropriate 
array(s) and initiate recovery.

BTW, I'm talking about doing this under the 2.6 kernel. 

If such a program exists -- call it an "automatic recovery program" -- I 
would sure like to know about it. If not, I am considering writing such a program 
and would appreciate your input into what it should do. 

I am thinking about creating a very basic program that will assist 
non-technical Linux users in being able to check the status of RAID 5 arrays on their 
machines and, in the event a drive has been removed from an array, initiate 
recovery without having to know ANYTHING about mdadm or the inner workings of 
Linux RAID. In other words, make RAID recovery very "user friendly".  

Can software RAID recovery be as simple as what an external Hardware RAID box 
would do? 

Thanks in advance for your comments. 
Andy Liebman
