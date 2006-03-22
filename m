From: Dan Christensen <jdc@uwo.ca>
Subject: naming of md devices
Date: Wed, 22 Mar 2006 12:39:01 -0500
Message-ID: <87slpav0p6.fsf@uwo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I currently use kernel autodetection of my raid devices.  I'm finding
that if I use a stock Debian kernel versus a self-compiled kernel
(2.6.15.6), the arrays md0 and md1 are switched, which creates a
problem mounting my root filesystem.

Is there a way to make the names consistent?

I'm happy to get rid of kernel autodetection and instead use
mdadm.conf.  Is this just a matter of changing the partition types?
Or a kernel boot parameter?  Will the Debian kernel/initramfs fall
back to using mdadm to build the arrays?

Thanks for any help,

Dan

