From: anthony mayes <anmayes@siue.edu>
Subject: raid0 + raid1 question
Date: Wed, 08 Oct 2003 15:53:19 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F84793F.6060400@siue.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have 7 disks in an x86 box.  I want to have 2 raid0's (concatenations) 
of 3 disks each.  Then I want to raid1 (mirror) the raid0's.   This 
leaves 1 disk for the OS.

Is it possible to remove one of the raid0's (concatenation of 3 disks) 
from the raid1 (mirror)?

I need to perform a backup while a highly visible application continues 
to run.  Currently I am using Disksuite on a Solaris 8/SPARC platform 
with the afore mentioned configuration. First the mirror is broken and 
half of the mirror is mounted as another filesystem while the 
application continues to run on the other half of the mirror.  The 
backup is performed and then the mirror is resync'ed.  However, I want 
to move to x86 and linux and need to know if the same is possible and 
how to do it.  Does anyone have any experience / advise?

-- 
Anthony Mayes
UNIX Server Administration
Southern Illinois University Edwardsville
anmayes@siue.edu


