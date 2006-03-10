From: Neil Brown <neilb@suse.de>
Subject: Re: Auto-assembling arrays using mdadm
Date: Fri, 10 Mar 2006 16:28:56 +1100
Message-ID: <17425.3736.352007.884424@cse.unsw.edu.au>
References: <Pine.LNX.4.64.0603091344010.32502@twinlark.arctic.org>
	<20060310045849.65628.qmail@web35304.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Sean Puttergill on Thursday March 9
Sender: linux-raid-owner@vger.kernel.org
To: Sean Puttergill <puttergi@yahoo.ca>
Cc: dean gaudet <dean@arctic.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday March 9, puttergi@yahoo.ca wrote:

It is not clear to me that this is something that you would ever want
to do, just as you would not want an automatic process to mount every
filesystem that it finds on any disk drive. (I agree with dean here).

Maybe if you explained why you wanted to do this, a more focussed
response could be provided.


> That did the trick, except you must do:
> 
> mdadm --examine --scan --config=tmp.mdadm.conf
> >>tmp.mdadm.conf
> 
> instead of:
> 
> mdadm --detail --scan --config=tmp.mdadm.conf
> >>tmp.mdadm.conf
> 
> I assume that this method would have the same problems
> with conflicting minor number.  Will have to add an
> intermediate step to process the tmp.mdadm.conf file
> to uniquify the RAID array device names (i.e. remove
> duplicate /dev/md0, etc.).
> 
> 
> Thanks for the tip.  I personally think mdadm should
> be modified to do this all in one step (including
> dealing with minor number conflicts).

This is unlikely to happen.

It is, however, possible that "mdadm --examine --scan" could grow an option
whereby the device names are given as
  /dev/md/UUID:OF:THE:ARRAY:THAT:WAS:FOUND

This, toogether with giving 'auto=mdp' could avoid and issues with
minor number conflicts.  Then:
  echo DEV partitions > /etc/mdadm.conf
  mdadm -Es --new-flag >> /etc/mdadm.conf
  mdadm -As --auto-mdp
would assemble all arrays, which is what you claim to want.

NeilBrown
