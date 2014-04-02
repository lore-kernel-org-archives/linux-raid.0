From: Christian Schmitz <schnet@hotmail.com>
Subject: Problem Syncing raid1
Date: Wed, 2 Apr 2014 20:56:50 +0000
Message-ID: <BAY177-W404434C6EBAB450FA96A77C86D0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi everyone,
I have a linux with the following configuration:
/dev/md0 ( degraded mode)=A0 (/dev/sda2)

/dev/md1 ( full mode) (/dev/sda3 /dev/sdb3)

The problem is if i add /dev/sdb2 to /dev/md0 start the syncing, but wh=
en reach 7% the system crash.
I am sure that the main problem is one ( or more) badblock into /dev/sd=
a2.

How i can do to syncing the disk?.
Obviously Is the first step to change the disk.

Best Regards
Christian

be free, be linux 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
