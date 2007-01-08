From: Michel Lespinasse <walken@zoy.org>
Subject: RAID1 repair issue with 2.6.16.36 kernel
Date: Mon, 8 Jan 2007 03:49:43 -0800
Message-ID: <20070108114943.GF17077@zoy.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm hitting a small issue with a RAID1 array and a 2.6.16.36 kernel.

Debian's mdadm package has a checkarray process which runs monthly and
checks the RAID arrays. Among other things, this process does an
echo check > /sys/block/md1/md/sync_action . Looking into my RAID1
array, I noticed that /sys/block/md1/md/mismatch_cnt was set to 128 -
so there is a small amount of unsynchronized blocks in my RAID1 partition.

I tried to fix the issue by writing repair into /sys/block/md1/md/sync_action
but the command was refused:

# cat /sys/block/md0/md/sync_action
idle
# echo repair > /sys/block/md1/md/sync_action
echo: write error: invalid argument

I looked at the sources for my kernel (2.6.16.36) and noticed that in md.c
action_store(), the following code rejects the repair action (but accepts
everything else and treats it as a repair):

                if (cmd_match(page, "check"))
                        set_bit(MD_RECOVERY_CHECK, &mddev->recovery);
                else if (cmd_match(page, "repair"))
                        return -EINVAL;

So I tried to issue a repair the hacky way:

# echo asdf > /sys/block/md1/md/sync_action
# cat /sys/block/md1/md/sync_action
repair
# cat /proc/mdstat
Personalities : [raid1]
...
md1 : active raid1 hdg2[1] hde2[0]
      126953536 blocks [2/2] [UU]
      [==>..................]  resync = 14.2% (18054976/126953536)
+finish=53.7min speed=33773K/sec
...
unused devices: <none>
# ... wait one hour ...
# cat /sys/block/md1/md/sync_action
idle
# cat /sys/block/md1/md/mismatch_cnt
128

The kernel (still 2.6.16.36) reports it has repaired the array, but another
check still shows 128 mismatched blocks:

# echo check > /sys/block/md1/md/sync_action
# cat /sys/block/md1/md/sync_action
check
# ... wait one hour ...
# cat /sys/block/md1/md/mismatch_cnt
128

So I'm a bit confused about how to proceed now...

I looked at the source for debian's linux-2.6_2.6.18-8 kernel and I see
that the issue with the inverted cmd_match(page, "repair") condition is
fixed there. So I assume you guys found this issue sometime between 2.6.16
and 2.6.18.

Would you by any chance also know why the repair process did not work
with 2.6.16.36 ??? Has any related bug been fixed recently ? Should I
try again with a newer kernel, or should I rather avoid this for now ?

Assuming the fix is small, is there any reason not to backport it into
2.6.16.x ?

I would be grateful for any suggestions.

Thanks,

-- 
Michel "Walken" Lespinasse
"Bill Gates is a monocle and a Persian cat away from being the villain
in a James Bond movie." -- Dennis Miller
