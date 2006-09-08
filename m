From: martin.kihlgren@adocca.com
Subject: Please help me save my data
Date: Fri, 8 Sep 2006 15:36:35 +0200
Message-ID: <20060908133624.GA20190@troja.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids


Hello list.

I have a spot of trouble with a RAID5 array of mine, and I thought maybe you could help me.

This is the story so far:

 * I bought 10 external USB drives. This seemed like a good idea, they are
   cheap, they are hot-pluggable and they are fast enough.
 * I set them up in two RAID5 arrays, which I set up as LVM pv's. Then I
   created an LVM vg out of these and an LVM lv out of the vg.
 * I encrypted this lv and formatted it with an xfs fs.

This all worked perfectly fine, until I realized how bad these drives and this USB controller work with ehci_hcd.

In short, the devices get reset all the time. And each time they get reset, everything stops for a while. Nothing strange and no showstopper 
here.

But the really bad thing is when they reset in some extra-bad way, and get dropped completely. What happens then is that the RAID5 system 
drops them, and they get reincarnated with a new device name. /dev/sdi becomes suddenly /dev/sdn or something similarly horrbile.

And since I (up until yesterday) didnt know about write-intent bitmaps each resync took around 10 hours. Plenty of time for ANOTHER disk to 
fail and get dropped.

This I usually solved by doing mdadm -S and then mdadm -A -f.

Yesterday, however, I was feeling extra clever, and I just did mdadm -a /dev/md1 /dev/sdn1.

This was a huge mistake.

What had happened, I now realized, was this:

 * /dev/md1 is fine
 * /dev/sdX1 drops, and /dev/md1 is degraded
 * I re-add /dev/sdX1 in its new guise, and /dev/md1 is resyncing with
   4 working drives and one spare
 * /dev/sdY1 drops, and /dev/md1 stops
 * I re-add /dev/sdY1 in its new guise, and mdadm marks it as a SPARE. * I suddenly have an array with 3 working drives and 2 spares where
   I know that one spare is in fact synced and ready to go, since
   the array stopped the moment it failed.

Also, I dont know any longer WHERE in the array the synced but
spare-marked drive should go. I know that the working drives are 0, 2 and 4, but not where the synced spare drive should go.

So, what I want to do is:

 * Mark the synced spare drive as working and in position 1
 * Assemble the array without the unsynced spare and check if this
   provides consistent data
 * If it didnt, I want to mark the synced spare as working and in
   position 3, and try the same thing again
 * When I have it working, I just want to add the unsynced spare and
   let it sync normally
 * Then I will create a write-intent bitmap to avoid the dangerously
   long sync times, and also buy a new USB controller hoping that it will solve my problems

So, do you guys have any idea how I can do this? mdadm doesnt support changing the superblock in such a free hand manner...

Please help me save this data :/ It is precious to me :.(

regards,
//Martin Kihlgren

