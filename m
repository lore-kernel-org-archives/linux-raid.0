From: dean gaudet <dean-list-linux-raid@arctic.org>
Subject: RE: Bad blocks are killing us!
Date: Tue, 16 Nov 2004 15:29:16 -0800 (PST)
Message-ID: <Pine.LNX.4.61.0411161519400.13681@twinlark.arctic.org>
References: <16793.11589.337840.541169@cse.unsw.edu.au>
 <200411161818.iAGIIrN27121@www.watkins-home.com> <16794.34681.356891.746036@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16794.34681.356891.746036@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Guy <bugzilla@watkins-home.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

i've been trying to puzzle out a related solution... suppose there were 
"lock/unlock stripe" operations.  md delays all i/o to a locked stripe 
indefinitely (or errors out after a timeout, both solutions work).

a userland daemon could then walk through an array locking stripes 
performing whatever corrective actions it desires (raid5/6 reconstruction, 
raid1 reconstruction using "voting" for >2 ways).

there are some deadlock scenarios which the daemon must avoid with 
mlockall() and by having static memory allocation requirements.

that gives us a proactive detect/repair solution... maybe it also gives us 
a reactive solution:  when a read error occurs, md could lock the stripe, 
wake the daemon, let it repair and unlock.

there's good and bad aspects to this idea... i figured it's worth 
mentioning though.

-dean
