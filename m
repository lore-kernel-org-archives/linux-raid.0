From: Michael Stumpf <mjstumpf@pobox.com>
Subject: how to verify integrity / stability?
Date: Thu, 16 Dec 2004 19:14:22 -0600
Message-ID: <41C232EE.2090504@pobox.com>
Reply-To: mjstumpf@pobox.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Are there scripts that someone may have written already to verify that a 
raid array is functioning properly--data in == data out?  I've been 
running bonnie++ on it, but that doesn't seem to have an option to 
verify contents read == contents written (or is that implicit). 

I bring this up because a long time ago I discovered on my own that 
there was a bug in the ATA VFS driver that would occasionally 
double-write a byte, if memory serves, if you used certain revisions of 
the VIA chipset together in an "md".  History:  I brought this up to the 
ATA maintainer, who immediately assessed me as an idiot for daring to 
think that maybe /dev/hdx is functionally equivalent to /dev/hdy. 
~2.4.10ish I believe..  So now I don't trust anything.

Before I did this by copying an entire DVD rip, 8 gig, multiple times 
until the array was filled, then compute the md5 sum for each, including 
the source.  You could reliably find one that had the "blip"... but I 
never automated it.  Has anyone written a script to automate this task?



--------------------------------------------
My mailbox is spam-free with ChoiceMail, the leader in personal and corporate anti-spam solutions. Download your free copy of ChoiceMail from www.choicemailfree.com

