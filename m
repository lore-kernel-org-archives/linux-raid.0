From: Steve Kwee <skwee@itw.de>
Subject: Re: raid1 boots with one disk only
Date: Mon, 7 Mar 2005 20:07:58 +0000 (UTC)
Message-ID: <loom.20050307T210328-233@post.gmane.org>
References: <loom.20050304T124945-980@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

found a solution:

The whole thing worked after compiling md and raid1 modules into the kernel and
not as modules

A problem was mkinitrd in debian ubuntu, that is trying to be smart and
complains about a missing raid1 module when building the initial ramdisk with
mkinitrd
I had to patch the mkinitrd shellscript to ignore md and raid1 modules.

Someone told me to add a

  md=1,/dev/hda2,/dev/hdc2

to the kernel boot options to explicitly name the raid devices.
It seems that this has effect only when the drivers are compiled into the
kernel.

The mashine is running fine now. Thanks for your help

