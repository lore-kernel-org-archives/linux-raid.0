From: Marc MERLIN <marc@merlins.org>
Subject: clearing blocks wrongfully marked as bad if --update=no-bbl can't be used?
Date: Sun, 30 Oct 2016 10:12:34 -0700
Message-ID: <20161030171234.GD28648@merlins.org>
References: <20161030021614.asws67j34ji64qle@merlins.org> <20161030093337.GA3627@metamorpher.de> <20161030153857.GB28648@merlins.org> <20161030161929.GA5582@metamorpher.de> <f6b83548-cb8b-be21-ee4f-cae9f7fa2950@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f6b83548-cb8b-be21-ee4f-cae9f7fa2950@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Neil Brown <neilb@suse.de>
Cc: Andreas Klauer <Andreas.Klauer@metamorpher.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

Could you offer any guidance here? Is there somethign else I can do to clear
those fake bad blocks (the underlying disks are fine, I scanned them)
without rebuilding the array?

On Sun, Oct 30, 2016 at 12:34:56PM -0400, Phil Turmel wrote:
> On 10/30/2016 12:19 PM, Andreas Klauer wrote:
> > On Sun, Oct 30, 2016 at 08:38:57AM -0700, Marc MERLIN wrote:
> >> (mmmh, but even so, rebuilding the spare should have cleared the bad blocks
> >> on at least one drive, no?)
> > 
> > If n+1 disks have bad blocks there's no data to sync over, so they just 
> > propagate and stay bad forever. Or at least that's how it seemed to work 
> > last time I tried it. I'm not familiar with bad blocks. I just turn it off.
> 
> I, too, turn it off.  (I never let it turn on, actually.)
> 
> I'm a little disturbed that this feature has become the default on new
> arrays.  This feature was introduced specifically to support underlying
> storage technologies that cannot perform their own bad block management.
>  And since it doesn't implement any relocation algorithm for blocks
> marked bad, it simply gives up any redundancy for affected sectors.  And
> when there's no remaining redundancy, it simply passes the error up the
> stack.  In this case, your errors were created by known communications
> weaknesses that should always be recoverable with --assemble --force.
> 
> As far as I'm concerned, the bad block system is an incomplete feature
> that should never be used in production, and certainly not on top of any
> storage technology that implements error detection, correction, and
> relocation.  Like, every modern SATA and SAS drive.

Agreed. Just to confirm, I did indeed not willlingly turn this on, and I
really wish I had not been turned on automatically.
As you point out, I've never needed this, and cabling induced problems just
used to kill my array, I would fix the cabling and manually rebuild it.
Now my array doesn't get killed, but it gets rendered not very usable and
cause my filesystem (btrfs) to abort and fail when I access the wrong parts
of it.

I'm now stuck with those fake bad blocks that I can't remove without some
complicated surgery of editting md metadata on disk or recreating an array
on top of the current one with the option disabled and hope things line up.

This really ought to work, or something similar:
myth:~# mdadm --assemble --force --update=no-bbl /dev/md5
mdadm: Cannot remove active bbl from /dev/sdf1
mdadm: Cannot remove active bbl from /dev/sdd1
mdadm: /dev/md5 has been started with 5 drives.
(as in the array was assembled, but it's not really useful without those
fake bad blocks cleared from the bad block list)

And yes I agree that bad blocks should not be a default, now I really wish they
had never been auto turned on, I already lost a week of scanning this array
and looking at problems over thie feature that turns out made a wrong
assumption and doesn't seem to let me clear it :-/

Thanks both for your answer and pointing me in the right direction.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
