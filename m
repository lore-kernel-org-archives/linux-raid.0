From: "Pau Oliva - pof" <pau@eslack.org>
Subject: error in mdadm man page
Date: Mon, 5 Sep 2005 13:45:07 +0200 (CEST)
Message-ID: <22642.212.145.174.224.1125920707.squirrel@212.145.174.224>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I think the man page of mdadm has an error. It says that -z (--size)
option must be specified in Kibibytes and it is not true (at least) when
used in combination with --grow it must be specified in bytes.

I haven't looked at the mdadm code, but this is the experience I had:

I had a raid1 on two 120Gb HD which were replaced by two 200Gb HD, and I
had to grow the array after that because it was only 120Gb big. I looked
at mdadm man page and used '--grow' in combination with '--size' options.

This is what fdisk reports:
     Disk /dev/hdg: 203.9 GB, 203928109056 bytes

So the size in Kibibytes is 203928109056/1024 == 199148544.

We have to substract 128K for the raid superblock, so this is the command
I issued to change the size of the array:

mdadm --grow /dev/md0 --size 199148416

And instead of growing it to 200Gb it reduced it to (I think) ~20Gb. I
rebooted and fsck fixed it :)

I don't know if this list is the right place to report this, if it is not
please reply to my email as I am not susbscribed to the list.

Best regards,

    Pau Oliva

---
http://pof.eslack.org

