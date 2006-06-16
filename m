From: "Michael Rudmin" <rudmin_pen@cox.net>
Subject: Failing HDD and Mirror Raid
Date: Thu, 15 Jun 2006 20:22:46 -0400
Message-ID: <op.ta7pz8k4iyt4ub@ip70-161-190-174.hr.hr.cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed	delsp=yes
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a computer with 3 IDE HDD (and 1 CDROM), and a dual boot as follows:
HDD1:  Contains WinME
HDD2:  /BOOT is here.  Grub points here initially, and from here might  
boot WinME.  It also contains RAM disk, and some RAID
CD:
HDD4:  Contains a RAM disk, and the rest of the Raid.

The boot system is a Debian system with MDADM.

I'm pretty sure that the RAID is the mirroring system.

I set up RAID on this system so that I could learn, and it's working:  I'm  
going to get a few lessons right soon, as it turns out.

Now, recently I'd been working, and linux froze and crashed.  I finally  
got everything logged off, tried to log in again, succeeded, and then  
found myself back at the login page.  Whoops.  I tried to shut down -- saw  
a flash of error messages about drive HDD2.  I don't remember what they  
were.  Finally, I turned the power off.

When I turned the power back on, it wouldn't recognize the primary slave  
(HDD2).  I let the system rest, and then turned it on -- everything was  
fine.

I used it for a while, and again lost the use of drive B.  Again, a bunch  
of error messages I don't remember.

Anyhow, again I found that a rest allowed things to get back to normal.

So I'm wondering what could be going on, but I'm betting my cookies that  
I'm losing HDD2.

So now, my question is, how do I confirm this (which log files should I  
look at), and how do I neatly and safely take this disk out of the system,  
replace it with another, and bring the whole thing back online?

As part of this question, how will I manage replacing the boot disk, when  
GRUB points directly there?

Other tools I have are boot CDs for the Debian system, and a KNOPPIX live  
CD.

Answers that will be helpful might include (1) direct answers (2) Links to  
proper documentation that might answer the questions (3) references to a  
more appropriate list server, if necessary, or (4) anything else that  
seems appropriate.

Thank you.

  - MJR

-- 
Using Opera's revolutionary e-mail client: http://www.opera.com/mail/
