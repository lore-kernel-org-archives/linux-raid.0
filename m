From: Neil Brown <neilb@suse.de>
Subject: Re: [[Patch mdadm] 2/5] Move the files mdmon opens into /dev/ to
 support handoff after pivotroot
Date: Thu, 4 Feb 2010 17:40:09 +1100
Message-ID: <20100204174009.6072ec07@notabene.brown>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com>
	<1263242294-5353-3-git-send-email-dledford@redhat.com>
	<20100119110930.107ca42e@notabene>
	<4B55F138.7060008@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B55F138.7060008@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-raid@vger.kernel.org, initramfs@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, martin f krafft <madduck@debian.org>, Michal Marek <mmarek@suse.de>
List-Id: linux-raid.ids


[cc:ing initramfs because anther part of this thread was already
 cc:ed there, but this is the one I wanted to reply to.
 cc:ed to various md/mdadm maintainers too]

On Tue, 19 Jan 2010 12:51:52 -0500
Doug Ledford <dledford@redhat.com> wrote:

> On 01/18/2010 05:09 PM, Neil Brown wrote:
> > On Mon, 11 Jan 2010 15:38:11 -0500
> > Doug Ledford <dledford@redhat.com> wrote:
> > 
> >> Signed-off-by: Doug Ledford <dledford@redhat.com>
> > 
> > I really really don't like this.
> > I wasn't very keen on allowing the map file to be found in /dev,
> > but this it just too ugly.
> 
> I've had to rewrite my response to this a few times :-/
> 
> So, let's be clear: you are objecting to these non device special files
> being located under /dev.  Not necessarily *where* they are under /dev,
> just that they are under /dev at all.  That's what I get from your
> statement above.
> 
> First with devfs, then later with udev, the old unix tradition of only
> device special files under /dev is truly dead.  And it should be.  The
> files we are creating are needed prior to / filesystem bring up, and
> they are needed simply in order to fully populate /dev.  In fact, an
> argument can be made that a new tradition, that files related to the
> creation and maintenance of device special files belong under /dev with
> the files they relate to, has been created.  And this new tradition
> makes sense and is elegant on the basis that it requires only one
> read/write filesystem mount point during device special file population.
>  It also makes sense that this new tradition would supersede the old
> tradition on the basis that the old tradition was created prior to the
> advent of hot plug and the need to have any read/write data just to
> populate your device special files.  The old tradition didn't have the
> flexibility to deal with modern hot plug architectures, the new
> tradition fixes that, and does so as elegantly as possible.
> 
> That being the case, the big player in the game, udev, is following the
> new tradition by creating an entire tree of non device special files
> under /dev/.udev and using that to store the information it needs.  And
> here mdadm/mdmon are, the small players in the device bring up game that
> only have minor bit parts compared to udev, holding up progress and
> playing the recalcitrant old fart.  Sorry Neil, but the war has already
> been decided and this is a dead battle.  Files related to device special
> file bring up belong under /dev along with the files we are creating.
> Your claim that these changes are ugly are misplaced and based upon
> adherence to a dead tradition that has been replaced by a more sensible
> tradition.  Maybe you don't like where they are under /dev, but the fact
> that they are under /dev is definitely the right thing to do and is not
> in the least bit ugly.
> 
> > I understand there is a problem here, but I don't like this approach to a
> > solution.  I'll give it more though when I get home from LCA2010 and see
> > what I can come up with.
> 
> Feel free to come up with something different.  But, if your solution
> involves maintaining an additional read/write mount area in deference to
> a long dead unix tradition, I'm just going to shake my head and patch
> your solution away to something sane.
> 

So I've had a good long think about this.

Your arguments about using /dev do have some merit.  However they sound more
like post-hoc justification then genuine motivation.
If the train of thought went:
   I need some files that are related to device management.  Where shall I
   put them?  I know, I'll put them in /dev.
then it would be more convincing.  But the logic actually went:
   I need some files to persist from early boot through to when the system
   has all basic filesystems mounted.  Where shall I put them?  I know, I'll
   put them in /dev.
That sounds a lot less convincing.
Given that chain of thought I would be more likely to come to the conclusion
"I know, I'll put them in /lib/init/rw".  Or at least I would on Debian - 
I don't know that any non-Debian-derived distros support that directory.

