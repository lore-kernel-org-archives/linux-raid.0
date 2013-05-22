From: Phil Turmel <philip@turmel.org>
Subject: Re: "Missing" RAID devices
Date: Tue, 21 May 2013 20:02:27 -0400
Message-ID: <519C0B13.3040906@turmel.org>
References: <CAGPLN=viGgdw0MM18tiNxwjNadg0cj8xjntW3ne1qMNkfgocaA@mail.gmail.com> <519B9351.4050708@turmel.org> <CAGPLN=uiUD3wnwt6DfELaLh+yqxkbrA=KetPiQHZrqq4FrS=HA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGPLN=uiUD3wnwt6DfELaLh+yqxkbrA=KetPiQHZrqq4FrS=HA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jim Santos <iluvgadgets@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Jim,

On 05/21/2013 06:22 PM, Jim Santos wrote:
> Hi,
> 
> Thanks for pointing out the initramfs problem.  I guess I should have
> figured that out myself, since I've had to update initramfs in the
> past, but it just totally slipped my mind.  And the strange device
> numbering just threw me complete off track.

Does this mean you're back to running?  Did you follow my instructions?

> As far as how the devices got numbered that way in the first place, I
> really don't know.  I assembled them and that is how it came out.
> Since I was initially doing this to learn about SW RAID, I'm sure that
> I made a rookie mistake or two along the way.

No problem.  You probably rebooted once between creating all your raids
and generating the mdadm.conf file.  (Using mdadm -Es >>/etc/mdadm.conf)

The reboot would have cause initramfs assembly without instructions,
using available minors starting at 127.  Then the --scan into mdadm.conf
would have "locked it in".

> The reason that there are so many filesystems is that I wanted to try
> to minimize any loss if one of them got corrupted.  Maybe it isn't the
> best way to do it, but it made sense to me at the time.  I am more
> than open to suggestions.
> 
> When I started doing this to better understand SW RAID, I wanted to
> make things as simple as possible so I didn't use the LVM.  That and
> it didn't seem like I would gain much by using it.  Al I need is
> simple RAID1 devices I never planned on changing the layout other than
> maybe increasing the size of the disks.  Maybe that flies in the face
> of 'best practices', since you can be sure what your future needs
> would be.  How would you suggest I set things up if I did use LVs?

Simple is good.  My preferred setup for light duty is two arrays spread
over all available disks.  First is /dev/md1, a small (~500m) n-way
mirror with v1.0 metadata for use as /boot.  The other, /dev/md2, uses
the balance of the disks in either raid10,far3 or raid6.  If raid6, I
use a chunk size of 16k.

I put LVM on top of /dev/md2, with LVs for swap, /, /home, /tmp, and
/bulk.  The latter is for photos, music, video, mythtv, et cetera.  I
generally leave 10% of the volume group unallocated until I see how the
usage patterns go.  LVM makes it easy to add space to existing LVs on
the run--even for the root filesystem.

LVM also makes it possible to move LVs from one array to another without
downtime.  This is especially handy when you have a root filesystem
inside a raid10.  (MD raid10 cannot be reshaped yet.)

Anyways, you asked my opinion.  I don't run any heavy duty systems, so
look to others for those situations.

> /boot and / are on a separate disk on RAID1 devices with 1.x
> superblocks.  At the moment, they are the only thing that aren't
> giving me a problem :-)

I guess that means the answers to my first questions are no?

Phil

ps.  The convention on kernel.org is to use reply-to-all, to trim
replies, and to either bottom-post or interleave.  FWIW.
