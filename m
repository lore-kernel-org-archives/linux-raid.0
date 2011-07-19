From: Vasco =?iso-8859-15?b?Tul2b2E=?= <vasco.nevoa@sapo.pt>
Subject: how to recover filesystem after clobbering array?
Date: Tue, 19 Jul 2011 10:43:25 +0100
Message-ID: <20110719104325.16112cl7f4lrzkjh@mail.sapo.pt>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-15;
	DelSp="Yes";
	format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello people.

I've messed up good, and now I need you nice folks to help me recover  
500GB of irreplaceable home video, the full 7 years of my family  
trove. :(

I mistakenly used mdadm to *create* an array instead of *starting* the  
array (big Duh!). Now the array has no partition table. I shudder to  
think I may have clobbered not only the array but also the file  
system. I hardly slept last night. Acceptance is a process. :/

I've learned my lesson there, no more fiddling with "--assume-clean"  
(which was a stupid idea in the first place), but the issue remains:  
how do I get to the file system that I know is still there? The array  
is up but obviously it was never mounted.

Can I just recreate the partition table and it works?.... or do I have  
to use some complex form of forensics to recover the data?

Thank you very much,
Vasco.


