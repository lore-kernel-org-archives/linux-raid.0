From: Neil Brown <neilb@suse.de>
Subject: Re: raid5 two disk failure
Date: Wed, 2 Nov 2005 21:25:13 +1100
Message-ID: <17256.37897.413720.71588@cse.unsw.edu.au>
References: <loom.20051101T170851-919@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Meik Nienaber on Tuesday November 1
Sender: linux-raid-owner@vger.kernel.org
To: Meik Nienaber <usenet@saeder-krupp.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday November 1, usenet@saeder-krupp.com wrote:
> Hi,
> 
> The story:
> 
> - raid5 set with four disks
> - after power outage two disks were marked faulty
> - reassembled the set with 3 disks (1,2,3)
> - added the forth disk
> - reconstruction of the set failed because of an uncorrectable sector of disk 3
> - tried to reassemble the set with disk 1,2,4. Not possible because disk 4 is in
> spare mode.
> 
> Any opportunities to get the set back with disks 1,2,4? Thanks in advance for 
> your help.
> 
> mdadm v1.9.0
> linux 2.6.12.3

Best bet is to re-create the array as in

 mdadm -C /dev/mdX -l5 -n4 1 2 missing 4

However make sure that if you used non-defaults for chunksize or
layout, you preserved those non-defaults.
e.g. run
  mdadm -E 1

first, and look at what it says for "Chunk Size" and "Layout", and
uses those explicitly.

(ofcourse, substitute the real device names for 1, 2, 4 above).

NeilBrown
