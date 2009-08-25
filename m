From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: Raid 5 - not clean and then a failure.
Date: Tue, 25 Aug 2009 00:54:49 -0700 (PDT)
Message-ID: <15771.7292.qm@web51312.mail.re2.yahoo.com>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guys,

I have been having some problems with my arrays that I think i have nailed down to a pci controller (well I say that - it is always the drives connected to *a* controller but I have tried 2!) anyway the latest saga is i was trying some new kernel options last night - which didn't work.

But when i booted up again this morning it said one of the drives was in an inconsistent state (not sure of the *exact* error message). I then kicked off an add of the drive and it started syncing. It got about 5% in and then the second drive in on that controller complained and the array failed. 

Is there any hope for my data? If i get a good controller in there will the resync continue? can I try and tell it to assume the drives are good (which they ought to be)?

Please help!

-----------------------
N: Jon Hardcastle
E: Jon@eHardcastle.com
'Do not worry about tomorrow, for tomorrow will bring worries of its own.'
-----------------------


      
