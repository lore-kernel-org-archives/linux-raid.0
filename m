From: "John Stoffel" <john@stoffel.org>
Subject: Re: raid10 resync hangs in 4.2.6, 4.3
Date: Sun, 22 Nov 2015 14:35:04 -0500
Message-ID: <22098.6376.434671.733521@quad.stoffel.home>
References: <564F6304.3040502@tomt.net>
	<22095.33515.989734.113452@quad.stoffel.home>
	<564FC890.3040507@tomt.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <564FC890.3040507@tomt.net>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Tomt <andre@tomt.net>
Cc: John Stoffel <john@stoffel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Andre" == Andre Tomt <andre@tomt.net> writes:

Andre> On 20. nov. 2015 21:30, John Stoffel wrote:
>> 
>> Andre,
>> I don't have time myself to test this, but since I'm running 4.2.6
>> myself with triple mirror RAID1 arrays, I'm slightly worried now.  But
>> can you make this failure happen with loop-back mounts by any chance?
>> That might help narrow down if it's an MD layer, block layer or
>> controller issue.

Andre> I've failed to reproduce it using loop devices, but I've found
Andre> out the problem appeared somewhere between 4.1 and 4.2.

Andre> 4.1.13 is stable, 4.2.0 to 4.2.6 and 4.3 is not.

Andre> Guess I'm starting a bisect now ;-)

Good luck!  I just got back from a weekend of camping and digging out
from email and tent cleanup and other tasks.  
