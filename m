From: Nicolas Schichan <nschichan@freebox.fr>
Subject: livelock during MD device open
Date: Tue, 14 Jan 2014 18:14:46 +0100
Message-ID: <52D57086.1000508@freebox.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Hi,

I have recently been trying to find the cause a livelock occurring during MD 
device open.

The livelock happens when a process tries to open an MD device for the
first time and another opens the same MD device and sends an invalid
ioctl:

Process 1				Process 2
---------				---------

md_alloc()
   mddev_find()
   -> returns a new mddev with
      hold_active == UNTIL_IOCTL
   add_disk()
   -> sends KOBJ_ADD uevent

					(sees KOBJ_ADD uevent for device)
					md_open()
					md_ioctl(INVALID_IOCTL)
					-> returns ENODEV and clears
					   mddev->hold_active
					md_release()
					  md_put()
					  -> deletes the mddev as
					     hold_active is 0

md_open()
   mddev_find()
   -> returns a newly
     allocated mddev with
     mddev->gendisk == NULL
-> returns with ERESTARTSYS
    (kernel restarts the open syscall)


As to how to fix this, I see two possibilities:

- don't set hold_active to 0 if err is -ENODEV in the abort_unlock
   path in md_ioctl().

- check cmd parameter early in md_ioctl() and return -ENOTTY if the
   cmd parameter is not a valid MD ioctl.

Please advise on the preferred way to fix this, I'll be glad to send a
patch for whatever is the preferred solution.

I have also a simple C program that I can send should you want to reproduce 
the issue.

Regards,

-- 
Nicolas Schichan
Freebox SAS
