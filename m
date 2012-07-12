From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: raid1 repair: sync_request() aborts if one of the drives has bad
 block recorded
Date: Thu, 12 Jul 2012 18:38:43 +0300
Message-ID: <CAGRgLy6j3pEeXGXJbVc4Sz3gdShWWfaT7hyXnurgO-6N-_E_ZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Hi Neil,
I am testing the following simple scenario:
- RAID1 with two drives
- First drive has a bad block marked in the bad block list
- "repair" is triggered

What is happening is that the code in raid1.c:sync_request() selects
candidates for reading. If it encounters a bad block recorded, it
skips this particular drive:
			if (is_badblock(rdev, sector_nr, good_sectors,
					&first_bad, &bad_sectors)) {
				if (first_bad > sector_nr)
					.../* we don't go here*/
				else {
                                        /* we go here*/
					bad_sectors -= (sector_nr - first_bad);
					if (min_bad == 0 ||
					    min_bad > bad_sectors)
						min_bad = bad_sectors;
				}
			}
			if (sector_nr < first_bad) {
                            /* we don't go here */
                            ...
But the second drive has no bad blocks recorded, so it is selected.
So we end up with read_targets=1 and min_bad>0.

Then the following code:
	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) && read_targets > 0)
		/* extra read targets are also write targets */
		write_targets += read_targets-1;
leaves write_targets=0

Then the following code:
	if (write_targets == 0 || read_targets == 0) {
		/* There is nowhere to write, so all non-sync
		 * drives must be failed - so we are finished
		 */
		sector_t rv = max_sector - sector_nr;
aborts the resync.

Is this the intended behavior? Because it looks like this bit does not
take into account the bad-blocks existence.
I am not sure about which logic would solve it, but something like "If
we did not select a drive for reading because of bad blocks, and as a
result we have only one read_target, and MD_RECOVERY_REQUESTED, then
let's report only the bad block as skipped and not the whole drive".
Something like that, but there are probably many cases I am not
thinking about.

What do you think?

Thanks,
Alex.
