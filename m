From: Dick Snippe <Dick.Snippe@tech.omroep.nl>
Subject: try to write back redundant data before failing disk in raid5 setup
Date: Mon, 1 May 2006 01:17:42 +0200
Message-ID: <20060430231742.GC24146@tech.omroep.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

Suppose a read action on a disk which is member of a raid5 (or raid1 or any
other raid where there's data redundancy) fails.
What ahppens next is that the entire disk is marked as "failed" and a raid5
rebuild is initiated.

However, that seems like overkill to me. If only one sector on one disk
failed, that sector could be re-calculated  (using parity calculations)
AND written back to the original disk (i.e. the disk with the bad sector).
Any modern disk will do sector remapping, so the bad sector will simply be
replaced by a good one and there's no need to fail the entire disk.

The reason I bring this up is that I think raid5 rebuilds are 'scary'
things. Suppose a raid5 rebuild is initiated while other members of the
raid5 set have bad -but yet undetected- sectors scattered around the disc
(Current_Pending_Sector in smartd speak). Now this raid5 rebuild would fail,
losing the entire raid5 set. While each and every bit in the raid5 set might
still be salvagable!  (I've seen this happen on 5x250Gb raid5 sets.)

Does anyone on this list have any opinions about this issue?

-- 
Dick Snippe - Publieke Omroep Internet Services
Gebouw 12.401 (peperbus) Sumatralaan 45 Hilversum  \ fight war
tel +31 35 6774252, email beheer@omroep.nl []()     \ not wars
