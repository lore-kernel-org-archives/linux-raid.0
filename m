From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID-1 reconstruction
Date: Fri, 22 Apr 2005 11:29:44 +1000
Message-ID: <17000.21384.683427.186390@cse.unsw.edu.au>
References: <20050421182550.GA7926@jose.lug.udel.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from ross@lug.udel.edu on Thursday April 21
Sender: linux-raid-owner@vger.kernel.org
To: ross@lug.udel.edu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday April 21, ross@lug.udel.edu wrote:
> Hello everyone,
> 
> I've got three RAID-1 setups in my workstation, they work like champs
> and I'm amazed at the quality.  Thanks!
> 
> I just had a realtime application deadlock the system.  The only thing
> I could do was Magic SysRQ out of it.  Hit SysRq-s, SysRq-u, SysRq-b.
> 
> When the system rebooted, my RAID all came back as in sync.  This
> surprised me!  The md assembly seems to have gone well.
> 
> Is this a new feature?  I fully expected to have to rebuild my arrays.
> 
> Thanks - if it's correct, I must say I'm surprised!

This is a new feature in 2.6 (if you are using 2.4, something is
wrong).

If there have been no writes to an MD array for 20millisecs, then it
is marked as clean.  So if your machine crashes while the array is
idle, it should come up clean.
It looks like this happened in your case, which is good.

Thanks for the positive feedback.

NeilBrown
