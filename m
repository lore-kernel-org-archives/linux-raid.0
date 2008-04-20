From: jay@bernard.vm.bytemark.co.uk
Subject: Incorrect array member slot assignment during assemble
Date: Sun, 20 Apr 2008 18:35:52 +0000
Message-ID: <20080420183552.c0g0cm4mucsc8844@mail.jp-hosting.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I had a single disk failure in a 3-disk RAID5 array recently, and have  
been trying to reassemble the array with the remaining devices, but am  
running into some issues.

The failed disk died during synchronization into the array, but it  
looks like the superblocks on the remaining clean devices have some  
issues too.  The following is the output from a forced reassemble:

mdadm -Afv /dev/md0 /dev/sdc /dev/sdd
mdadm: looking for devices for /dev/md0
mdadm: /dev/sdc is identified as a member of /dev/md0, slot -1.
mdadm: /dev/sdd is identified as a member of /dev/md0, slot 0.
mdadm: no uptodate device for slot 1 of /dev/md0
mdadm: no uptodate device for slot 2 of /dev/md0
mdadm: added /dev/sdc to /dev/md0 as -1
mdadm: added /dev/sdd to /dev/md0 as 0
mdadm: /dev/md0 assembled from 1 drive - not enough to start the array.


The "slot -1" assignment for /dev/sdc looked like it might be a  
problem - but I'm not sure how to deal with this with the provided  
tools.

I came across a similar issue (and patch solution) linked below, but  
this didn't work for me - the 'update' on the superblocks never  
appeared to happen in my case since the array isn't assembled:

http://www.mail-archive.com/linux-raid@vger.kernel.org/msg09504.html

I'd be very grateful if anyone has any suggestions or assistance!

Regards,
Jay

----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.

