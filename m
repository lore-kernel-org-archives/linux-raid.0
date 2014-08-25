From: "John Stoffel" <john@stoffel.org>
Subject: Re: AW: [PATCH v3 5/6] md/raid5: activate raid6 rmw feature
Date: Sun, 24 Aug 2014 23:06:15 -0400
Message-ID: <21498.43047.496600.531307@quad.stoffel.home>
References: <5e18e849-8c3d-4812-8fb2-9da8df0ea883@EXCHANGE.collogia.de>
	<21497.57016.978419.117894@quad.stoffel.home>
	<12EF8D94C6F8734FB2FF37B9FBEDD1735863FC91@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD1735863FC91@EXCHANGE.collogia.de>
Sender: linux-raid-owner@vger.kernel.org
To: Markus Stockhausen <stockhausen@collogia.de>
Cc: John Stoffel <john@stoffel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Markus" == Markus Stockhausen <stockhausen@collogia.de> writes:

>> Von: John Stoffel [john@stoffel.org]
>> Gesendet: Sonntag, 24. August 2014 14:46
>> An: Markus Stockhausen
>> Cc: linux-raid@vger.kernel.org
>> Betreff: Re: [PATCH v3 5/6] md/raid5: activate raid6 rmw feature
>> ...
>> Also, how does the patch look when you have a simple 4 disk RAID6 array?  
>> I would hope that since the parity overhead is much higher, it would show 
>> more improvement as well.

Markus> Maybe I did not explain exactly what this patch is for. To boil it down to four
Markus> short and simple key facts.

Markus> - The current kernel implementation of RAID6 is very I/O expensive for small 
Markus> changes. We always need to read all unchanged blocks of the same stripe, 
Markus> recalulate the parity and write the new data block plus two parities. So a single
Markus> block change will produce n (number of disks) I/Os. The source code calls it 
Markus> RCU - reconstruct write.

Markus> - With the patch we will only read the old data of the to be changed block & the 
Markus> parities, recalculate the parities with the new data and rewrite everthing back. A 
Markus> single block change will only have 6 I/Os regardless of the number of disks. It 
Markus> is called RMW - read modify write. 

Markus> - This patch will only kick in if you have 7 or more disks in a RAID6. And ONLY
Markus> if I/Os RMW < I/Os RCU. This should answer your question above.

Markus> - The more disks we have and the smaller the changed data is the more benefit
Markus> we will get from that patch.  

This is a great summary of why this change could/should be in MD.  I
really think this should be part of the commit and/or docs.  Also,
showing that the results are an improvement in terms of IOPS would be
awesome.  So have you run something like that postmark test, which
writes lots of small files into a filesystem and seen how that works
with your patchset?

I don't doubt that there's an improvement, I'm just wondering if it's
enough.  You just haven't justified it properly to me (though I'm not
important, Neil is the decider here...) and I do appreciate your
responses, since they have clarified things quite alot.

John
