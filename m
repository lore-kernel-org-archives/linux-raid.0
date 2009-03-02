From: "Brian Manning" <luckyy@luckyy.com>
Subject: Raid-5 Reshape Gone Bad
Date: Sun, 1 Mar 2009 21:42:18 -0500 (EST)
Message-ID: <39656.69.54.28.143.1235961738.squirrel@webmail.luckyy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've been running a MD three-drive raid-5 for a while now with no problems
on a CentOS 5.2 i386 box.  I've attempted to add a fourth drive to the
array yesterday & grow it.  This is where things got ugly....

It began the reshape as expected, some hours later I rebooted the box for
another reason entirely, forgetting about the reshape that was still going
on.  But it was a clean shutdown process and md stopped just fine.  So I
wasn't too worried about it, I knew it was just pick up again once it
booted.

After startup the kernel found the md, said it was to resume the
reshape... then it came time for the kernel to mount root.. and hung
scanning for Logical Volumes, I left it for over an hour, it never
proceeded past this stage.  Disk io light was off, nothing going on.

My entire OS save /boot is on the raid-5, split across several LVM2s
inside that md device.  It's always worked fine for me in the past.

But now LVM is hanging on boot, I can't even get into single mode or
anything like that.  So I bring out the boot disc and go into rescue mode.

I check the raid status, everything looks okay, so I manually start the MD
again from the boot cd, and that fires up as expected, however.... when I
look at /proc/mdstat... the speed is 0KB/sec, and the ETA is growing by
100's of minutes a second.

I let this go for about 2 hours, and nothing ever happens, speed is 0,
diskio light is off, nothing is happening.

Any process that attempts to look at or use md0 will "freeze" just like at
boot up when LVM would get stuck.  If I attempted to do an LVM scan to
find the LVMs on the md device, LVM process would just hang, can't even be
killed.

So now here I am, I've tried several bootcd distro's for different
versions of mdadm/etc all give basically the same thing... says raid is
okay, started, reshaping... except that it isn't, the speed is 0, and
nothing ever changes.

Even mdadm -E /dev/sd[a-d]1 shows that the last mod time of the array was
back when I originally shut it down, it's never been updated in these
attempts I've made.

The drives are not reporting SMART errors, and I can read data off them w/
DD just fine.  They appear fully functional, however md is just getting
stuck doing who knows what, disk io light doesn't indicate any life at
all, drives are silent.

Can anyone offer me some insight?  Since the reshape didn't actually
finish, is there a way to abort that, or bring the array back to 3 devices
without data loss?

Thanks for any help you can provide!


Please follow this link for a dump of mdadm -D and -E and pertaining
dmesg/mdstat logs: http://luckyy.com/brokenraid.txt


