From: Schuett Thomas EXT <Thomas.Schuett.extern@mchh.siemens.de>
Subject: AW: AW: RAID1 and data safety?
Date: Tue, 29 Mar 2005 16:18:52 +0200
Message-ID: <76592C4D3DA1AC4FB8424084D10D31A80611527C@mchh2c4e.mchh.siemens.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>> Does this sound reasonable?
>
>Does to me.  Great example!

Thanks for the flowers :)
However, I am sure, the raid developers have thought through
all this over and over, and still have some asses in their hands.

I'd like to hear from them about the event count in the superblock 
Peter mentioned, and the algorithm, that decides, which blocks still 
needs to be synced.
As Luca wrote:
 > there isn't one [non-volatile storage about blocks needing sync] for 
 > lack of a non-volatile storage for dirty cache
but probably Neil knows a bit more about that?


Probably, to be on the save side, one would have to perform 
real HD internal write cache flushes after each
- write of start-of-transaction-info
- write of data
- write of end-of-transaction-info
I think, this is necessary, because otherwise the HD write cache
flush might start with a write, that came in later, so it might
first write the end-of-transaction-info, then the data, and then
the start-of-transaction-info. A chrash in between would
smash everything. 

Actually this should be a problem for journaling fs writers in the 
first place, but as raid subsystems in between do some caching on 
there own in a very special way, it becomes a topic for raid designers 
too. What do I mean with "very special way". I mean, that they write,
and then say, that they have written o.k. And if you read back the 
written data (after a crash in between), you may by chance (=by having the
faster HD choosen for read) find everything fine, even if it actually 
did write to one of the HDs only. 

I still believe, that things would be better, if reads would go to both HDs,
and compare the results. Even if a difference would not be solvable for data 
(and so would not improve that situation), it would improve the situation for 
reading transaction-info:

difference in start-of-transaction-info
 -> the data write has not started jet, so just 
    delete the start-of-transaction-info

difference in end-of-transaction-info
 -> The data write has finished already, so just
    update the end-of-transaction-info

difference in data
 -> can not happen,because the jfs would have rolled back
    at boot after crash



Thomas


PS:
>Do you see any problem in this [more complex 4 HD] scenario?
It looks like the easier example is still not clarified, so we stay with
that one for now :-)
