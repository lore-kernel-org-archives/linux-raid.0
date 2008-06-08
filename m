From: "NeilBrown" <neilb@suse.de>
Subject: Re: Rebuild after a drive replacement
Date: Mon, 9 Jun 2008 08:25:30 +1000 (EST)
Message-ID: <38060.192.168.1.70.1212963930.squirrel@neil.brown.name>
References: <1212958349.7596.14.camel@gdh-home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1212958349.7596.14.camel@gdh-home>
Sender: linux-raid-owner@vger.kernel.org
To: Gavin Hamill <gdh@acentral.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, June 9, 2008 6:52 am, Gavin Hamill wrote:
> Hi :)
>
> I've had a drive die recently, and took the opportunity to upgrade my
> aging Debian sarge box to etch. Once the new OS was running and I had
> finished beating booting from /dev/md0 with a blunt instrument, I turned
> my attention to the data raid-sets... there's only one I can't sort out,
> and of course.. it's the biggest one :)
>
> eddie:~# cat /proc/mdstat
> Personalities : [raid1] [raid6] [raid5] [raid4]
> md3 : active raid5 hda4[1] hdg4[2]
>       349702144 blocks level 5, 1024k chunk, algorithm 0 [3/2] [_UU]
>
> eddie:~# mdadm --add /dev/md3 /dev/hde5
> mdadm: add new device failed for /dev/hde5 as 3: Invalid argument

Do you get any kernel messages when this fails?
   dmesg | tail

> As you can see, only hde thinks it's a spare, when I want it to replace
> that 'removed' in all cases. What can I do?

Given that the --add failed, this is normal.  The device is added to
the array as a spare, then recover starts.  Once recovery finished
the device so changed to be a full member of the array.

NeilBrown

