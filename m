From: Maxwell Bottiger <mbotti1@gl.umbc.edu>
Subject: Unrecognized raid partitions durring upgrade
Date: Tue, 14 May 2002 16:14:19 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.31L.02.0205141604120.12302-100000@linux2.gl.umbc.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,
	This is my first posting to this mailing list.  Since I haven't
recieved any emails before writing this letter, please excuse me if this
question has already been asked.
	I have a server running redhat 7.2.  I'm using software raid 0
partitions for /usr, /home and /mnt/shared.  The latter two partitions
aren't critical at the moment, but /usr is being a bear right now.
	I'm trying to install 7.3 and durring the upgrade process it
appears that none of my raid devices are being mounted.  This is causing
all the packages intended for /usr (that is, /dev/md0) to be installed in
/.  This is a big problem since root isn't nearly large enough to
accomidate the 700 or so packages ear-marked for upgrade.
	So, that's my problem and here is my question.  How do I tell the
kernel using boot params to mount /usr using a raid device.  Right now the
box is totally down since it installed half of the new packages and died.
That's really frustrating as I'm sure you can imagine.  Root itself is NOT
a raid partiton, and unfortunately almost all the docs I've found talk
about how to tell the kernel to boot off of raid.  I'm 99% sure this is
not a hardware failure or anything like that, but that I've simply missed
something.  If anyone has any sugestions, they're quite welcome.

Thanks a lot.


Maxwell (SleepyLight) Bottiger
Theatre and Computer Science Graduate at UMBC
       (o_   (o_
  (o_  //\   //\
  (/)_ V_/_  V_/_  If at first you don't succeed, redefine success.




