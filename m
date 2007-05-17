From: Neil Brown <neilb@suse.de>
Subject: Re: unreadable drives can be synchronized?
Date: Thu, 17 May 2007 10:54:07 +1000
Message-ID: <17995.42927.362919.938781@notabene.brown>
References: <7296208f0705160850u74d9b52en835d3c9b21f54728@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Colin McCabe on Wednesday May 16
Sender: linux-raid-owner@vger.kernel.org
To: Colin McCabe <colin.p.mccabe@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday May 16, colin.p.mccabe@gmail.com wrote:
> Hi all,
> 
> I am running software RAID on Linux 2.6.21.
> 
> While experimenting with adding and removing devices from the RAID array, I
> noticed something very troubling. I have a bad drive (let's call it drive B)
> which gets random read errors. I also have a good drive, call it drive A.
> 
> B can synchronize with A. But then, if I remove A from the raid array, A
> cannot be re-added. This is because the bad drive, B, cannot be read from.

Well, if you remove A, then you have the situation of trusting your
data to a single drive.  And we all know that isn't very safe.

> 
> I wonder if anyone else is interested in a "paranoid recovery" mode where the
> md layer tests the data that has been written. Even if this doubles the
> recovery time, I think that it would be desirable for many applications.

I think it is just as easy to run a 'check' pass after recovery has
completed.

Whenever you are commissioning new hardware, it makes sense to do some
testing before you trust it with valuable data.
It sounds like this particular hardware failure lends itself to easy
discovery with a bit of testing - indeed, you found it while testing
your hardware.  So I don't think it is a failure mode we need to put
any extra care in to.
It is the failure modes that are hard to find with basic testing that
we should worry about.

NeilBrown
