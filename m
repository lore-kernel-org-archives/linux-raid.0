From: jshankar <jshankar@CS.ColoState.EDU>
Subject: raid-0,raid-1 help
Date: Fri, 29 Apr 2005 08:00:58 -0600
Message-ID: <42763803@webmail.colostate.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: njayshankar@gmail.com
List-Id: linux-raid.ids

Hello,

I need some help in understanding the linux raid-0 and raid-1.
If in raid-0 , i have two device (/dev/sda and /dev/sdb and the chunk size is 
4k, which part of the code is responsible for deciding that the first 4k goes 
into /dev/sda and then second write of 4K goes into /dev/sdb.How does md 
driver knows the layout of the disk. Does it leave to the ide or scsi driver.


Also while reading the data, it needs to read from /dev/sda first and then 
from /dev/sdb. which routine is responsible for tracking the blocks and lba.

also Which routine is responsible for queuing the md driver data and command.

where can i find the documentation for raid source code.

All help appreciated.

Thanks
Jay

Note: Please email the response to my email id. I am not a subscriber of 
linux-raid group.


