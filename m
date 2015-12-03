From: Enrico Tagliavini <enrico.tagliavini@gmail.com>
Subject: Reshape stalls and fails when SELinux is enabled
Date: Thu, 3 Dec 2015 12:04:25 +0100
Message-ID: <CAMQd7mbdqsw5BiRSKbgBqwNFrz4V8T-A3hOftWReRk1XgXc=+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a113b39ea94c03e0525fc5a2e
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--001a113b39ea94c03e0525fc5a2e
Content-Type: text/plain; charset=UTF-8

Hi everybody,

yesterday I tested a conversion of a 2 disk raid1 to a 4 disk raid5.
The reshape never completed, I rebooted the VM and the raid device was
unrecoverable. Backup-file was not useful unfortunately. Take a
comfortable seat, this is a bit long story, sorry :).

Environment:
 - VM running on my laptop (Fedora 22), created with virt-manager,
qemu based. All disk images are qcow2 virtio devices.
 - VM OS: centos 7 64 bit, fully updated as of today.
 - mdadm version: 3.3.2-2.el7_1.1
 - kernel version: 3.10.0-229.20.1.el7
 - selinux policy targeted: 3.13.1-23.el7_1.21

How to reproduce:

 * Attach four 1 GB disks to the VM, in the following example they are
vd[b,c,d,e].
 * create a raid1 device with two disks: mdadm --create /dev/md0 -e
1.2 -n 2 -l raid1 -N raidtest /dev/vdb /dev/vdc
 * [optional?]: I created a FS on it: mkfs.xfs -L test /dev/md0
 * [optional?]: I created three files on it and noted the checksum, to
check for eventual corruptions
     - mount /dev/md0 /mnt/raidtest/ && cd /mnt/raidtest/
     - echo uno > first.txt ; echo due > second.txt ; touch third.txt
; shred -s 512M -f third.txt
     - for file in *; do sha1sum $file >> sha1sum.txt; done
 * check /proc/mdstat to make sure the raid1 sync operation is
complete (should really be fast but better safe than sorry)
 * unmount /mnt/raidtest/
 * add the two additional disks as spares:
     - mdadm --manage /dev/md0 --add-spare /dev/vdd
     - mdadm --manage /dev/md0 --add-spare /dev/vde
 * grow and reshape: mdadm --grow /dev/md0 -n 4 --level=5
--backup-file /root/backup-md0 # (I also tried with
/var/local/backup-md0)

At this point an AVC will happen. Even if I'm in an interactive
session and, as such SELinux should not limit it normally, mdadm
process switches to mdadm_t type (maybe a forked process with its own
session group?) and is not allowed to write a file in the /root/ or
/var/ folders. This is ok, however mdadm keeps going instead of
aborting the reshape. It's running without a backup file, that's not
what the admin asked for since the --backup-file option is specified.
But even worst than this is that my reshape got stuck and never
completed. I waited a couple of hours but it remained at 0%. Something
was actually written to the backup file (which is weird given the AVC,
but it can be the original mdadm process not running under mdadm_t).

At this point I was kind of curious to test what would happen if a
distracted admin like me wont notice the problem and, days later,
would reboot the server due to security updates or anything else. The
result is an unrecoverable md array. I tried to assemble it back with
the backup file

mdadm --assemble /dev/md0  -u 6f53ec3e:d9868fef:12d3e243:8489561b
--backup-file /root/backup-md

But no way

mdadm: [sorry I copied wrong and the device name was lost] has an
active reshape - checking if critical section needs to be restored
mdadm: Failed to find backup of critical section
mdadm: Failed to restore critical section for reshape, sorry.

I retried the entire procedure from scratch, but this time with before
mdadm --grow I set SELinux in permissive mode with setenforce 0.
Everything was butter smooth this time. Reshape was almost instant for
such a small array, data was checksumming correctly and my array was
level 5.

Now there might be a problem with the SELinux policy here, but
honestly I think mdadm should just abort, whatever the reason of the
problem was. There might be other scenarios not involving SELinux
causing the same problem.

It would also be nice to suggest the user, if SELinux is active, to
change the context of the backup file to something SELinux will permit
(mdadm_map_t, mdadm_var_run_t?).

Attached you can also find the AVC denial for my entire day of testing.

Thank you for your help.
Best regards.

Enrico Tagliavini

--001a113b39ea94c03e0525fc5a2e
Content-Type: text/plain; charset=US-ASCII; name="changeraid1_to_raid5.txt"
Content-Disposition: attachment; filename="changeraid1_to_raid5.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ihq4vitm0

bWRhZG0gLS1ncm93IC9kZXYvbWQwIC1uIDQgLS1sZXZlbD01IC0tYmFja3VwLWZpbGU9L3Jvb3Qv
YmFja3VwLW1kMAo=
--001a113b39ea94c03e0525fc5a2e--
