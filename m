From: Iain Rauch <groups@email.iain.rauch.co.uk>
Subject: Re: RAID 6 recovery (it's not looking good)
Date: Tue, 16 Dec 2008 20:31:08 +0000
Message-ID: <C56DC08C.B981%groups@email.iain.rauch.co.uk>
References: <20081216191843.GA25097@lanczos.q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081216191843.GA25097@lanczos.q-leap.de>
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Schubert <bs@q-leap.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Hello Iain,
> 
> can you please describe what is the *present* status?
> 
>> /dev/md0 has been started with 22 drives (out of 24) and 1 spare
> 
> So in short, you had failure of 3 drives, reassembled it with 22 drives and
> while you rebuild it again a drive failed?
> 
> If so, take this last failed drive, clone it to a new drive (e.g. dd_rescue)
> and continue.
> 
> (Sorry, but this is by far too much output below for my tired eyes.
> Sometimes a short description is more helpful).
> 

I'll see if I can do that.

If I can't get anything useful off sdu (the latest to fail) can I change sdw
from spare to active sync? sds is the spare drive it's trying to recover to
and was the one that became out of sync as it ran in degraded mode.

I think sdw maybe sdw was only set to faulty because it was the last one to
be recognised and the array got assembled without it. (The system won't boot
with all the drives on together).

Here is what mdadm -E has to say about each disk:

http://iain.rauch.co.uk/stuff/skinner-2008-12-16/


Regards,

Iain


