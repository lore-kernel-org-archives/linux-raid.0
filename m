From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Floating Spare
Date: Tue, 9 Apr 2002 09:37:38 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15538.10690.791595.74445@notabene.cse.unsw.edu.au>
References: <20020408184316Z313731-22651+2106@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
In-Reply-To: message from SoulBlazer on Monday April 8
To: SoulBlazer <soul@lamp-post.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday April 8, soul@lamp-post.net wrote:
> Can you share 2 or 3 'spare-disks' between multiple raid sets?
> 
> Eg. I have a 22 disk array chopped into multiple 4 disk raid-5 volumes, this 
> leaves me with 2 disks left over..  Can I assign these two drives as floating 
> spares incase of failure.. this will obviously be a 'first come first serve' 
> scenario for raid failure.. but its better then not using them.

The kernel driver doesn't directly support this.
However "mdadm" does.
Get  mdadm from
   http://www.cse.unsw.edu.au/~neilb/source/mdadm/

compile, and read the doco.

You describe your arrays in /etc/mdadm.conf and mention that they are
both in the same "spare-group", and then run "mdadm --monitor".
This periodically polls the arrays, emails you when there are
failures, and will move spares between arrays if needed.

NeilBrown

/etc/mdadm.conf:
 
  DEVICES /dev/disc/*/*
  array /dev/md/0 uuid=whatever spare-group=A
  array /dev/md/1 uuid=somethingelse spare-group=A

You only need "uuid=" if you want to use mdadm to assemble your arrays
aswell.

NeilBrown
