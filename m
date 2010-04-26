From: Andrew Klaassen <clawsoon@yahoo.com>
Subject: RAID10 - Ensure mirrors aren't on same JBOD
Date: Mon, 26 Apr 2010 09:15:53 -0700 (PDT)
Message-ID: <535203.18346.qm@web65402.mail.ac4.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've got 4 fibre channel JBODs that I want to use with mdadm RAID 10.  They have 14 drives each, for a total of 56 drives.

I'd like to create a RAID-10 device where no copies end up on the same JBOD.  IOW, if copy 1 goes to the first drive on the first JBOD, copy 2 should go to the first drive on the third JBOD.  If copy 1 goes to the second drive on the second JBOD, copy 2 should go to the second drive on the fourth JBOD.

How should I order the drives on my mdadm --create command line?

Here's more-or-less what I want in pictures, using 3 drives per JBOD for simplicity, with A,B,a,b,1,2 meaning the same thing they do in the RAID FAQ:

jbod-1-1 Aa1 Ba1 Ca1
jbod-1-2 Ab1 Bb1 Cb1
jbod-1-3 Ac1 Bc1 Cc1

jbod-2-1 Da1 Ea1 Fa1
jbod-2-2 Db1 Eb1 Fb1
jbod-2-3 Dc1 Ec1 Fc1

jbod-3-1 Aa2 Ba2 Ca2
jbod-3-2 Ab2 Bb2 Cb2
jbod-3-3 Ac2 Bc2 Cc2

jbod-4-1 Da2 Ea2 Fa2
jbod-4-2 Db2 Eb2 Fb2
jbod-4-3 Dc2 Ec2 Fc2

The data doesn't have to look exactly like that, as long as the principle is maintained: The copies of the data should be on disks in separate JBODs.

Thanks.

Andrew





