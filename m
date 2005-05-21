From: Bill Todd <billtodd@metrocast.net>
Subject: md/RAID performance anomalies in 2.6 vs. 2.4
Date: Fri, 20 May 2005 23:02:19 -0400
Message-ID: <428EA4BB.10703@metrocast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Apologies if this issue has long since been addressed, but I Just 
stumbled upon last December's description of md's unusual performance 
behavior between the 2.4 and 2.6 environments and in looking at Neil's 
graphs the thought crossed my mind that it might be memory-related 
(especially given his statement that he incorporated some new cache in 
the latter plus the fact that he was juggling aggregate bandwidth across 
two busses).

Specifically, while RAID-5's streaming-read performance can approach 
RAID-0's for a given number of drives in the array, it can only do so if 
there's sufficient memory to post requests far enough ahead to keep both 
busses saturated - which requires more buffer space than RAID-0 does 
because of the staggered nature of the data layout in RAID-5 (and 
consequent tendency to alternate between saturating each bus and leaving 
it partially idle while the other is saturated, in the manner first 
encountered at the 5-drive level in RAID-0, unless requests have been 
posted far enough ahead to take advantage of those otherwise unused bus 
cycles).

Starting at the 6-drive level in his read throughput graph, it seems 
possible that the 2.4 configuration is providing more read-ahead buffer 
space for RAID-5 than the 2.6 configuration does (perhaps as a result of 
the new RAID cache which he has used in the latter) and thus allowing 
better smoothing across both busses (whereas for RAID-0 his new cache 
may be responsible for the smoother read performance above 6 drives than 
was the case in 2.4; RAID-6 might be expected to be less subject to 
either effect, if its two parity segments in each stripe are adjacent 
and thus guaranteed to be on separate busses).  I don't recall his 
stating whether he had drive-level opportunistic read-ahead enabled, nor 
am I sure how it might (or might not) affect things if it was.

But I suspect that he did not have drive-level write-back caching 
enabled, and that makes the sudden dip in RAID-0 2.6 write performance 
at the 5-drive level suggestive of bus imbalance as well, again perhaps 
occasioned by a scarcity of write buffer space, possibly again due to 
the new cache level (and might also help explain the RAID-5 
write-throughput differences between the two versions, though I really 
haven't thought either situation through very well).  The fact that the 
anomalous RAID-0 behavior disappeared on retest seems strange unless the 
drives' write-back caching might have been enabled for that second run 
(yes, seems unlikely).

- bill
