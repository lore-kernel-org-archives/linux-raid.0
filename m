From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [patch] raidstart problem -  weakness or bug
Date: Fri, 14 Nov 2003 11:23:48 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16308.8340.389976.887660@notabene.cse.unsw.edu.au>
References: <20031114000736.GA26329@computer-surgery.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Roger Gammans on Friday November 14
To: Roger Gammans <roger@computer-surgery.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday November 14, roger@computer-surgery.co.uk wrote:
> Hi
> 
> I'v decided to build a raid set for on one of my machines here 
> and while setting I did a simulated fail test so I knew what to expect
> out of the fail/recovery process.
> 
> In the course of this I discover that raidstart (I used debian stable
> to start with but reproduced and patched on raidtools 1.00-3) 
> won't start and array where the  first drive listed in /etc/raidtab
> has failed - or more accurately whose superblock is not readable.
> 
> An afternoons read through the code has led me to suggest this
> patch as a fix. No doubt the more experienced raid hands will tell
> me this is wrong for some subtle reason i can't see. ;_)
> 
> So what have I got wrong ?
> 

You have tried to fix a program that really is not worth saving.
raidstart should be erradicated from the universe.  It is more of a
problem than a solution. :-)

Apart from the problem you noticed which is fixable, there is the fact
that it depends on device numbers being stable and uses the device
numbers out of the superblock of one device to find all other devices.
This mostly works OK with IDE, but with SCSI, devices can change there
number (major/minor) and name quite easily and then raidstart cannot
cope at all.

Use mdadm - it has a much better approach.
Debian/stable has the  fairly old 0.7.2, which should work but is not
the latest by a long way.  You can find the latest at
    http://www.kernel.org/pub/linux/utils/raid/mdadm/

NeilBrown
