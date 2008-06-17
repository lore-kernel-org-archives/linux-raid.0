From: Clive Messer <clive@vacuumtube.org.uk>
Subject: Re: Confused about UUID mounting and mirrors
Date: Tue, 17 Jun 2008 17:10:31 +0100
Message-ID: <1213719031.25184.40.camel@localhost.localdomain>
References: <4856A8C6.3030609@kmaclub.com> <4856CFE1.1020105@ziu.info>
	 <4856DB4C.20905@kmaclub.com> <4856DD5B.9050303@dgreaves.com>
	 <485721A5.3080101@kmaclub.com> <48576394.8090609@msgid.tls.msk.ru>
	 <4857C7FC.9000000@kmaclub.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4857C7FC.9000000@kmaclub.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2008-06-17 at 07:19 -0700, michael@kmaclub.com wrote:

> Using the filesystem ID doesn't work either because /dev/sda, /dev/sdb, 
> and /dev/md0 all have the same UUID since it is a mirror.  How do you 
> tell the system to mount /dev/md0 and not the individual drives which is 
> what it is trying to do now.

Michael,

I'm not sure I understand. My Fedora fstab and grub.conf uses UUID's.

The UUID on the underlying raid devices is different to the filesystem
device. eg. /dev/md0 is RAID1 comprised of /dev/sd[a-d]1

/dev/md0: UUID="d046b3c4-8f1b-4c60-8982-9621cf2ac34c" SEC_TYPE="ext2"
TYPE="ext3" LABEL="BOOT"

/dev/sda1: UUID="bb2b88b1-b1a0-c8f7-2e40-e00de48ff896" TYPE="mdraid"
/dev/sdb1: UUID="bb2b88b1-b1a0-c8f7-2e40-e00de48ff896" TYPE="mdraid" 
/dev/sdc1: UUID="bb2b88b1-b1a0-c8f7-2e40-e00de48ff896" TYPE="mdraid" 
/dev/sdd1: UUID="bb2b88b1-b1a0-c8f7-2e40-e00de48ff896" TYPE="mdraid" 

/etc/fstab:
UUID=d046b3c4-8f1b-4c60-8982-9621cf2ac34c /boot ext3 defaults 1 2

Regards

Clive
-  
Clive Messer <clive@vacuumtube.org.uk>



