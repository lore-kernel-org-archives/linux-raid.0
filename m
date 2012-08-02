From: listy@fastmail.fm
Subject: Re: OT: silent data corruption reading from hard drives
Date: Thu, 02 Aug 2012 12:59:50 -0400
Message-ID: <1343926790.28421.140661109896017.1A222237@webmail.messagingengine.com>
References: <50191ADE.10809@fastmail.fm> <5019D052.4000409@hardwarefreak.com>
 <20120802091917.32fb0ca5@natsu> <501A316C.3020305@hardwarefreak.com>
 <20120802140634.6f729d07@natsu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120802140634.6f729d07@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for the replies, everyone.  I didn't expect the debate on 
controller price ranges, though.  :)

My main concern was not really the price of the hardware ("OMG why 
doesn't my $15 card work?!?"), but that the entire setup, hardware + 
software, allows silent data corruption to occur. It's not hard to 
imagine that something similar might happen with an $800 controller 
card, for whatever reason.  And how would the user know, unless they 
noticed bad data, or happened to look at the mismatch_cnt?

(And in my case, I think that, once the weekly raid-check runs and 
updates mismatch_cnt, it's already too late, as the check process has 
potentially rewritten bad data to the drives based on the bogus reads.
Is that correct?   My array is RAID-6, btw.)

Anyway, I'm going give up on SI-based controllers for now and try a
StarTech PEXSAT34, as the Marvell 88SE9128 is supported natively by
the kernel's AHCI driver.

Thanks,
matt
