From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Check/repair RAID-5 with hints?
Date: Fri, 02 Apr 2010 12:49:05 +0100
Message-ID: <4BB5D9B1.8070000@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have just replaced one of the drives in my RAID-5 array which was 
showing offline uncorrectable and current pending sectors. I took the 
system down into single-user mode, failed the disc out of the array, 
dd_rescue'd the disc to a fresh one, and added the new disc back into 
the array. During the dd_rescue, 68k of 1TB failed, about 1MB from the 
end of the disc. My array has a write-intent bitmap so the resync was 
very quick. So now I have an active, theoretically synchronised RAID-5, 
and I know some 68k on one of the discs is likely rubbish. I would like 
to run some kind of scrub/check/repair on the relevant area, including a 
hint that it is one particular disc that is wrong. Is this possible? I 
have CentOS 5.4, kernel 2.6.18-164.15.1, mdadm 2.6.9, 0.90 metadata.

I wish we had the hot-replace feature that was discussed on this list a 
wee while ago...

I'm wondering if my best course of action is to fail the fresh disc out 
of the array again, dd the data off the offending area (it will be 
re-built from the good discs), write it again (so the write-intent 
bitmap is updated), and re-add the fresh disc to get that area re-synced 
onto the fresh disc.

Cheers,

John.
