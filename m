From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mkraid-problems
Date: Sat, 16 Aug 2003 07:01:58 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16189.19014.742060.8200@gargle.gargle.HOWL>
References: <3F3D4391.2020702@lissners.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Ekkehard Lissner on Friday August 15
To: Ekkehard Lissner <ekkehard@lissners.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday August 15, ekkehard@lissners.de wrote:
> 
> If there is no normal way to reconstruct the array without losing my 
> data, how about patching the timestamps with
> a disk-editor? Which bytes must be read from sdc1 and be written to sdd1 
> and sdb1?
> 

Your array sounds very sick, though it is not at all clear what the
problem really is.

I suggest you get mdadm, and use
  mdadm --assemble --force /dev/md0 /dev/sd[bcd]1

It will try to assemble the array for force-update event counts as
necessary.

What kernel version are you running?

NeilBrown
