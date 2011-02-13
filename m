From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Q re sync_completed
Date: Sun, 13 Feb 2011 11:01:43 +1100
Message-ID: <4D571F67.30809@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have scripts that do a raid check, then proceed to identify any files
affected. I then manually deal with these.

I have a few issues with this RADI6 setup, here is one.

I am setting sync_min and sync_max, start a check and wait for sync_completed
to equal sync_max.

I assumed that when equal it means that this address was "completed". After
doing this for a while I observed that this is probably not the case.

My expectation is that sync_completed has 'none' until it finished a chunk.
It then updates it with later completed ones. When it reaches sync_max
it pauses, and I then raise sync_max for the next area. This way I can
tell where a mismatch occurs. If sync_completed is set before a chunk
is completed then I may fetch mismatch_cnt too early (while the last
chunk is still being checked). This seems to be the case.

Q: Is this the case?

Setting ranges that are too small (minimum is 1024) makes the check
*very* slow. I notice that ranges of 1m or even 4m are required to
get the check to move along close to the maximum speed.

Q: Does the check take time to speed up rather than immediately go at
the nominated sync_speed_max rate?

TIA

-- 
Eyal Lebedinsky	(eyal@eyal.emu.id.au)
