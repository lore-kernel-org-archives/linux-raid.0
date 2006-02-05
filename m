From: Neil Brown <neilb@suse.de>
Subject: Re: Newbie questions: Max Active disks, RAID migration, Compiling mdadm 2.3
Date: Mon, 6 Feb 2006 09:49:11 +1100
Message-ID: <17382.32999.717631.194507@cse.unsw.edu.au>
References: <Pine.LNX.4.44.0602051634590.14014-100000@coffee.psychology.mcmaster.ca>
	<7D3A6EBD-6C6D-44B5-BE1C-24BBDB2B391A@mac.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Martin Ritchie on Sunday February 5
Sender: linux-raid-owner@vger.kernel.org
To: Martin Ritchie <ritchiem@mac.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday February 5, ritchiem@mac.com wrote:
> I can see what I did now. Very silly.
> 
> I created a RAID 5 with 4 disks then went about hot adding disks.  
> Silly me thinking it would increase the active space. Of course with  
> the parity being shared through the active disks this doesn't makes  
> sense.
> 
> I was wanting to define a systematic way that I could start with a  
> small number of disks and then expand the RAID as I needed more space  
> (and could afford more disks).
> 
> Is raidreconf the only way for reconfiguring a live system?
> 

raidreconf doesn't allow you to reconfigure a live system - only an
inactive system.
But for the moment, that is the only way, yes.

In 2.6.17 or 2.6.18 it should be possible to restripe a raid5 to have
a larger number of devices.  This can happen while the array is in
active use.
The code is mostly written, and could be used today, but I don't
recommend it on valuable data yet as there are known bugs.

NeilBrown
