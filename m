From: Christina Braun <braun@mail.informatik.uni-essen.de>
Subject: direction criterium for synchronisation raid1
Date: Tue, 16 Oct 2007 11:28:25 +0200
Message-ID: <47148439.2020706@mail.informatik.uni-essen.de>
Reply-To: braun@dc.uni-due.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,
which is in raid1 the criterion for the direction of synchronisation? In 
case of  disk-replacing
or removing one mirror-leg (working actual on the other leg ) and add 
the same removed leg later, which has the old data now, again to the mirror?

How can I tell the system which mirrored partition is  now the 
data-source without
making the raid1 new or zero the superblock?  Is the  destination in 
every case the device
in mdadm manage after the add ? Can I see the source or destination by a 
info like mdstat or superblock?
 
I cannot find the  answers of this simple questions. It works by 
testing, but I feel better about my production-system and a later 
replace  if I know it. The found examples describes only the replace of  
ascending order second drives.

Thank You,
Christina

