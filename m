From: David Nedved <dnedved@nuvox.net>
Subject: how to change sector size on fibrechannel drives
Date: Wed, 12 Jun 2002 17:17:24 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020612171724.A25071@nuvox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,

I've salvaged some drives from a MTI fibre channel RAID device, and I'm
trying to use them in linux 2.4.18.  When the scsi module loads, it sees
the drives, but reports them all as having the dreaded
"unsupported sector size 528" message.  All the searches I've done seem
to indicate a low-level format of the drives.   The FC card I'm using,
however (Emulex LP8000), doesn't seem to have an option for low-level
formatting.

My fibre channel toys are rather limited, in other words, I don't have
any other controllers with which to low-level these drives.

Am I out of luck?  I wouldn't mind the inefficiency of only using 512
of the 528 bytes in each block if there's some way to override the
default setting... although I would much rather reformat them...

Oh, the drives are all ST136403FC drives if that matters.

Thanks in advance for any clues...

David
