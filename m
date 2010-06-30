From: Neil Brown <neilb@suse.de>
Subject: Re: "mdadm -Dsv" output
Date: Wed, 30 Jun 2010 10:50:56 +1000
Message-ID: <20100630105056.70dbc97a@notabene.brown>
References: <221904.67920.qm@web32407.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <221904.67920.qm@web32407.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adrian Sandor <aditsu@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 29 Jun 2010 16:39:47 -0700 (PDT)
Adrian Sandor <aditsu@yahoo.com> wrote:

> Well, I figured out a few things after spending some time with the mdadm man page:
> - the "_0" suffix is possibly related to the "homehost" (I guess the computer's hostname was modified) and auto-assembly; I have both "n" and "n_0" symlinks in /dev/md on those machines, pointing to the same "/dev/mdn" devices
> - I can use /proc/mdstat for info instead; it looks decent, uses "mdn" names, can be accessed as a normal user, and doesn't require mdadm
> - there's also /proc/partitions - very nifty
> 
> Still, I would like the output of mdadm -Dsv to be improved (regarding formatting and consistency).
> 

Thanks for your comments.

The missing space before "level" is fixed in newer versions of mdadm.

The variability in the array name (/dev/md0 vs /dev/md/0 vs /dev/md/0_0) does
appear clumsy I agree.
The name should be the name that was used to assemble the array.  If mdadm
was asked to choose a name automatically it will do the best it case, which
is different depending on the style of metadata used.

With the original 0.90 metadata, the array only knows a number that can
identify it, so you get /dev/mdNN - e.g. /dev/md0
With 1.x metadata, the array knows a name, so you get /dev/md/XXXX, e.g.
  /dev/md/0 or /dev/md/home
depending on what name was used to create it.

If the array appears to come from a different host, then mdadm appends a _NN
suffix to ensure the name doesn't conflict with the name of a local array.

NeilBrown

