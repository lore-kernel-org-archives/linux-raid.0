From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Question about recovery via mdadm
Date: Tue, 18 Feb 2003 16:45:56 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15953.51348.27588.758894@notabene.cse.unsw.edu.au>
References: <A5974D8E5F98D511BB910002A50A66470580D627@hdsmsx103.hd.intel.com>
	<15948.9979.534439.238616@notabene.cse.unsw.edu.au>
	<28330000.1045391539@shieldbreaker.l33tskillz.org>
	<15952.3121.511942.788471@notabene.cse.unsw.edu.au>
	<42790000.1045443956@pcmy.sei.cmu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from James Ralston on Sunday February 16
To: James Ralston <qralston+ml.linux-raid@andrew.cmu.edu>
Cc: "Cress, Andrew R" <andrew.r.cress@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday February 16, qralston+ml.linux-raid@andrew.cmu.edu wrote:
> On 2003-02-17 at 09:09:53+1100 Neil Brown <neilb@cse.unsw.edu.au> wrote:
> 
> > > https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=82815
> > 
> > I think that bug should be fixed by the follow patch which has been
> > submitted and accepted and should be in 2.4.21.
> 
> I already tried backporting the md driver from 2.4.21-pre3 (which
> contains the patch you included).  Unfortunately, not only does it not
> fix the problem, but it makes it worse: with the patch applied, after
> the Oops occurs, touching the md device in any way hangs.  This
> includes the "md: stopping all md devices" which occurs at shutdown,
> so as a result, at shutdown, the entire machine hangs, and you have to
> go physically reset or power cycle the machine.
> 
> I've appended the Oops I generated using the md driver from
> 2.4.21-pre3 in Red Hat's kernel-2.4.18-19.8.0.  This is how I produced
> it:
> 
>     $ mdadm --create /dev/md0 --verbose --level=mirror --raid-devices=2 /dev/sdb1 /dev/sdc1
>     <wait for sync>
>     $ mdadm /dev/md0 -f /dev/sdc1 -r /dev/sdc1 -a /dev/sdc1
>     <wait for sync>
>     $ mdadm /dev/md0 -f /dev/sdb1 -r /dev/sdb1 -a /dev/sdb1
>     <mdrecovery generates Oops>
> 
> As I said before, I'm at a loss to figure out where the bug is, but if
> you have any further things to try, I'd be happy to give them a
> whirl...

Hmmm... you can probasbly alleviate the symptoms with:

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~  2003-02-17 13:24:11.000000000 +1100
+++ ./drivers/md/md.c   2003-02-17 13:24:59.000000000 +1100
@@ -1048,7 +1048,7 @@ repeat:
                        printk("(skipping faulty ");
                if (rdev->alias_device)
                        printk("(skipping alias ");
-               if (disk_faulty(&rdev->sb->this_disk)) {
+               if (!rdev->faulty && disk_faulty(&rdev->sb->this_disk)) {
                        printk("(skipping new-faulty %s )\n",
                               partition_name(rdev->dev));
                        continue;

but the real problem is a lack of locking.  A lot of work went into
2.5 to get the locking right in the md driver and it resulted in a
substantial shake-up of the code.  I do have a patch that does better
locking for 2.4, but it is rather ugly.... maybe I should revisit it.

NeilBrown
