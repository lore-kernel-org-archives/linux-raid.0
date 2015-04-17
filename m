From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Raid 5 rebuild and Raid 6 reshape question
Date: Fri, 17 Apr 2015 11:55 -0600
Message-ID: <6744821.j7csV3RJVE@balsa>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a potentially dumb question...

I had a 5 disk Raid5 with 3TB disks. One disk threw some errors (but still 
seemed to work), and i decided to replace it. I actually bought two drives, 
thinking I'd keep one as a cold spare, but when i got to replacing the drive 
(after days of load testing to see if I'd gotten a dud), I figured maybe I'd 
use the spare as a hot spare, or make a Raid6 array. In the end I decided on a 
Raid6, as it is the recommended way to go these days for large disks.

When I did the add for the first disk, it started rebuilding the raid5, and 
said it'd only take like 5 hours, then I added the second disk and it 
skyrocketed to about 116 hours (7000s or so). I presume this is expected, due 
to having to re-stripe all of the data, and re-calculate the parity at the 
same time.

How much faster would this have finished if I had just waited for the first 
drive to finish rebuilding and done the reshape as a separate step? I decided 
to just let this reshape continue, its about 30% the way through, and this is 
actually the backup array for my main NAS, so it isn't actually a problem if 
it dies mid-reshape. I'm just curious about the alternatives to how I did it. 
I know i could have just copied the old disk to one of the new ones, and 
skipped the entire rebuild on one disk, but i didn't feel like it ;D

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
