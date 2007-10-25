From: Bill Davidsen <davidsen@tmr.com>
Subject: Multipath and nbd
Date: Thu, 25 Oct 2007 11:08:56 -0400
Message-ID: <4720B188.7050503@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I am at the design stage for a new server. That's when you try to 
convince a client that they have an unfavorable ratio of requirements to 
budget. I am thinking a raid-1, with a mirror to an nbd device running 
write-mostly. I will have redundant network paths to the other machine, 
one via a dedicated cable and P-t-P connection, and the other via a 
switch going to the general internal network.

Am I going into deep waters to try and do something helpful with 
multipath features here, or should I stick to a network only solution, 
and give the switched route a higher metric to force traffic through the 
dedicated link?

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

