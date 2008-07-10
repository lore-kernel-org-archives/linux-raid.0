From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: resync'ing - what is going on
Date: Thu, 10 Jul 2008 18:54:59 +0200
Message-ID: <20080710165459.GA17542@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I would like to know what is going on wrt resyncing, how it is done.
This is because I have some ideas to speed up the process. 
I have noted for a 4 drive raid10,f2 array that only about 25 % of the
IO speed is used during the rebuid, I would like to have something like
90 % as a goal.

This is especially for raid10,f2, where I think I can make it much
better, but posssibly also for other raid types, as input to an
explanation on the wiki of what is really going on. 

Are there references on the net? I tried to look but did not really find
something.

I don't really understand why resync is going on for raid10,f2.
But maybe it checks all of the array, and checks that the two copies are
identical. Is that so? I got some communication with Neil that some
writing is involved in the resync, I don't understand why. 

And what happens if a discrepancy is found? Which of the 2 copies are the
good one? Maybe one could look if there are any CRC errors, or disk read
retries going on. I could understand if it was a raid10,f3 - then if one
was different from the 2 other copies - you could correct the odd copy.

For raid5 and raid6 I could imagine that the parity blocks were cheked.

I could of cause read the code, but I would like an overview before
dwelving into that part.

best regards
keld
