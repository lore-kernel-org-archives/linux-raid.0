From: Neil Brown <neilb@suse.de>
Subject: Re: Fwd: Error on /dev/sda, but takes down RAID-1
Date: Thu, 24 Jan 2008 07:55:55 +1100
Message-ID: <18327.43483.57839.624505@notabene.brown>
References: <27710945.1301201097639436.JavaMail.root@zimbra>
	<15672009.1331201100742126.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Martin Seebach on Wednesday January 23
Sender: linux-raid-owner@vger.kernel.org
To: Martin Seebach <mail@martinseebach.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday January 23, mail@martinseebach.dk wrote:
> Hi, 
> 
> I'm not sure this is completely linux-raid related, but I can't figure out where to start: 
> 
> A few days ago, my server died. I was able to log in and salvage this content of dmesg: 
> http://pastebin.com/m4af616df 

At line 194:

   end_request: I/O error, dev sdb, sector 80324865

then at line 384

   end_request: I/O error, dev sda, sector 80324865

> 
> I talked to my hosting-people and they said it was an io-error on /dev/sda, and replaced that drive. 
> After this, I was able to boot into a PXE-image and re-build the two RAID-1 devices with no problems - indicating that sdb was fine. 
> 
> I expected RAID-1 to be able to stomach exactly this kind of error - one drive dying. What did I do wrong? 

Trouble is it wasn't "one drive dying".  You got errors from two
drives, at almost exactly the same time.  So maybe the controller
died.  Or maybe when one drive died, the controller or the driver got
confused and couldn't work with the other drive any more.

Certainly the "blk: request botched" message (line 233 onwards)
suggest some confusion in the driver.

Maybe post to linux-ide@vger.kernel.org - that is where issues with
SATA drivers and controllers can be discussed.

NeilBrown


