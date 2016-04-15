From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: What does --replace actually do?
Date: Fri, 15 Apr 2016 21:26:48 +1000
Message-ID: <5710CFF8.70508@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

When I request to replace sda with sdj (RAID6 in my case), does it create sdj from the
other members (NOT using sda) or does it make a copy of (by reading) sda?

I hope it is the former, assuming sda is having issues and the action is precautionary.

I see on stackexchange is mentioned that it actually does the latter:
	http://unix.stackexchange.com/questions/74924/how-to-safely-replace-a-not-yet-failed-disk-in-a-linux-raid5-array

And while I am here, can I replace two members at the same time? This should save time
as it takes about 10 hours to reconstruct a 4TB member.

TIA

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
