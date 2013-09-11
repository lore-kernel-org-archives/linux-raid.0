From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: md/raid5: fresh drive rebuild always requires a fullsync if interrupted
Date: Wed, 11 Sep 2013 21:08:11 +0300
Message-ID: <CAGRgLy4+E46exJpSv-eaG6uZAOTQWCUpGjUbENjvvzG3LV8H3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,

Please consider the following scenario:
# degraded raid5 with 3 drives (A,B,C) and one missing
# a fresh drive D is added and starts rebuilding
# drive D fails
# after some time drive D is re-added

what happens is the following flow:
# super_1_validate does not set In_sync flag, because
MD_FEATURE_RECOVERY_OFFSET is set:
    if ((le32_to_cpu(sb->feature_map) &
         MD_FEATURE_RECOVERY_OFFSET))
        rdev->recovery_offset = le64_to_cpu(sb->recovery_offset);
    else
        set_bit(In_sync, &rdev->flags);
    rdev->raid_disk = role;

# As a result, add_new_disk does not set saved_raid_disk:
    if (test_bit(In_sync, &rdev->flags))
        rdev->saved_raid_disk = rdev->raid_disk;
    else
        rdev->saved_raid_disk = -1;

# then add_new_disk unconditionally does:
    rdev->raid_disk = -1;

# Later remove_and_add_spares() resets rdev->recovery_offset and calls
the personality:
    if (rdev->raid_disk < 0 && !test_bit(Faulty, &rdev->flags)) {
        rdev->recovery_offset = 0;
        if (mddev->pers->hot_add_disk(mddev, rdev) == 0) {

# And then raid5_add_disk does:
        if (rdev->saved_raid_disk != disk)
            conf->fullsync = 1;

which results in full sync.
This is on kernel 3.8.13, but your current for-linus branch has the
same issue, I believe.

Is this a reasonable behavior?

Also, I see that recovery_offset is basically not used at all during
re-add flow: we cannot resume the rebuild from recovery_offset,
because while the drive was out of the array, data may have been
written before recovery_offset, correct? That's why it is not used?

Thanks,
Alex.
