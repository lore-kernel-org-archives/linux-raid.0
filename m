From: Sean Puttergill <puttergi@yahoo.ca>
Subject: Re: Auto-assembling arrays using mdadm
Date: Thu, 9 Mar 2006 23:58:49 -0500 (EST)
Message-ID: <20060310045849.65628.qmail@web35304.mail.mud.yahoo.com>
References: <Pine.LNX.4.64.0603091344010.32502@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0603091344010.32502@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

That did the trick, except you must do:

mdadm --examine --scan --config=tmp.mdadm.conf
>>tmp.mdadm.conf

instead of:

mdadm --detail --scan --config=tmp.mdadm.conf
>>tmp.mdadm.conf

I assume that this method would have the same problems
with conflicting minor number.  Will have to add an
intermediate step to process the tmp.mdadm.conf file
to uniquify the RAID array device names (i.e. remove
duplicate /dev/md0, etc.).


Thanks for the tip.  I personally think mdadm should
be modified to do this all in one step (including
dealing with minor number conflicts).


Sean

--- dean gaudet <dean@arctic.org> wrote:

> you know i've been bitten by that several times...
> the kernel sees the 
> autodetect partition type of a disk which used to
> belong in another box 
> (which for various reasons i've not yet been able to
> zero the old raid 
> superblock)... and brings up a raid minor which
> conflicts with another 
> array already present in the system... which causes
> device renaming to 
> occur and can mess up the boot.  (although if i'm
> using UUIDs or labels 
> for mounting the filesystems it can almost work --
> there are still a few 
> cases where those don't help... such as xfs external
> log partition.)
> 
> i suppose what i suggested doesn't do what you
> want... but i prefer not 
> using kernel autoassembly these days because of the
> above problem.
> 
> the 1.12 man page has more examples which can help
> you...
> 
> 	echo "DEVICE partitions" >tmp.mdadm.conf
> 	mdadm --detail --scan --config=tmp.mdadm.conf
> >>tmp.mdadm.conf
> 	mdadm --assemble --scan --config=tmp.mdadm.conf
> 
> i think that'll do what you want...
> 
> -dean
> -
> To unsubscribe from this list: send the line
> "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at 
> http://vger.kernel.org/majordomo-info.html
> 


__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
