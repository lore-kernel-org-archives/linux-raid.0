From: jshankar <jshankar@CS.ColoState.EDU>
Subject: raid-0 question
Date: Tue, 19 Aug 2003 16:51:46 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F47EA8C@webmail.colostate.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

For a raid-0 configuration i am using two disk[/dev/sdb and /dev/sdc].At 
present
does the raid support a scenario in which i can write 100 bytes into /dev/sdb  
and    
200 bytes into /dev/sdc.

If it is not supported, please let me know what all routines or header file, i 
may need to modify in order to support it.

It would be great if somebody can point me to md( multiple device driver 
documentation for raid) .


Thanks in advance.

-Jay

