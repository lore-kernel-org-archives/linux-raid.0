From: Dan Kortschak <dan.kortschak@adelaide.edu.au>
Subject: Re: query re: resync not persisting over reboot in rescue mode
Date: Fri, 28 Oct 2016 16:17:28 +1030
Message-ID: <1477633648.22165.12.camel@adelaide.edu.au>
References: <1477266640.7137.13.camel@adelaide.edu.au>
         <87zilprq55.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87zilprq55.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you.

On Fri, 2016-10-28 at 16:36 +1100, NeilBrown wrote:
> On Mon, Oct 24 2016, Dan Kortschak wrote:
> 
> > 
> > First, I'll start with an apology - I have little (~nothing) in the
> > way
> > of hard data to back up this question, but it is now just a matter
> > of
> > personal interest as the problem appears to be fixed.
> > 
> > 
> > Background:
> > 
> > Last week I tried to upgrade a kernel (ubuntu distro 16.04) but
> > that
> > failed due to out of space (the system was originally built when
> > kernels were much smaller and I have now got to the point where it
> > is
> > not possible to have two kernels on the /boot partitian).
> > 
> > On reboot the boot failed with a great deal of disk noise which
> > persisted. Booting into recovery worked, and the noise was now
> > knowable
> Disk noise shouldn't cause the boot to fail....

No. That was not the suggestion :).

Rather that I was able to know what was causing the noise - the raid is
quite noise when resyncing, so the resyncing explained the noise,
rather than the noise explaining the failure.

> > 
> > to be coming from a RAID resync of /dev/md0 (RAID10) after I
> > dropped
> > into a root shell. I allowed this to complete and then went back to
> > resume the normal boot. This failed as before.
> > 
> > Repeating the process above, I found that the RAID was again
> > unsynced
> > an doing a resync.
> > 
> > This has now resolved - I again allowed the resync to complete and
> > then
> > did a /sbin/reboot from the CLI rather than going back to the
> > recovery
> > menu and continuing the boot from the menu.
> > 
> > 
> > Question:
> > 
> > What is a/are likely cause(s) for a resync to not persist over a
> > reboot?
> If /sbin/reboot works and the menu-thing doesn't then the menu-thing
> much be doing something very seriously wrong.
> You might be able to get the resync status to be forgotten if you
> write something to the array and then quickly run "reboot -f -n", or
> maybe "echo b > /proc/sysrq-trigger".
> 
> Given that /sbin/reboot works, I suggest you report this to ubuntu as
> a
> bug.
> 

This is probably true, though I doubt there is much that can be done
from a report given the absence of data that I could provide to help
resolve the issue. I think this may just be "one of those things".

Thanks for your answer.


Dan


