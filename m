From: "David F. Bakker" <dbakker1@yahoo.com>
Subject: Raid 1 disk scheduling
Date: Sun, 29 May 2005 12:06:28 -0700 (PDT)
Message-ID: <20050529190628.46785.qmail@web30501.mail.mud.yahoo.com>
Reply-To: dbakker1@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a server with lots of available RAM (10GB) I
wanted to create an md raid 1 device that would mirror
a large ramdisk (2GB) to a scsi md device. The
thinking here is writes will be just as fast as always
since I/O is sync to both the RAM and hard disk.
However reads should be crazy fast since it should be
coming from the device with the lower latency or the
one that answers first (RAM). It looks like the I/O is
done in a round robin setup. I get amazing reads every
other test (cat'n a file) which seems it is a round
robin scheme. Can this be changed somehow to prefer a
device or use latency instead?


		
__________________________________ 
Do you Yahoo!? 
Yahoo! Small Business - Try our new Resources site
http://smallbusiness.yahoo.com/resources/
