From: Neil Brown <neilb@suse.de>
Subject: Re: modifying degraded raid 1 then re-adding other members is bad
Date: Wed, 9 Aug 2006 08:30:42 +1000
Message-ID: <17625.4242.910985.97868@cse.unsw.edu.au>
References: <or8xlztvn8.fsf@redhat.com>
	<17624.29070.246605.213021@cse.unsw.edu.au>
	<44D8732C.2060207@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Michael Tokarev on Tuesday August 8
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Alexandre Oliva <aoliva@redhat.com>, linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday August 8, mjt@tls.msk.ru wrote:
> 
> Why we're updating it BACKWARD in the first place?
> 

To avoid writing to spares when it isn't needed - some people want
their spare drives to go to sleep.

If we increment the event count without writing to the spares, the
spares quickly get left behind and won't be included next time the
array is assembled.
So on superblock updates that are purely for setting/clearing the
'dirty' bit, we rock back and forward between X and X+1, while leaving
the spares with 'X'.  A difference of 1 isn't enough to leave a drive
out of an array, so the spares stay part of the array.
The 'X is clean, the X+1 is dirty, so if there is any inconsistency
at startup, the 'dirty' will win, which is proper.

Any other superblock change like drives failing or being added cause a
normal forward change of 'events' and spares get written to as well.


> Also, why, when we adding something to the array, the event counter is
> checked -- should it resync regardless?

If we know it to be in sync, why should we resync it?

This is part of a longer term strategy to plan nicely with hotplug.

What I would like is that whenever hotplug finds a device, the hotplug
system can call
   mdadm --hot-plug-this-new-drive-somewhere-useful /dev/newdisk

(or something like that) and the drive will be added to an appropriate
array (if there is one).

So now you have the question: when do you actually activate an array?
Do I wait until there are just enough drives to start it degraded or
do I wait until all drives are present?
The later might never happen.  The former might cause lots of
unnecessary resync.

With the above feature (hot add of a current drive doesn't cause a
resync) then I can activate the array as soon as there are enough
drive for it to work at all.  It can then be read from even though it
isn't complete.
Once the first write happens we commit to the current layout and a new
drive will have to be resynced.  but if the array becomes complete
before the first write, no resync will be needed.

Hope that makes it a bit clearer.

NeilBrown
