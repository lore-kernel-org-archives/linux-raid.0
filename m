From: John Hendrikx <hjohn@xs4all.nl>
Subject: Spinned down raid drives sometimes not recognized anymore
Date: Wed, 04 Jan 2012 13:05:09 +0100
Message-ID: <4F044075.9070809@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a problem with a new server that I haven't encountered before.

I'm trying to have all drives that haven't been accessed for an hour to 
spin down -- this is working fine (and it has been working fine in the 
past on other systems).  However, after running this system for a few 
days I ran into some trouble; it turns out two drives did not become 
available again (I think they spinned up, but I cannot be sure as there 
are 9 drives in the system).  Consequently, they were dropped from their 
respective raid setups (one from raid0, one from a raid1, and one from a 
raid6 -- 3 in total as one drive is used in 2 setups).

I couldn't access the drives in question anymore with hdparm either.  
There was nothing left to do but reboot the system. After the reboot the 
raid0 array was useable again (which was a nice bonus as it isn't 
redundant).  The raid1 and raid6 needed repairs.  The drives themselves 
are working fine (and are still working fine now that they're no longer 
being spun down).

I'm at a loss of how to solve this problem -- I'm thinking it may be 
somekind of timeout occuring before the drives are fully available, 
which perhaps can be adjusted.

Any help?

--John

