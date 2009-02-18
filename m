From: Kasper Sandberg <lkml@metanurb.dk>
Subject: RE: problem in grow of raid5 3 -> 4 disks
Date: Wed, 18 Feb 2009 02:52:39 +0100
Message-ID: <1234921959.18827.33.camel@localhost>
References: <1234905178.18827.25.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1234905178.18827.25.camel@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello again

Seems he was impatient, and just recompiled kernel and rebooted - and it
worked, it continued the reshape and all is well :)

On Tue, 2009-02-17 at 22:12 +0100, Redeeman wrote:
> (sorry its not properly threaded, but message didnt show up via
> mailinglist yet)
> 
> To add some information, i think the culprit is that he forgot support
> for large block devices in kernel (its 32bit x86)..
> 
> What is the recommendation based on this? enable support, and reboot?
> 
> 
> Thanks again.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

