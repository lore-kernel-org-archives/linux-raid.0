From: dean gaudet <dean@arctic.org>
Subject: Re: Feature Request/Suggestion - "Drive Linking"
Date: Mon, 4 Sep 2006 23:33:24 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0609042257240.12203@twinlark.arctic.org>
References: <1156868468.5611.102.camel@localhost>
 <5b170a7d0609030759u2b145237m85757ec649f86488@mail.gmail.com>
 <44FB206D.6000206@tls.msk.ru> <44FC5A65.3060307@tmr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44FC5A65.3060307@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Tuomas Leikola <tuomas.leikola@gmail.com>, Neil Bortnak <linux-raid@moro.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 4 Sep 2006, Bill Davidsen wrote:

> But I think most of the logic exists, the hardest part would be deciding what
> to do. The existing code looks as if it could be hooked to do this far more
> easily than writing new. In fact, several suggested recovery schemes involve
> stopping the RAID5, replacing the failing drive with a created RAID1, etc. So
> the method is valid, it would just be nice to have it happen without human
> intervention.

you don't actually have to stop the raid5 if you're using bitmaps... you 
can just remove the disk, create a (superblockless) raid1 and put the 
raid1 back in place.

the whole process could be handled a lot like mdadm handles spare groups 
already... there isn't a lot more kernel support required.

the largest problem is if a power failure occurs before the process 
finishes.  i'm 95% certain that even during a reconstruction, raid1 writes 
go to all copies even if the write is beyond the current sync position[1] 
-- so the raid5 superblock would definitely have been written to the 
partial disk... so that means on a reboot there'll be two disks which look 
like they're both the same (valid) component of the raid5, and one of them 
definitely isn't.

maybe there's some trick to handle this situation -- aside from ensuring 
the array won't come up automatically on reboot until after the process 
has finished.

one way to handle it would be to have an option for raid1 resync which 
suppresses writes which are beyond the resync position... then you could 
zero the new disk superblock to start with, and then start up the resync 
-- then it won't have a valid superblock until the entire disk is copied.

-dean

[1] there's normally a really good reason for raid1 to mirror all writes 
even if they're beyond the resync point... consider the case where you 
have a system crash and have 2 essentially idential mirrors which then 
need a resync... and the source disk dies during the resync.

if all writes have been mirrored then the other disk is already useable 
(in fact it's essentially arbitrary which of the mirrors was used for the 
resync source after the crash -- they're all equally (un)likely to have 
the most current data)... without bitmaps this sort of thing is a common 
scenario and certainly saved my data more than once.
