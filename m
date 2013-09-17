From: Justin Maggard <jmaggard10@gmail.com>
Subject: Mdadm 3.3 reshape issue
Date: Tue, 17 Sep 2013 11:56:06 -0700
Message-ID: <CAKgsxVTVBC7pf3--vAoxwa1LMr7E5OyGnhhwQS=-CD0FYQPUQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Today I was trying to reshape a RAID 5, going from 3 RAID disks to 4,
using the new mdadm 3.3 release.  I had already added the new
partition to the array, which was marked as spare.  Then I ran
`/sbin/mdadm -G -n4 /dev/md127` to start the reshape.  Unfortunately,
it would always return "Failed to initiate reshape".

After a little digging, I found that this was because I'm running a
SUSE SLE11-SP3 kernel, which has partially-implemented support for
changing data_offset.  In raid5.c:raid5_start_reshape(), I found this:

                /* Don't support changing data_offset yet */
                if (rdev->new_data_offset != rdev->data_offset)
                        return -EINVAL;

So, I understand where the "Failed to initiate reshape" error is
coming from.  But is there perhaps a better way to handle this
situation?  I also found that new_data_offset does not get restored
after hitting this error, so further attempts to reshape using a
backup-file continued to fail.  Would it make sense to at least set
new_data_offset back to what it was when we fail to initiate the
reshape?

Thanks,
-Justin
