From: David Wuertele <dave-gnus@bfnet.com>
Subject: Re: Please help!  How to reconstitute array (drive order problem)?
Date: Wed, 27 Oct 2004 05:09:53 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <m3y8hs1hwu.fsf@bfnet.com>
References: <m3vfcw3035.fsf@bfnet.com> <200410271831.i9RIVaN05680@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy> Use mdadm to start your array.
Guy> Details: "man mdadm"
Guy> You may need to install mdadm.

Wow, looks like mdadm is a lifesaver.  After reading the man page, it
looks like I should run

    mdadm --assemble --scan /dev/md0 --auto=yes

Will this find all seven of the component partitions that make up the
md0 RAID5?  Or do I have to list those partitions in the config file?

From the man page: "The identity can be given with the --uuid option,
  with the --super- minor option, can be found in the config file, or
  will be taken from the super block on the first component-device
  listed on the command line."

What is an "identity" or a "uuid"?  Does that mean "/dev/md0"?

Thanks,
Dave

