From: John Brooks <john@fastquake.com>
Subject: Inconsistent use of sectors vs 1k-blocks in sysfs and other places
Date: Sat, 17 Dec 2016 05:14:20 +0000
Message-ID: <20161217051420.GA29241@oldkitsune.fastquake.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

I noticed that the md.rst (formerly md.txt) file in Documentation/ says that
the component_size attribute in sysfs is measured in sectors. What the
attribute actually returns is sectors/2 (1K blocks, perhaps?). This is the
relevant code from md.c:

static ssize_t
size_show(struct mddev *mddev, char *page)
{
        return sprintf(page, "%llu\n",
                (unsigned long long)mddev->dev_sectors / 2);
}

So the documentation doesn't match the code. Obviously, that needs fixing. But
in this case, I'm not sure which one is "wrong". mdadm's get_component_size()
function in sysfs.c reads this file and multiplies the result by 2 to get
sectors. So clearly this is a known behaviour and not just a forgotten typo.

Looking further, I found that this seems to be a point of inconsistency in
multiple areas:

- The per-device "offset" attribute is in sectors (as documented).
  The per-device "size" attribute is in 1K blocks (which the documentation
  doesn't specify).

- The "sync_completed" attribute uses sectors.
  The "mdstat" file in procfs uses 1K blocks.

- mdadm --examine shows Avail Dev Size in sectors.
  mdadm --detail shows Used Dev Size in 1K blocks.
  And they both show Array Size in 1K blocks.

I suspect that the sysfs attributes have stayed the way they are in the
interest of not breaking programs that use them. The easiest solution would
probably be to leave the behaviour as-is but update the documentation so it's
clear what units are used where.

Somewhat related, suspend_{lo|hi}, resync_{min|max} attributes specify ranges
in sectors, but the documentation does not specify if they are ranges on the
array size or device size. And RAID10 may even handle resync_max differently
from the rest; I didn't look deeply into that but see commit c805cdecea.

The reason I found out about the component_size issue is that I was trying to
make use of the min/max attributes in a project I'm working on, found that they
wanted device-based sectors, and then found that none of the sysfs attributes
actually tell you the device size in sectors (or the array size for that
matter, by the way).

I'm interested to hear what the developers think. I didn't do a thorough audit
to find all the different places that the different units are used; I just
pointed out a few that I noticed while working with it. So I think it's a good
discussion to bring up with the people familiar with the code.

P.S. First mailing list post :)
