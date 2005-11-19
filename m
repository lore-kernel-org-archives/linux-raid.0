From: Mike Hardy <mhardy@h3c.com>
Subject: Re: raid5 write performance
Date: Fri, 18 Nov 2005 20:57:10 -0800
Message-ID: <437EB0A6.8040807@h3c.com>
References: <200511190440.jAJ4efw15919@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200511190440.jAJ4efw15919@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: 'Dan Stromberg' <strombrg@dcs.nac.uci.edu>, =?ISO-8859-2?Q?=27Jure_?= =?ISO-8859-2?Q?Pe=E8ar=27?= <pegasus@nerv.eu.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Guy wrote:

> It is not just a parity issue.  If you have a 4 disk RAID 5, you can't be
> sure which if any have written the stripe.  Maybe the parity was updated,
> but nothing else.  Maybe the parity and 2 data disks, leaving 1 data disk
> with old data.
> 
> Beyond that, md does write caching.  I don't think the file system can tell
> when a write is truly complete.  I don't recall ever having a Linux system
> crash, so I am not worried.  But power failures cause the same risk, or
> maybe more.  I have seen power failures, even with a UPS!

Good points there Guy - I do like your example. I'll go further with
crashing too and say that I actually crash outright occasionally.
Usually when building out new machines where I don't know the proper
driver tweaks, or failing hardware, but it happens without power loss.
Its important to get this correct and well understood.

That said, unless I hear otherwise from someone that works in the code,
I think md won't report the write as complete to upper layers until it
actually is. I don't believe it does write-caching, and regardless, if
it does it must not do it until some durable representation of the data
is committed to hardware and the parity stays dirty until redundancy is
committed.

Building on that, barring hardware write-caching, I think with a
journalling FS like ext3 and md only reporting the write complete when
it really is, things won't be trusted at the FS level unless they're
durably written to hardware.

I think that's sufficient to prove consistency across crashes.

For example, even if you crash during an update to a file smaller than a
stripe, the stripe will be dirty so the bad parity will be discarded and
the filesystem won't trust the blocks that didn't get reported back as
written by md. So that file update is lost, but the FS is consistent and
all the data it can reach is consistent with what it thinks is there.

So, I continue to believe silent corruption is mythical. I'm still open
to good explanation it's not though.

-Mike
