From: starlight.2012q4@binnacle.cx
Subject: Re: question: no-bitmap RAID1 with off-site drive
Date: Sun, 11 Nov 2012 17:14:03 -0500
Message-ID: <6.2.5.6.2.20121111170842.05dfe758@binnacle.cx>
References: <6.2.5.6.2.20121111163935.05df8b18@binnacle.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6.2.5.6.2.20121111163935.05df8b18@binnacle.cx>
References: <6.2.5.6.2.20121111163935.05df8b18@binnacle.cx>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Would like to have the option to zero the
superblock of an incoming drive and have
it treated as a virgin replacement.

I tried this (I think) by running

   mdadm --add /dev/md2 /dev/sde

It worked, but assigned the new drive
as device number [2], which seems
incorrect.  I tried failing/removing the
drive followed by a

   mdadm --remove /dev/md2 detached

and repeated the --add with a zero-superblock
drive but it does the same thing every time.
Only way to get it to reuse drive slot 1
was to do a 

   mdadm --grow --raid-devices=1 --force /dev/md2

followed by a

   mdadm --grow --add --raid-devices=2 /dev/md2 /dev/sde

Is this the expected behavior?  I find it
confusing and probably don't understand
it properly.

Kernel is 3.1.8.

