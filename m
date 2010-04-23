From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: "failed" vs "removed" or "locked-out" state and --incremental
 auto-re-adding
Date: Fri, 23 Apr 2010 10:46:22 -0400
Message-ID: <4BD1B2BE.3020306@cfl.rr.com>
References: <loom.20100423T140059-877@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20100423T140059-877@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Christian Gatzemeier <c.gatzemeier@tu-bs.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/23/2010 8:20 AM, Christian Gatzemeier wrote:
> It seems we don't have an obvious way to manually
> remove a member from an array so that it does not get auto-assembled
> later on (i.e. by udev/--incremental) without completely zeroing the
> superblock or moving it into an own array. Maybe a --lock-out

mdadm --fail followed by mdadm --remove seems to be what you are looking
for.  mdadm --incremental will not use a removed drive.

Actually though, it looks like mdadm does not update the metadata on the
disk when you --fail and --remove it, so it still thinks it is part of
an array.  This appears to be a bug.

Even though the second disk says it is still part of the array, mdadm
--incremental tries to add it to the array, the state of the first disk
takes over and the second disk remains removed.

> Another thing is that trying to --remove without prior --failing gives a rather
> unintuitive "device busy":
> Is there a reason that --remove (and --lock-out)
> shouldn't just automatically "fail" a device?
> Or the other way around when would one want to
> manually --fail a member without subsequently --removing it?

Might be a nice feature though the man page is rather clear that you
have to fail first, then remove.  You might want to fail it and not
remove it so that you can remove the drive for now, and plug it back in
later.
