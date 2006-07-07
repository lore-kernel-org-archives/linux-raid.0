From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Re: Can't get md array to shut down cleanly
Date: Fri, 7 Jul 2006 03:07:47 +0200
Message-ID: <bb145bd20607061807m7d3a2395hd75b5b338b86e259@mail.gmail.com>
References: <bb145bd20607060648p3776d335g55e4bdee4ecaf3c4@mail.gmail.com>
	 <17581.35566.273512.814844@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17581.35566.273512.814844@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> How are you shutting down the machine?  If something sending SIGKILL
> to all processes?

First SIGTERM, then SIGKILL, yes.

> You could try the following patch.  I think it should be safe.

Hmm, it said chunk failed, so I replaced the line by hand. That didn't
want to compile because "mode" supposedly wasn't defined ... was that
supposed to be "mddev->safemode"? Closest thing to a mode I could find
...

Anyway, this is much better: (lines with * are new)

Done unmounting local file systems.
*md: md0 stopped
*md: unbind <sdf>
*md: export_rdev<sdf>
*[last two lines for each disk.]
*Stopping RAID arrays ... done (1 array(s) stopped).
Mounting root filesystem read-only ... done
Will now halt.
md: stopping all md devices
* md: md0 switched to read-only mode
Synchronizing SCSI cache for disk /dev/sdf:
[...]

As you can see the error message is gone now. Much more interesting
are the lines before the "Will now halt." line. Those were not there
before -- apparently this first attempt by whatever to shutdown the
array failed silently.

Not sure if this actually fixes the resync problem (I sure hope so,
after the last of these no fs could be found anymore on the device)
but it's 5 past 3 already, will try tomorrow.

Thanks,

C.
