From: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Subject: Re: raid6 check/repair
Date: Wed, 21 Nov 2007 14:45:59 +0100
Message-ID: <47443697.7060108@ph.tum.de>
Reply-To: thiemo.nagel@ph.tum.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Neal,

 >> I have been looking a bit at the check/repair functionality in the
 >> raid6 personality.
 >>
 >> It seems that if an inconsistent stripe is found during repair, md
 >> does not try to determine which block is corrupt (using e.g. the
 >> method in section 4 of HPA's raid6 paper), but just recomputes the
 >> parity blocks - i.e. the same way as inconsistent raid5 stripes are
 >> handled.
 >>
 >> Correct?
 >
 > Correct!
 >
 > The mostly likely cause of parity being incorrect is if a write to
 > data + P + Q was interrupted when one or two of those had been
 > written, but the other had not.
 >
 > No matter which was or was not written, correctly P and Q will produce
 > a 'correct' result, and it is simple.  I really don't see any
 > justification for being more clever.

My opinion about that is quite different.  Speaking just for myself:

a) When I put my data on a RAID running on Linux, I'd expect the 
software to do everything which is possible to protect and when 
necessary to restore data integrity.  (This expectation was one of the 
reasons why I chose software RAID with Linux.)

b) As a consequence of a):  When I'm using a RAID level that has extra 
redundancy, I'd expect Linux to make use of that extra redundancy during 
a 'repair'.  (Otherwise I'd consider repair a misnomer and rather call 
it 'recalc parity'.)

c) Why should 'repair' be implemented in a way that only works in most 
cases when there exists a solution that works in all cases?  (After all, 
possibilities for corruption are many, e.g. bad RAM, bad cables, chipset 
bugs, driver bugs, last but not least human mistake.  From all these 
errors I'd like to be able to recover gracefully without putting the 
array at risk by removing and readding a component device.)

Bottom line:  So far I was talking about *my* expectations, is it 
reasonable to assume that it is shared by others?  Are there any 
arguments that I'm not aware of speaking against an improved 
implementation of 'repair'?

BTW:  I just checked, it's the same for RAID 1:  When I intentionally 
corrupt a sector in the first device of a set of 16, 'repair' copies the 
corrupted data to the 15 remaining devices instead of restoring the 
correct sector from one of the other fifteen devices to the first.

Thank you for your time.

Kind regards,

Thiemo Nagel

P.S.:  I've re-sent this mail as the first one didn't get through 
majordomo.  (Yes, it had a vcard attached.  Yes, I have been told.  Yes, 
I am sorry.)
