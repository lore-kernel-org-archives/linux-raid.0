From: <linux-raid.vger.kernel.org@atu.cjb.net>
Subject: =?UTF-8?B?UmU6IFJBSUQtNiBtZGFkbSBkaXNrcyBvdXQgb2Ygc3luYyBpc3N1ZSAobm8gc3VjY2Vzcyk=?=
Date: Sat, 13 Jun 2009 12:02:15 -0600
Message-ID: <200906131802.n5DI2Kj0065178@cjb.net>
References: <291caaa7fd94da9532a4d5a847436f02.squirrel@neil.brown.name>
Reply-To: <linux-raid.vger.kernel.org@atu.cjb.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <291caaa7fd94da9532a4d5a847436f02.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> More information required: how did it fail?
> How about "fsck -n /dev/whatever" ??

The "mount" command never gives useful information, just vague
multiple-choice error messages.  The simple reality is there
is no filesystem (corrupted or otherwise) on the
/dev/mapper/the_encrypted device.

This is confirmed by the fact that I did:

# strings -n 1 /dev/mapper/the_encrypted

There is nothing there for fsck to work with, no filesystem, no
files, just random data indefinitely (I watched it for around 3
minutes).

> The output from mdadm --assemble --force looks encouraging.   It
> suggests that it was able to re-assemble the array with only minor
> changes to the metadata.
> 
> So it really looks like you should be very close to success....

I feel very close to giving up on computers, certainly not success.

I was lax with backing up due to the perceived stability of RAID-6
arrays, and now we have lost most of 10 years of files belonging to
three people.

Re the useless error with mount:

mount: wrong fs type, bad option, bad superblock on
/dev/mapper/the_encrypted, missing codepage or helper
program, or other error.

# fdisk -l > /dev/null

Error: /dev/mapper/the_encrypted: unrecognised disk label
Error: /dev/md13: unrecognised disk label

As far as I remember, when it was working the_encrypted would
show up as 5.5 terabytes, while the md13 would produce that same
error.

Re fsck, there is nothing there to fsck.  It tells me there is no
superblock and exits.

 - S.A.





