From: Jason Lunz <lunz@falooley.org>
Subject: recovery of hosed raid5 array
Date: Sat, 11 Oct 2003 15:52:40 +0000 (UTC)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <slrnbog9og.t0c.lunz@orr.homenet>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

So I have a small raid5 array of 5 25G ide disks for a home server. It
was built entirely on 2.4.22 with mdadm in debian unstable a couple of
months ago.  One of the disks died last night and was removed from the
array, which went on in degraded mode.  The dead disk, /dev/hdg, stopped
responding and was deactivated by the promise ide driver.

After rebooting, the raid continued to work in degraded mode, and
/dev/hdg seemed to check out ok. After checking it with smartctl and
doing some successful reads from it, I added it back to the array with
"mdadm -a".

Once the rebuild started, I noticed an email from smartd, saying that
the _other_ drive on the Promise controller (/dev/hde) had had errors.
So I foolishly checked it out with smartctl, at which point everything
went to hell. /dev/hde now clicks repeatedly and refuses to work for
more than a minute or so, while /dev/hdg is partially destroyed from
being re-added. The rebuild was 3-4% complete when hde died.

So I realize I'm probably fucked, but I really want to get the 80G or so
of data back. Three of the drives are fine, /dev/hde is dead, but if I
can use even some of /dev/hdg, I should be able to at least recover part
of the data if I can get the ext3 fs to mount. How would I go about
this?

I know if I just wanted to use the four good disks, I could do
"mdadm -Af". But how do I go about getting at the pre-rebuild data on
/dev/hdg? Is there any way to restore its superblock data to the
pre-rebuild state?

I will be eternally indebted to anyone that can help.

thanks,

Jason

