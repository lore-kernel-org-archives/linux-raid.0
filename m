From: Mitchell Laks <mlaks@verizon.net>
Subject: how to move a raid1 drive to a new machine
Date: Mon, 10 Jan 2005 03:43:01 -0500
Message-ID: <200501100343.01672.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi gurus,

A simple question. I have studied the documents

Software raid howto
http://www.tldp.org/HOWTO/Boot+Root+Raid+LILO.html
and scoured google.

Given a raid1 on a machine 

/dev/md0 consists of /dev/hdc and /dev/hde.

I want to grab one of those disks and move it to a new machine and make it 
available there.

What I have thought about:

turn off machine. grab /dev/hde. put in new machine say at position
/dev/hdc (for grins).

now take an identical copy of /etc/raidtab from the original machine.
install it as /etc/raidtab
modprobe raid1
mknod /dev/md0 b 9 0 (if necessary).
raidstart /dev/md0

will this work? 

questions:
1) when do i do mkraid /dev/md0 (ie what does that do... will it zap all the 
stuff in /dev/hdc => ie what was on old /dev/hde??)
2) what is the mysterious failed-disk parameter in /etc/raidtab used for - ie 
will it help here preserve the data while we start up the raid.
3) lets say i want to start the raid without a partner drive, ie just with 
/dev/hdc ( "drive that used to be known as /dev/hde" "my apologies to glyph 
who used to be Prince"), what do i do???

Thanks,
Mitchell

 
 
