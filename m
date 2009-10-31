From: Michael Tokarev <mjt@tls.msk.ru>
Subject: md[adm] device names
Date: Sat, 31 Oct 2009 15:54:58 +0300
Message-ID: <4AEC33A2.6050408@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
Cc: martin f krafft <madduck@madduck.net>
List-Id: linux-raid.ids

Hello.

Mdadm 3.x introduced a subdirectory for all md-related
deice nodes, /dev/md/.  (To be exact, that directory were
introduced earlier, but starting with 3.x it's the default
location).

The question is, the short form: can we get the naming back?
Or, at least, some plan for migration (with a justification
as of _why_ the move)?

I tried new mdadm package on a Debian system.  And what
I ended up is a complete mess.

The system boots with root=UUID=xyz parameter, even if
my /etc/fstab lists /dev/md1p1 as root device.

When it boots (during initramfs), the array gets assembled in
/dev/md/d1, even if mdadm.conf lists /dev/md1.  So the
mount(8) command lists root on /dev/md/d1p1.

When udevd is re-scanning device nodes from real root, it
creates /dev/md1 and not /dev/md/d1.

When update-initramfs script runs, mdadm-related parts
complains that there's no definition found for array
/dev/md/1_0.

I understand that some of that are Debian-specific, probably
broken workarounds for the name change.  But the root cause
is the renaming, it looks like.

So the question is, the long form:

  Why the rename to start with?  The kernel already knows
  its devices by name, and uses _plain_ naming, without any
  subdirectory: like /sys/block/md1, /proc/partitions and
  so on.  I expect to find the names which are used by
  kernel in /dev as-is.  Other tools expexts the same,
  and some even complains and errors out if they can't
  (notable lilo).  If we want subdirectory, how about
  renaming them in the kernel?  But there aren't that
  many md devices to justify the subdirectory, IMHO.

  I understand about symbolic names (home, volume0,
  backup etc) - those may go to /dev/md/home and so
  on.  But can we please, pretty please, make these
  a sumlinks to the real device nodes as kernel sees
  them?  Like all the /dev/disk/by-xx/* symlinks are?
  Since these are really just _aliases_ for the kernel
  device names...

  I can hear the famous "policy does not belong to the
  kernel" thing here, the same way as with udev.  But
  it didn't work out for several years of udev already,
  and what we have now with mdadm is a _lack_ of policy
  instead of _some_ policy, which is nothing more than
  a big mess.

This is getting out of control.

/mjt
