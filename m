From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: array degraded after reboot
Date: Fri, 2 May 2003 14:47:50 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16049.63606.342681.599411@notabene.cse.unsw.edu.au>
References: <3EB1ED3B.4060304@uclink4.berkeley.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jeremy Huddleston on Thursday May 1
To: Jeremy Huddleston <jeremyhu@uclink4.berkeley.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday May 1, jeremyhu@uclink4.berkeley.edu wrote:
> I wanted to remove /dev/hdk6 from my array and replace it with a new 
> drive at /dev/hdj6 (I know about the efficiency problems involved with 
> this, but trust me that this is what I want to do for some other 
> reasons), so I did the following:
> 
> mdadm -f /dev/md6 /dev/hdk6
> mdadm -r /dev/md6 /dev/hdk6
> mdadm -a /dev/md6 /dev/hdj6
> 
> The RAID reonsctucted itself, and it was working fine, so I rebooted the 
> machine and removed the /dev/hdk hard drive from my computer.  When 
> linux started up again, I checked /proc/mdstat, and it said that the 
> RAID was running in degraded mode without /dev/hdj6.

At a guess, I would say that you are depending on in-kernel
auto-detect to assemble your arrays, and you haven't set the partition
type of hdj6 to "Linux Raid Autodetect"

NeilBrown
