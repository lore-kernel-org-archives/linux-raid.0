From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: mkraid hangs system
Date: Wed, 12 May 2004 23:48:16 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200405130348.i4D3mLB17669@www.watkins-home.com>
References: <200405122225.i4CMPK60008990@socrates.Berkeley.EDU>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200405122225.i4CMPK60008990@socrates.Berkeley.EDU>
To: 'Arnab Chowdry' <achowdry@socrates.Berkeley.EDU>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

These dd commands may take an hour or more.  You sure your system was hung?

Anyway, try this dd command on your working disks:
dd if=/dev/<good disk> of=/dev/null bs=64k

example:
	dd if=/dev/hda of=/dev/null bs=64k

or this if you want to know how long it takes:
	time dd if=/dev/hda of=/dev/null bs=64k

The above is a read test.  It will not overwrite any data.

Once you know your good disks work, try a bad disk.  Maybe you will be able
to determine a common hardware component, like a disk controller.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Arnab Chowdry
Sent: Wednesday, May 12, 2004 6:27 PM
To: linux-raid@vger.kernel.org
Subject: RE: mkraid hangs system

>you could dd if=/dev/zero of=/dev/your/disk,

Oddly enough, dd hangs as well. I guess that means it's not a RAID problem.
Very strange though, and I don't have a good intuition about why it's
happening.

dd if=/dev/zero of=/dev/hde 
dd if=/dev/zero of=/dev/hdg
dd if=/dev/zero of=/dev/hdi
dd if=/dev/zero of=/dev/hdk

All of the above hang the system after a few seconds. I'm sorry is this is
now off-topic, but maybe some of you experts have some intuition about why
this might happen? All four of the drives can't have "gone bad" or
something.

-Arnab

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


