From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: data recovery on raid5
Date: Sat, 22 Apr 2006 06:03:26 +0200
Message-ID: <62b0912f0604212103k1c03724cq8b2877104080b14d@mail.gmail.com>
References: <8867c2a014b34d9c11ce162c4f5860af@coraid.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8867c2a014b34d9c11ce162c4f5860af@coraid.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Sam Hopkins <sah@coraid.com>
Cc: linux-raid@vger.kernel.org, jrs@abhost.net, support@coraid.com
List-Id: linux-raid.ids

Sam Hopkins wrote:
> mdadm -C /dev/md0 -n 4 -l 5 missing /dev/etherd/e0.[023]

While it should work, a bit drastic perhaps?
I'd start with mdadm --assemble --force.

With --force, mdadm will pull the event counter of the most-recently
failed drive up to current status which should give you a readable
array.

After that, you could try running a check by echo'ing "check" into
"sync_action".
If the check succeeds, fine, hotadd the last drive to your array and
MD will start resync'ing.

If the check fails because of a bad block, you'll have to make a decision.
Live with the lost blocks, or try and reconstruct from the first kicked disk.

I posted a patch this week that will allow you to forcefully get the
array started with all of the disks - but beware, MD wasn't made with
this in mind and will probably be confused and sometimes pick data
from the first-kicked drive over data from the other drives.  Only
forcefully start the array with all drives if you absolutely have
to...

Oh, and I'm not an expert by any means, so take everything I say with
a grain of salt :-).
