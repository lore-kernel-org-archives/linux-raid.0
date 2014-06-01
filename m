From: "Andrew Hodgetts" <andrew.hodgetts@btinternet.com>
Subject: Help fixing broken array after power loss
Date: Sun, 1 Jun 2014 19:37:07 +0100
Message-ID: <002001cf7dc8$7e4c3b10$7ae4b130$@btinternet.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-gb
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi

I have a challenge!!
I've been upgrading my array with larger disks, then needed to remove one of
the disk from the array (long story) so I shrunk the array and was in the
process of reducing the number of disks when I lost power and have now lost
the ability to mount the array.
So I'm now in a state where I don't know if 9 or 10 disks are in the array,
all I know is it will not start.  Because I've been swapping disks out I
don't know what order the disks are supposed to be in to re-start the array.

Running Mdadm 3.2.5 on debian kernel 3.2.0-4-amd64

I can 'start' the array with 9/10 disks (using devices a-j alphabetically)
but it is not mountable, the filesystem type is 'jbd' when it should be ext4

What can I do to get this working/what info can I provide so you can help?

Cheers
Andy





