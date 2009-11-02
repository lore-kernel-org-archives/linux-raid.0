From: Neil Brown <neilb@suse.de>
Subject: Re: md[adm] device names
Date: Mon, 2 Nov 2009 13:15:37 +1100
Message-ID: <19182.16585.929763.745870@notabene.brown>
References: <4AEC33A2.6050408@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Michael Tokarev on Saturday October 31
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-raid <linux-raid@vger.kernel.org>, martin f krafft <madduck@madduck.net>
List-Id: linux-raid.ids

On Saturday October 31, mjt@tls.msk.ru wrote:
> Hello.
> 
> Mdadm 3.x introduced a subdirectory for all md-related
> deice nodes, /dev/md/.  (To be exact, that directory were
> introduced earlier, but starting with 3.x it's the default
> location).

sort of...
Devices still get created as '/dev/mdXX', but symlinks are created
with more meaningful names in /dev/md/, and those names are preferred.

> 
> The question is, the short form: can we get the naming back?
> Or, at least, some plan for migration (with a justification
> as of _why_ the move)?

Numbers are meaningless.  I would much rather have "/dev/md/home" or
"/dev/md/backup" or whatever.  But as I said, old names should still
work.


> 
> I tried new mdadm package on a Debian system.  And what
> I ended up is a complete mess.

That is unfortunate.  Hopefully we can sort it out.

> 
> The system boots with root=UUID=xyz parameter, even if
> my /etc/fstab lists /dev/md1p1 as root device.

I don't understand what "even if" means here... it seems to imply a
cause and an effect, but I don't see where either cause of effect is
in the statement.  Please help me understand.

> 
> When it boots (during initramfs), the array gets assembled in
> /dev/md/d1, even if mdadm.conf lists /dev/md1.  So the
> mount(8) command lists root on /dev/md/d1p1.

/dev/md/d1 and /dev/md1 a definitely differ, not just different names
for the same thing.
/dev/md1 (which can also be named /dev/md/1) has a major number of 9
and cannot be partitioned before 2.6.28.
/dev/md/d1 (or /dev/md_d1) has a major number of around 253 and has
always been partitionable.  Normally mdadm will prefer the first style
and will only create the 'partitionable' style if explicitly asked to
by e.g "--auto=part" or "CREATE part=yes" in mdadm.conf, or something
similar.

Is there a 'CREATE' line in your mdadm.conf?

> 
> When udevd is re-scanning device nodes from real root, it
> creates /dev/md1 and not /dev/md/d1.

So the device must have a major number of 9.... something strange
there.

> 
> When update-initramfs script runs, mdadm-related parts
> complains that there's no definition found for array
> /dev/md/1_0.

/dev/md/1_0 would be a name that might be assigned to an array that
was auto assembled in mdadm couldn't be sure that it belonged to
'this' host....

It would probably help a lot if you could report the contents of 
/etc/mdadm/mdadm.conf, and the result of
  mdadm -Evvs


> 
> I understand that some of that are Debian-specific, probably
> broken workarounds for the name change.  But the root cause
> is the renaming, it looks like.
> 
> So the question is, the long form:
> 
>   Why the rename to start with?  The kernel already knows
>   its devices by name, and uses _plain_ naming, without any
>   subdirectory: like /sys/block/md1, /proc/partitions and
>   so on.  I expect to find the names which are used by
>   kernel in /dev as-is.  Other tools expexts the same,
>   and some even complains and errors out if they can't
>   (notable lilo).  If we want subdirectory, how about
>   renaming them in the kernel?  But there aren't that
>   many md devices to justify the subdirectory, IMHO.
> 
>   I understand about symbolic names (home, volume0,
>   backup etc) - those may go to /dev/md/home and so
>   on.  But can we please, pretty please, make these
>   a sumlinks to the real device nodes as kernel sees
>   them?  Like all the /dev/disk/by-xx/* symlinks are?
>   Since these are really just _aliases_ for the kernel
>   device names...

They should be symlinks to the real devices...
Maybe if you also report:
  ls -l /dev/md*

NeilBrown


> 
>   I can hear the famous "policy does not belong to the
>   kernel" thing here, the same way as with udev.  But
>   it didn't work out for several years of udev already,
>   and what we have now with mdadm is a _lack_ of policy
>   instead of _some_ policy, which is nothing more than
>   a big mess.
> 
> This is getting out of control.
> 
> /mjt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