The fact that Debian does have this directory and stores in there things that
are not related to devices suggests that there is a real need for "persists
from early boot" that does not fit in /dev.  So if I put mdadm bits in /dev
just because I can then I am making the /proc mistake of valuing pragmatics
over elegance, and that is not a good long-term direction.

Your argument that "udev does it so it must be OK" is also fairly weak.  I
would rather be a "recalcitrant old fart" than "wrong" any day.
The fact that udev uses "/dev/.udev" is already an admission of failure.
Prefixing a file name with '.'  effectively says "I don't know where to put
this, and I know it doesn't really belong here, but I cannot think of
anything better so I'm going to do it anyway - shhh don't tell anyone".
If only the founding fathers had given us a $HOME/rc directory for all the
rc files we would be a lot better off.

But there is still a problem that needs to be solved.

mdmon needs to be running before any a certain class of md arrays (those with
user-space managed metadata) can be written to.  Because some filesystems
choose to write to the device even when the filesystem is mounted read-only
(which should be a hanging offence, but isn't yet) we potentially need mdmon
running before the root filesystem is mounted.

Because we want to unmount and completely discard the filesystem that holds
the mdmon binary that was run early, we need to kill it and start a new one
running from final namespace.  This is also needed as to a small extent the
filesystem is used to communicate between mdadm and a running mdmon, and
having them have the same root is less confusing.

There are three ways we can achieve this.

1/ If we can assume that between the time when the original "mount" completes
   and when the "mount -o remount,rw" happens the filesystem doesn't write to
   the device, then we can simply kill mdmon after the root is mounted, and
   restart it before remounting.   However I don't trust filesystem
   implementers so I won't recommend that.

2/ Before the pivot root we can kill the old mdmon and start the new one
   chrooted into the final root.
3/ After the pivot root we can kill the old mdmon and start the new one.

Number 2 is the approach that we (Well mostly Dan) originally intended and
that the code implements ... or tries to.  It got broken and I never
noticed.  I think I have fixed it now for 3.1.2.
However it requires that /var/run exists and is writeable during early boot.
I'm not sure that I am really comfortable requiring that.  If the contents
of /var/run are not going to persist then it would be better if they didn't
exist.  mdadm current relies on that non-existence for proper handing of the
"mapfile".

Number 3 would seem simplest except for the simple task of
finding out which process to kill, and how to wait for it to clean up and
die. 

This is where the suggestion of putting some key files in /dev comes from.
If the mdmon pid file and socket were in /dev then a new mdmon would be able
to find them, signal the pid, and read on the socket until it got EOF
(because the other end was closed).  If they aren't in /dev (or /lib/init/rw)
then it isn't possible to find them.

I could hunt through /proc to find the process called "mdmon" with the right
args, kill that, and wait until it has gone.  But that is rather ugly and I
want to avoid "ugly".

A really key consideration here is to make it all really easy for the distro
package maintainers because debugging issues with early boot is really hard,
and the maintainers have all got more interesting things to do with their
time.
So while I could suggest that the above ugliness be put in a script if you
don't want to make /var/run persist from early boot (my preferred solution),
I'm not going to do that.

I think that what I will do is:

 - the "official" homes for the pid and unix-domain-sock are in /var/run
   (preferably /var/run/mdadm/ but Doug said something about needing
    /var/run/mdmon/ to placate the monster that is SELinux - I need more
    information about that).
   When mdadm wants to communicate with mdmon it always looks there.

 - There is an alternative home which is /lib/init/rw/mdadm/ by default,
   but a 'make' option can easily change that if a distro wants to.
   If I cannot access or mkdir /var/run/mdadm, I will mkdir /lib/init/rw/mdadm
   to have some where to create files

 - mdadm when run in the "take over from previous instance" mode will
   look in /lib/init/rw/mdadm for the relevant .pid and .sock files if they
   aren't in /var/run/mdadm

 - mdmon.8 will list the various options with details.


So I get to maintain a Unix tradition which might still have some life it
after all, and Doug gets a very easy way to patch in his own version of
sanity.

(comments always welcome - I have made the changes described above and pushed
them to git://neil.brown.name/mdadm, but it isn't to late to change it
completely if that turns out to be best)

NeilBrown
