From: Neil Brown <neilb@suse.de>
Subject: Re: quick Q re raid reconstruction
Date: Fri, 2 Dec 2005 09:07:44 +1100
Message-ID: <17295.29744.13292.368041@cse.unsw.edu.au>
References: <438EE429.2030903@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Eyal Lebedinsky on Thursday December 1
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday December 1, eyal@eyal.emu.id.au wrote:
> I have (had) a 4 disk RAID5 /dev/sd[abcd]1.
> 
> sda went bad (really, bad sectors) and is being replaced, hope
> to get a replacement tomorrow.
> 
> While the array was degraded (but running) sdd failed (controller
> trouble) and was marked as failed. The array went down (naturally).
> I am rather sure that sdd is healthy - see examine below.
> 
> Right now /dev/sd[bcd] are seen as sd[abc] until I install the
> missing disk.
> 
> I wish to bring the array up (degraded). Whatever I do mdadm
> refuses to do so
> 	mdadm --assemble --force /dev/sd{a,b,c}1
> should it recognise the array as degraded but good and start it?
> 
> Q1) What is the correct command to bring these three up as
>     degraded?

  mdadm --assemble --force /dev/mdX /dev/sd[abc]1

However this won't work with the superblocks you have. So

  mdadm --create /dev/mdX -l5 -c256 -n4 missing /dev/sda /dev/sdb /dev/sdc


> 
> Q2) When I get the fourth disk, how do I bring the array up
>     ensuring that the good disks (sd[bcd]) are marked as such
>     and the fresh one (sda) is reconstructed (rather than one
>     of the good ones).

As above, then 
  mdadm /dev/mdX --add /dev/newdisk


NeilBrown
