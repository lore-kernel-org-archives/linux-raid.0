From: Joseph Curran <jacurran@uwm.edu>
Subject: turning off persistent superblocks in raidtab
Date: Fri, 13 Feb 2004 16:57:42 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <402D5666.7070202@uwm.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org, admins@gravity.phys.uwm.edu
List-Id: linux-raid.ids

  We have a raid0 striped across 4 devices.  It was created with 
persistent superblocks.  If in /etc/raidtab I then turn off persistent 
superblocks, should/will the md device use the superblocks on the 
partitions if it finds them, even though /etc/raidtab says non 
persistent superblocks?

Hoping for a quick response, I will be looking at raid0run source for an 
answer in the meantime.

Thanks in advance.
Joe

-- 
====================================================
Joseph A. Curran
NetWork Administrator
University of Wisconsin - Milwaukee
Office:  414.229.4519
Cell: 414.333.1279

Career Development Center -  http://www.cdc.uwm.edu
UWM LSC Group - http://www.lsc-group.phys.uwm.edu
==================================================== 


