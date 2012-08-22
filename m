From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: mdadm: Assemble.c: "force-one" update conflicts with the split-brain
 protection logic
Date: Wed, 22 Aug 2012 20:50:20 +0300
Message-ID: <CAGRgLy5zfK+wLNfMHxAaEsYs=6qeSA4iqaWDZoUhh8a1D2eBBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Hi Neil,
I see the following issue:

# I have a raid5 with drives a,b,c,d. Drive a fails, and then drive b
fails, and so the whole array fails.
# Superblocks of c and d show a and b as failed (via 0xffe in
dev_roles[] array).
# Now I perform --assemble --force
# Since b has higher event count than a, b's event count is bumped to
match the event count of c and d ("force-one")
# However, something goes wrong and assembly is aborted
# Now assembly is restarted (--force doesn't matter now)

At this point, drive b is chosen as "most_recent", since it comes
first and has highest event count (equal to c and d).
However, when drives c and d are inspected, they are rejected by the
following split-brain protection code:
		if (j != most_recent &&
		    content->array.raid_disks > 0 &&
		    devices[most_recent].i.disk.raid_disk >= 0 &&
		    devmap[j * content->array.raid_disks +
devices[most_recent].i.disk.raid_disk] == 0) {
			if (c->verbose > -1)
				pr_err("ignoring %s as it reports %s as failed\n",
					devices[j].devname, devices[most_recent].devname);
			best[i] = -1;
			continue;
		}

because the dev_roles[] array of c and d show b as failed (because b
really had failed while c and d were operational).

So I was thinking that the "force-one" update should also somehow
align the dev_roles[] arrays of all devices that it affects. More
precisely, if we decide to promote a device via "force-one" path, we
must update dev_roles[] of all "good" devices to say that the promoted
device is not 0xffe, but has a valid role. Does this make sense? What
do you think?

And I also think, that the split-brain protection logic that you added
should be made a little bit more explicit. Currently, the first device
with the highest event count is selected as "most_recent", and
split-brain protection is enforced WRT to that device. But this logic
can be affected by the order of devices passed to "assemble". I
already mentioned that in the past I pitched a proposal of dealing
with it. Do you want me to go over it and try to pitch it again?

Thanks!
Alex.
