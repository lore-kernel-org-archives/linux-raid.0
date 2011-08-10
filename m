From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm forces resync every boot
Date: Wed, 10 Aug 2011 11:31:46 +1000
Message-ID: <20110810113146.3667affb@notabene.brown>
References: <4E3C06D1.6030301@gmail.com>
	<20110809093437.299036be@notabene.brown>
	<4E41D9EC.1070706@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E41D9EC.1070706@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Frey <djqfrey@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 09 Aug 2011 18:07:56 -0700 Daniel Frey <djqfrey@gmail.com> wrote:

> On 08/08/11 16:34, NeilBrown wrote:
> > 
> > When there have been no writes for a little while, mdmon will notice and mark
> > the array as 'clean'.  It will then mark it 'dirty' before the first write is
> > allowed to proceed.
> > On a clean shutdown of the array it will mark that array as 'clean'.
> > 
> > But for you, the system shuts down with the array marked 'dirty'.  This
> > suggests that on your machine 'mdmon' is being killed while the array is
> > still active.
> > 
> > Presumably your root is on the IMSM RAID10 array?  When the root filesystem
> > is marked 'read only' it will probably write to the filesystem to record that
> > a fsck is not needed.  So the array will be 'dirty'.  If you then halt before
> > mdmon has a chance to mark the array 'clean' you will get exactly the result
> > you see.
> > 
> > If you arrange that the shutdown script runs
> >   mdadm --wait-clean --scan
> > 
> > after marking the root filesystem readonly, it will wait until all arrays are
> > recorded as 'clean'.
> > 
> 
> Neil,
> 
> I see by the switches it is watching /proc/mdstat for updates, but /proc
> was likely unmounted earlier in the shutdown process, and root is now
> read-only.

It need /proc, /sys, and /dev (assuming udev).
There is really no point in unmounting any of these as they are virtual.
Unmount everything else, remount root readonly, then "mdadm --wait-clean".

However I would expect missing filesystems to cause an early failure rather
than a hang.  If mdmon had been killed already that might cause a bit of a
hang, but it should be limited to 5 seconds.

Maybe run 'mdadm --wait-clean --scan' under 'strace' and see what it is
doing??

NeilBrown


> 
> I've put it in the shutdown scripts and the system hangs on shutdown -
> I've traced the hang to the command I put in above `mdadm --wait-clean
> --scan`.
> 
> Is it possible it's waiting for a write somewhere? I'm so close to
> having it working now...
> 
> Dan

