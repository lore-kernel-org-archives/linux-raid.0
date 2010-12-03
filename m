From: Neil Brown <neilb@suse.de>
Subject: Re: Help! I killed my mdadm raid 5
Date: Fri, 3 Dec 2010 12:47:08 +1100
Message-ID: <20101203124708.1ecfff83@notabene.brown>
References: <20101118195109.1GA4L.64443.root@cdptpa-web04-z02>
	<20101119185823.4828f555@notabene.brown>
	<20101202163903.4B6B0E30990@mail.futurelabusa.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101202163903.4B6B0E30990@mail.futurelabusa.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jim Schatzman <james.schatzman@futurelabusa.com>
Cc: p3-500@roadrunner.com, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 02 Dec 2010 09:38:18 -0700 Jim Schatzman
<james.schatzman@futurelabusa.com> wrote:

> I hate to sound like a broken record, but it would be very helpful if mdadm was a bit smarter about handling the case where a drive is removed and then re-added with no data changes. This has happened to me several times when external cables have gotten loose.  Mdadm automatically fails the disconnected drives. Then, when the drives show up again, it will not automatically put them back in the array.  Even though so many drives get offlined that the raid cannot be started, and therefore no filesystem data could possibly be changed, mdadm acts as if the data on the temporarily-removed drives is suspect. Apparently, it changes the RAID metadata while the RAID is stopped. (more precisely, when mdadm attempts to assemble/start a RAID array that is missing too many drives). I really wish that
  it wouldn't change the metadata in this circumstance.
> 
> This may be the result of an interaction between the filesystem drive, Linux, and Mdadm. Nevertheless, the result is unpleasant and annoying.

You don't sound like a broken (or scratched) record to me, because I haven't
heard this complaint before - at least not in this form (that I remember).

In general, what you are describing should work.  There may be specific cases
where it doesn't.  In that case it would help me a lot if you provide
specific details.
i.e. a sequence of events, preferably that I can easily reproduce, which lead
to an undesirable result. Even better if you can provide full "mdadm -E" out
for each device at each point in the sequence, so I can see details of what
is happening.


If you have a write-intent-bitmap, then there are more cases where it can
survive temporary disappearance of devices, but even without, the sort of
thing you describe should work.

If it doesn't, I would very much like to fix it.  But I cannot without
precises details of what is going wrong.

Thanks,
NeilBrown


> 
> The best solution I have come up with is
> 
> 1) Prevent the kernel from seeing your RAID arrays so they don't get started during boot  (unfortunately, this won't work if we are talking about the boot or system arrays).  In particular, remove any arrays you want to not start from the mdadm.conf file when mkinitrd is run (in fact, just be careful never to populate mdadm.conf for these RAIDs - the next time you run mkinitrd either explicitly or when a new kernel gets installed, the new kernel will stop assembling the arrays).
> 
> 2) Use a cron.reboot script (or similar mechanism) to assemble and start the RAID with --no-degraded. I use commands similar to
> 
> mdadm -A --no-degraded /dev/mdXXX --uuid XXXXXXX
> mount -t ext4 -o noatime,nodiratime /dev/raidVGXXX/LVXXX  /export/mntptXXX
> 
> (I am using LVM over RAID).
> 
> It may be possible, but I have no idea how, to get the kernel to assemble RAIDs using "--no-degraded" during boot. Apparently, you have to do something special with dracut/mkinitrd. I may be stupid, but I have found the dracut documentation to be very poor, to the point of uselessness. If someone could explain this I would be grateful.
> 
> The behavior I am trying to achieve is, 
> 
> 1) If the RAID can be assembled with all drives present, do so.
> 
> 2) Otherwise, give up, change no metadata, and let the operator fix it manually.

This is exactly what --no-degraded is for.  It should be as simple as hunting
through the scripts that dracut uses for the one which runs mdadm, and add
--no-degraded.  Then test, then email the dracut developers asking them to
make it an option.

> 
> 3) If the RAID loses drives while running but is still able to run, then keep running.
> 
> 4) If the RAID loses drives while running and can no longer run, then give up, offline the RAID devices, but change no metadata. Wait for the operator to fix the problem. I realize that data may be lost. However, at worst, I would expect to be able to reassemble the drives and run fsck to repair the damage (as best it can).  Yes - I know that you can accomplish this result now -- but you have to re-create the array, instead of being able to just assemble it.

You shouldn't have to recreate the array.  Just add the "--force" flag to
--assemble - what says "I understand there might be data corruption but I
want to continue anyway".


> 
> We can make the current behavior match #2 by assembling with --no-degraded. However, I don't know how to make the kernel do this doing boot. Making #4 work (being able to assemble the array instead of re-creating it), would seem to be a mdadm issue.  Until that happy day arrives, the best that you can do appears to be to keep a record of the important metadata information (-e, --chunk, -level), and be prepared to re-create the array carefully.
> 
> Aside from having to know the important metata parameters, the other issue relates to the Linux kernel's tendency to enumerate drives apparently randomly from boot to boot. It would be helpful if you could do something like "create", but re-creating an array based on the existing UUID metadata, or otherwise specify the drives in random order, and have Mdadm figure out the appropriate drive ordering. Like p3-500, I at first assumed that "assemble" would do this, but "assemble" doesn't work as we naive mdadm users would have expected, once a drive is theoretically failed.
> 

This last - re-creating based on available data - is on my list for
mdadm-3.2.  I haven't figured out the best approach yet I it shouldn't be too
hard.  I need to find a balance between using the data in the superblocks
that exist, but also allowing the user to over-ride anything, or maybe only
some things ... I'm not sure exactly...

NeilBrown

