From: Andrew Burgess <aab@cichlid.com>
Subject: RE: RAID halting
Date: Sat, 04 Apr 2009 06:01:06 -0700
Message-ID: <1238850066.16200.51.camel@cichlid.com>
References: <20090404055720.QDOH19140.cdptpa-omta03.mail.rr.com@Leslie>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090404055720.QDOH19140.cdptpa-omta03.mail.rr.com@Leslie>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, 2009-04-04 at 00:57 -0500, Lelsie Rhorer wrote:

> >> The issue is the entire array will occasionally pause completely for
> about 40 seconds when a file is created. 
> 
> >I had symptoms like this once. It turned out to be a defective disk. The
> >disk would never return a read or write error but just intermittently
> >took a really long time to respond.
> 
> >I found it by running atop. All the other drives would be running at low
> >utilization and this one drive would be at 100% when the symptoms
> >occurred (which in atop gets colored red so it jumps out at you)
> 
> Thanks.  I gave this a try, but not being at all familiar with atop, I'm not
> sure what, if anything, the results mean in terms of any additional
> diagnostic data.

It's the same info as iostat just in color

> Depending somewhat upon the I/O load on the RAID array,
> atop sometimes reports the drive utilization on several or all of the drives
> to be well in excess of 85% - occasionally even 99%, but never flat 100% at
> any time.  

High 90's is what I ment by 100% :-)

> Oddly, even under relatively light loads of 20 or 30 Mbps,
> sometimes the RAID members would show utilization in the high 90s, usually
> on all the drives on a multiplier channel.

I think that's the filesystem buffering and then writing all at once.
It's normal if it's periodic; they go briefly to ~100% and then back to
~0%?

Did you watch the atop display when the problem occurred?

> I don't know if this is ordinary
> behavior for atop, but all the drives also periodically disappear from the
> status display.

That's a config option (and I find the default annoying). atop also
sorts the drives by utilization every second which can be a little hard
to watch. But if you have the problem I had then that one drive stays at
the top of the list when the problem occurs.

> Additionally, while atop is running and I am using my usual
> video editor, Video Redo, on a Windows workstation to stream video from the
> server, every time atop updates, the video and audio skip when reading from
> a drive not on the RAID array.  I did not notice the same behavior from the
> RAID array.  Odd.

I think this is heavy /proc filesystem access which I have noticed can
screw up even realtime processes.

> Anyway, on to the diagnostics.
> 
> I ran both `atop` and `watch iostat 1 2` concurrently and triggered several
> events while under heavy load ( >450 Mbps, total ). In atop, drives sdb,
> sdd, sde, sdg, and sdi consistently disappeared from atop entirely, and
> writes for the other drives fell to dead zero.  Reads fell to a very small
> number.  The iostat session returned information in agreement with atop:
> both reads and writes for sdb, sdd, sde, sdg, sdi, and md0 all fell to dead
> zero from nominal values frequently exceeding 20,000 reads / sec and 5000
> writes / sec.  Meanwhile, writes to sda, sdc, sdf, sdh, and sdj also dropped
> to dead zero, but reads only fell to between 230 and 256 reads/sec.

I used:

  iostat -t -k -x 1 | egrep -v 'sd.[0-9]'

to get percent utilization and not show each partition but just whole
drives.

For atop you want the -f option to 'fixate' the number of lines so
drives with zero utilization don't disappear.

If you didn't get constant 100% utilization while the event occurred
then I guess you don't have the problem I had.

Does the sata multiplier have it's own driver and if so, is it the
latest? Any other complaints on the net about it? I would think a
problem there would show up as 100% utilization though...

And I think you already said the cpu usage is low when the event occurs?
No one core at near 100%? (atop would show this too...)


