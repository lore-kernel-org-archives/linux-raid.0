From: Zhilong Liu <zlliu@suse.com>
Subject: mdadm: one question about the readonly and readwrite feature
Date: Wed, 22 Mar 2017 20:00:10 +0800
Message-ID: <774691e9-6b1e-5141-bc37-6e768c1c8fdc@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Jes Sorensen <jes.sorensen@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi, Neil;

   Excuse me, according to read 'mdadm/tests/ToTest', I'm a little 
confused about "readonly"
and "readwrite" feature, and I've no idea how to fix it. Thus I report 
this question and I'm sorry
for this long description email.

relevant linux/driver/md commit: 260fa034ef7a4ff8b73068b48ac497edd5217491

   My question: If the array has been set the MD_CLOSING flag, although 
hasn't removed the sysfs
folder because sysfs_remove_group() wasn't invoked, and now, how should 
mdadm continue to
control this 'readonly' array?
   Of course, once we cannot operate the array, the 'readwrite' feature 
would be never worked.

Test step:
# ./mdadm -CR /dev/md0 -b internal -l1 -n2 /dev/loop[0-1] --assume-clean
# ./mdadm -o /dev/mdX

# in md.h
enum mddev_flags {
         MD_ARRAY_FIRST_USE,     /* First use of array, needs 
initialization */
         MD_CLOSING,             /* If set, we are closing the array, do 
not open it then */

1. In mdadm tool:
   the func: Manage_ro(dv->devname, mdfd, -1) would be never invoked 
once the array has been
set 'readonly' before. the open_mddev() cannot get a valid file 
descriptor any more. Most of mdadm
commands would be failure, I have to execute the "echo clear > 
/sys/block/mdX/md/array_state".

# refer to mdadm.c
... ...
static int misc_list(struct mddev_dev *devlist,
                      struct mddev_ident *ident,
                      char *dump_directory,
                      struct supertype *ss, struct context *c)
{
... ...
                 switch(dv->devname[0] == '/') {
                         case 0:
                                 mdfd = open_dev(dv->devname);
                                 if (mdfd >= 0) break;
                         case 1:
                                 mdfd = open_mddev(dv->devname, 1);
                 }
                 if (mdfd>=0) {
                         switch(dv->disposition) {
                         case 'R':
                                 c->runstop = 1;
                                 rv |= Manage_run(dv->devname, mdfd, c); 
break;
                         case 'S':
                                 rv |= Manage_stop(dv->devname, mdfd, 
c->verbose, 0); break;
                         case 'o':
                                 rv |= Manage_ro(dv->devname, mdfd, 1); 
break;
                         case 'w':
                                 rv |= Manage_ro(dv->devname, mdfd, -1); 
break;
                         }
2. in md driver:
For readonly, the code path is:
ioctl(fd, STOP_ARRAY_RO, NULL)  - - > set_bit(MD_CLOSING, &mddev->flags) 
- - > md_set_readonly()

cut a piece of code: - -> md_set_readonly() of md.c:
... ...
         if (mddev->pers) {
                 __md_stop_writes(mddev);

                 err  = -ENXIO;
                 if (mddev->ro==1)
                         goto out;
                 mddev->ro = 1;
                 set_disk_ro(mddev->gendisk, 1);
                 clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
                 set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);   - - > 
I think it did nothing once readonly has been set.
                 md_wakeup_thread(mddev->thread);
                 sysfs_notify_dirent_safe(mddev->sysfs_state);
                 err = 0;
... ...

Thanks for your patience,
-Zhilong
