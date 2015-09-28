From: Xiao Ni <xni@redhat.com>
Subject: Start reshape failed
Date: Mon, 28 Sep 2015 04:52:26 -0400 (EDT)
Message-ID: <842369480.28953435.1443430346579.JavaMail.zimbra@redhat.com>
References: <152634201.28921946.1443426236655.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <152634201.28921946.1443426236655.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil

When I add one disk to a 3disks raid5 and try to run --grow to let raid devices to 4. 
It's failed to start reshape. I used 4.3.0-rc2 and the latest mdadm git tree.

[root@storageqe-09 md]# mdadm --grow /dev/md0 --raid-devices=4
mdadm: Failed to initiate reshape!
[root@storageqe-09 md]# uname -r
4.3.0-rc2
[root@storageqe-09 md]# mdadm --version
mdadm - v3.3.4-24-g86a406c - 28th September 2015

After some analysis, I found some hints.

A: when run --grow, it want to write reshape to sync_action. Before that, it set SET_ARRAY_INFO
in impose_reshape first. When set SET_ARRAY_INFO, it get mutex lock mddev->reconfig_mutex, and 
will call mddev_resume. In mddev_resume it set MD_RECOVERY_NEEDED.

B: At the same time raid5d run. And it call md_check_recovery. But it can't get the lock 
mddev->reconfig_mutex. So it misses the chance to clear MD_RECOVERY_NEEDED.

After A, it write reshape to sync_action. It calls action_store. It will return EBUSY because
the MD_RECOVERY_NEEDED is already set.

} else if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
    test_bit(MD_RECOVERY_NEEDED, &mddev->recovery)) 
     return -EBUSY;

It's a little complex. I add md_check_recovery in action_store and the problem can be fixed.
But I think maybe it's not a right way to fix this. 

Could you give some suggestions?

Best Regards
Xiao
