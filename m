From: "Rev. Jeffrey Paul" <sneak@datavibe.net>
Subject: 3ware escalade vs software raid, from a different jeff
Date: Wed, 18 Feb 2004 16:48:40 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040218214840.GS20790@datavibe.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I'm building an nfs server to export home directories to a few login 
servers used somewhat heavily by a few hundred people.  Additionally, on 
the array will be a bunch of web content and mysql data files.

I'm currently thinking of a few different configurations, all using four
drives in the 180-250gb range.  I could get sata or udma drives, i could
go raid5 or raid10, and i could do this in linux software raid (using,
say, a pair of promise ultra100s to give me four udma ports, or with an
SATA card), using 3ware's UDMA four-port escalade, or with 3ware's new
sata escalade.

What are the compelling reasons for using sata over udma?  I've had really 
good experiences with linux software raid, but always in small workgroup 
or personal file servers.  I'm wondering if this sort of big, random, 
heavy load will drag down an otherwise speedy box.  Is it worth it to just 
drop the extra $300 and go with hardware raid?  as quality as linux 
software raid is, i'm somehow still more comfortable just leaving it to 
hardware.

what sort of ideas or experiences can you guys share?

i'm going for cost first (i've got a $1k budget or so), reliability and 
stability second, and speed third.

-j

--
--------------------------------------------------------
 Rev. Jeffrey Paul    -datavibe-     sneak@datavibe.net
   aim:x736e65616b   pgp:0x15FA257E   phone:8777483467
    70E0 B896 D5F3 8BF4 4BEE 2CCF EF2F BA28 15FA 257E
--------------------------------------------------------
