From: Matt E <mgeusenet@yahoo.com>
Subject: Questions Degraded Array with LVM
Date: Fri, 27 Jun 2003 16:49:20 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030627234920.95101.qmail@web20418.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello All.

Currently, I have an LVM running on my system that is
composed of an 80 gig drive and a 120 gig drive.  I
plan to install a 4 disk RAID-5 Array in my system.  1
of the disk will come from the LVM array.

I'd like to not loose any data doing this, if
possible.

Here's what I want to do:

1) Install the 3 New 120 Gig Disks.  Use mdadm to
create a degraded RAID-5 array.

2) Put this array under LVM control.

3) Use LVM to create a file system on the array.

4) Copy the data from the old LVM array to the new
RAID-5/LVM array.

5) Take down the old (80 + 120 GIG) array.  Blank the
120 Gig drive from this LVM and then install it into
the degraded array (filling the missing slot).

Does anyone know if this is the right way to do this? 
Does anyone know if there will be issues with LVM
created on the degraded array (perhaps this aspect is
off topic)?

Thanks in advance.

Cheers

__________________________________
Do you Yahoo!?
SBC Yahoo! DSL - Now only $29.95 per month!
http://sbc.yahoo.com
