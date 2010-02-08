From: Neil Brown <neilb@suse.de>
Subject: Re: [[Patch mdadm] 2/5] Move the files mdmon opens into /dev/ to
 support handoff after pivotroot
Date: Mon, 8 Feb 2010 14:45:22 +1100
Message-ID: <20100208144522.62b1e568@notabene.brown>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com>
	<1263242294-5353-3-git-send-email-dledford@redhat.com>
	<20100119110930.107ca42e@notabene>
	<4B55F138.7060008@redhat.com>
	<20100204174009.6072ec07@notabene.brown>
	<4B6B15B3.8030205@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B6B15B3.8030205@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-raid@vger.kernel.org, initramfs@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, martin f krafft <madduck@debian.org>, Michal Marek <mmarek@suse.de>, Hans de Goede <hdegoede@redhat.com>, Bill Nottingham <notting@redhat.com>
List-Id: linux-raid.ids

On Thu, 04 Feb 2010 13:45:07 -0500
Doug Ledford <dledford@redhat.com> wrote:

> On 02/04/2010 01:40 AM, Neil Brown wrote:
> > 
> > [cc:ing initramfs because anther part of this thread was already
> >  cc:ed there, but this is the one I wanted to reply to.
> >  cc:ed to various md/mdadm maintainers too]
> > 
> > On Tue, 19 Jan 2010 12:51:52 -0500
> > Doug Ledford <dledford@redhat.com> wrote:
> > 
> >> On 01/18/2010 05:09 PM, Neil Brown wrote:
> >>> On Mon, 11 Jan 2010 15:38:11 -0500
> >>> Doug Ledford <dledford@redhat.com> wrote:
> >>>
> >>>> Signed-off-by: Doug Ledford <dledford@redhat.com>
> >>>
> >>> I really really don't like this.
> >>> I wasn't very keen on allowing the map file to be found in /dev,
> >>> but this it just too ugly.
> >>
> >> I've had to rewrite my response to this a few times :-/
> >>
> >> So, let's be clear: you are objecting to these non device special files
> >> being located under /dev.  Not necessarily *where* they are under /dev,
> >> just that they are under /dev at all.  That's what I get from your
> >> statement above.
> >>
> >> First with devfs, then later with udev, the old unix tradition of only
> >> device special files under /dev is truly dead.  And it should be.  The
> >> files we are creating are needed prior to / filesystem bring up, and
> >> they are needed simply in order to fully populate /dev.  In fact, an
> >> argument can be made that a new tradition, that files related to the
> >> creation and maintenance of device special files belong under /dev with
> >> the files they relate to, has been created.  And this new tradition
> >> makes sense and is elegant on the basis that it requires only one
> >> read/write filesystem mount point during device special file population.
> >>  It also makes sense that this new tradition would supersede the old
> >> tradition on the basis that the old tradition was created prior to the
> >> advent of hot plug and the need to have any read/write data just to
> >> populate your device special files.  The old tradition didn't have the
> >> flexibility to deal with modern hot plug architectures, the new
> >> tradition fixes that, and does so as elegantly as possible.
> >>
> >> That being the case, the big player in the game, udev, is following the
> >> new tradition by creating an entire tree of non device special files
> >> under /dev/.udev and using that to store the information it needs.  And
> >> here mdadm/mdmon are, the small players in the device bring up game that
> >> only have minor bit parts compared to udev, holding up progress and
> >> playing the recalcitrant old fart.  Sorry Neil, but the war has already
> >> been decided and this is a dead battle.  Files related to device special
> >> file bring up belong under /dev along with the files we are creating.
> >> Your claim that these changes are ugly are misplaced and based upon
> >> adherence to a dead tradition that has been replaced by a more sensible
> >> tradition.  Maybe you don't like where they are under /dev, but the fact
> >> that they are under /dev is definitely the right thing to do and is not
> >> in the least bit ugly.
> >>
> >>> I understand there is a problem here, but I don't like this approach to a
> >>> solution.  I'll give it more though when I get home from LCA2010 and see
> >>> what I can come up with.
> >>
> >> Feel free to come up with something different.  But, if your solution
> >> involves maintaining an additional read/write mount area in deference to
> >> a long dead unix tradition, I'm just going to shake my head and patch
> >> your solution away to something sane.
> >>
> > 
> > So I've had a good long think about this.
> > 
> > Your arguments about using /dev do have some merit.  However they sound more
> > like post-hoc justification then genuine motivation.
> > If the train of thought went:
> >    I need some files that are related to device management.  Where shall I
> >    put them?  I know, I'll put them in /dev.
> > then it would be more convincing.  But the logic actually went:
> >    I need some files to persist from early boot through to when the system
> >    has all basic filesystems mounted.  Where shall I put them?  I know, I'll
> >    put them in /dev.
> > That sounds a lot less convincing.
> 
> To be fair, if post-hoc versus initial made any difference what so ever,
> then so would the fact that I wouldn't have chosen to have these files
> exist at all.  I would have made incremental assembly work without a map
> file and I would have made imsm superblock handling be in the kernel.
> So, I'm dealing with the consequences of decisions I didn't make and
> wouldn't have made.  I don't think it's then fair to put some sort of
> 'premeditated' versus 'dealing with the situation' bias on my response.
> 
> > Given that chain of thought I would be more likely to come to the conclusion
> > "I know, I'll put them in /lib/init/rw".  Or at least I would on Debian - 
> > I don't know that any non-Debian-derived distros support that directory.
> 
> I have no idea.  Not one of the files in question belongs there any more
> than in /dev or anywhere else for that matter though, so I wouldn't come
> to that conclusion in your shoes.  But I find it somewhat disheartening
> to hear you disparage my choice to put the files in /dev because "I just
> wanted someplace to throw them" and then you would suggest /lib/init/rw

I think names are really important.  If you were suggesting
   /dev/init/rw
I wouldn't be able to suggest that /lib/init/rw is any better.
But I think it is better than /dev/.

> > But there is still a problem that needs to be solved.
> > 
> > mdmon needs to be running before any a certain class of md arrays (those with
> > user-space managed metadata) can be written to.  Because some filesystems
> > choose to write to the device even when the filesystem is mounted read-only
> > (which should be a hanging offence, but isn't yet)
> 
> Just to sidestep a second on the filesystem issue, there are only two
> choices when it comes to filesystems: allow them to be mounted read only
> (truly read only) and inconsistent or pseudo read only (where the
> filesystem itself is the only thing that writes to the filesystem) and
> be able to guarantee consistency.  The only way for a journaled
> filesystem to provide the guarantee it does is that it writes to the
> device during mount even if its a read only mount.  This is because they
> guarantee to always be able to *restore* a filesystem to a sane state,
> not that it will always *be* in a sane state.  If they didn't do that
> restore on mount, then possibly the thing that is inconsistent is
> /sbin/init and the machine doesn't boot.  In other words, the point of a
> journaled filesystem would be wasted if they didn't do what they do.
> The only other option is to do the replay in page cache and allow the
> page cache and physical device to differ until the filesystem goes read
> write, but I'm not sure that level of complexity is warranted or
> advisable, especially since it could easily confuse anything that tries
> to read from the disks directly.

The other other option is to build a lookup table from the journal (a TLB ??)
and at the very last step before reading from storage, map the sector address
through this lookup table and thus possibly read from the journal instead
from from the main FS.  I'm fairly sure this would work for ext3 journals.
I'm less confident of XFS simply because I am less familar with them.
This would not necessary present a filesystem that is completely consistent
from a 'write' perspective (there could be allocated inodes that aren't
referenced and maybe the free-space bitmaps might not be 100%).  But it
should give all the consistency for reading from the filesystem, which is all
you need.
Yes, it is added complexity in the filesystem, but not much I think, and very
localised.


> 
> > we potentially need mdmon
> > running before the root filesystem is mounted.
> > 
> > Because we want to unmount and completely discard the filesystem that holds
> > the mdmon binary that was run early, we need to kill it and start a new one
> > running from final namespace.  This is also needed as to a small extent the
> > filesystem is used to communicate between mdadm and a running mdmon, and
> > having them have the same root is less confusing.
> > 
> > There are three ways we can achieve this.
> > 
> > 1/ If we can assume that between the time when the original "mount" completes
> >    and when the "mount -o remount,rw" happens the filesystem doesn't write to
> >    the device, then we can simply kill mdmon after the root is mounted, and
> >    restart it before remounting.   However I don't trust filesystem
> >    implementers so I won't recommend that.
> > 
> > 2/ Before the pivot root we can kill the old mdmon and start the new one
> >    chrooted into the final root.
> > 3/ After the pivot root we can kill the old mdmon and start the new one.
> > 
> > Number 2 is the approach that we (Well mostly Dan) originally intended and
> > that the code implements ... or tries to.  It got broken and I never
> > noticed.  I think I have fixed it now for 3.1.2.
> 
> Note, as I recall, Hans switched things to be #3 for various reasons.
> That he switched it to #3 doesn't effect mdmon really, as it still is
> just killing and restarting, but doing it after the pivot root solved a
> couple issues.  I don't recall what they were, you would have to talk to
> Hans about that.
> 
> And you left part of the issue out.  Yes, all the before bring up stuff
> is true, but also true is that we want mdmon to hang around longer than
> anyone else.  By the time mdmon is ready to be shutdown, /var/run is
> once again read only.  So clean up can't be done.  On the other hand, if
> the files for mdmon are on a temporary filesystem that is rebuilt at
> every boot...you get the point.

Yes, I have not been thinking much about the shutdown side of the equation.
Cleanup isn't an issue - you do not need to clean up /var/run when shutting
down because it always happens on boot (and won't happen on a crash anyway).
The only possible issue that I can see is if you want to unmount /var before
setting / to read-only.  You won't be able to do this because mdmon holds an
open file descriptor on /var.
So instead of unmounting /var you would need to remount it read-only, and
then remount '/' read-only.

Is that going to be a problem?


> 
> > However it requires that /var/run exists and is writeable during early boot.
> > I'm not sure that I am really comfortable requiring that.  If the contents
> > of /var/run are not going to persist then it would be better if they didn't
> > exist.  mdadm current relies on that non-existence for proper handing of the
> > "mapfile".
> 
> Can you explain this?  I see nothing in the sources that tells me what
> you mean by the non-existence of /var/run causing the mapfile to be
> handled properly (and I'm not sure that's a valid requirement to put on
> the system anyway because now you are dictating that if another early
> boot application needs read only access to /var/run and we create
> /var/run for that purpose, then it would in some way break mdadm's
> operation).

When mdadm writes to the "mapfile" it tries to create it in /var/run.  If
that doesn't work it tries to create it in /dev.

So if /var/run exists and is writeable during early boot the mapfile will be
created there.  If this is not preserved then the information that was stored
in the mapfile will be lost.

The code for this is all very early in mapfile.c

Yes, I agree that requiring the non-existence of /var/run is somewhat
fragile.  I hadn't completely thought that through until I wrote the above
quoted text.
Is it a reasonable requirement?  I would like to think so as having
a /var/run that spontaneously disappears would seem to break the principle of
least surprise.  Unfortunately I don't like the alternatives (though clearly
you do).

However ... as I note below, this might be a non-issue.  There may not really
be any need to preserve the mapfile across pivot_root.



> >  - the "official" homes for the pid and unix-domain-sock are in /var/run
> >    (preferably /var/run/mdadm/ but Doug said something about needing
> >     /var/run/mdmon/ to placate the monster that is SELinux - I need more
> >     information about that).
> 
> mdmon does not need access to sendmail, so it should not be in the same
> context as the mdadm files.  This allows a more restrictive set of perms
> on mdmon than on mdadm itself.  If we put the mdmon files in
> /var/run/mdadm, then they will have to have the same context as mdadm,
> and because mdadm does so many things, it's already got an overly
> liberal set of permissions compared to what mdmon realistically needs.

And you cannot allow two programs in different contexts to write to the same
directory?  Am I going to have to learn how SELinux works ?(he asked with
dread).

Would it work to use /var/run/mdadm/mdmon ??  I'm not necessarily suggesting
that, just scoping out the range of options.

> 
> >    When mdadm wants to communicate with mdmon it always looks there.
> > 
> >  - There is an alternative home which is /lib/init/rw/mdadm/ by default,
> 
> What happens to the files later in the boot process.  Are they left
> here?  Or are they migrated to an appropriate location later?  If they
> are just left here, then this makes even *less* sense than putting the
> files under /dev as you've created a diversion zone in the filesystem.
> Someplace to throw things that *should* be elsewhere and then leave them
> there.  Hopefully nothing gets left here.  And if nothing gets left
> here, then whether the temporary spot is
> /dev/gonna_be_deleted_after_stuff_is_moved_out or /lib/init/rw makes no
> real difference except in the complexity of the initramfs, and more
> complex is more prone to break so I go with the single rw mount point/area.

The $dev.pid and $dev.sock files belong to the running mdmon.
When we kill the initramfs mdmon and start a new one, these files are removed
and new ones are created in /var/run.  If /var/run is not writeable they are
created in the alternate until /var/run becomes writeable (we
monitor /proc/mounts for changes) and then remove and recreate the files.

The mapfile is read from the alternate if it doesn't exist in /var/run, and
written to /var/run if possible when a write is needed.  So it is
effectively copied at the first update.

And as I said elsewhere, I think names are very important, in part because
people copy them.  And
  /dev/temp_place_for_files_carried_over_from_initramfs/
would be a lot better than /dev/.mdmon as the purpose would be obvious and
the example set for others would be clear.  I would put things in
  /dev/temp_place_for_files_carried_over_from_initramfs/var/run/mdmon
I think.

> 
> >  - mdadm when run in the "take over from previous instance" mode will
> >    look in /lib/init/rw/mdadm for the relevant .pid and .sock files if they
> >    aren't in /var/run/mdadm
> 
> Now I'm a bit concerned.  What happens when the new program starts up?
> If /var/run is now read/write, will the new mdmon then write the files
> in /var/run/mdadm (or mdmon)?  If it does do this in preference to
> /lib/init/rw/mdadm, which I would expect because if it doesn't then the
> issue that Bill Davidson brought up about the issue not being files
> under /dev but actually being certain files *not* being under /var/run
> creeps right back up.  So, are you going to symlink /var/run/mdadm (or
> mdmon) to /lib/init/rw/mdadm?  If so, then you are now doing *exactly*
> as I proposed except in /lib/init/rw/mdadm instead of something like
> /dev/md/.mdadm.  If you don't, then I foresee problems in your future in
> that when mdmon is restarted in the root context, it will write files in
> the real /var/run/mdadm directory, but before mdmon ever shuts down, the
> / filesystem will be readonly, and so those files will never get
> cleaned, and on the next boot you will have stale files there that you
> will have to workaround when it comes mdmon restart time as you'll need
> to ignore or clean out /var/run/mdadm and then use the ones in
> /lib/init/rw/mdadm instead.  I'm sorry Neil, but this is sounding uglier
> and uglier by the minute, not elegant.

But /var/run is cleaned by init scripts.  All non-directories are removed.
I'm fairly sure that all distros do this.

I guess that means that mdmon might find it's .pid and .sock files get
removed after it has created them, which would be embarrassing.
(Of course if /var/run were a tmpfs, there would be no need for
embarrassment...).

.... no, that should be a problem.  As long as we run the
   mdmon --all /
after /var/run has been mounted and clean all should be happiness.

No, I'm not suggesting symlinks.  The "alternate" location is only used
temporarily to carry information across from before to after pivot_root.

> 
> >  - mdmon.8 will list the various options with details.
> > 
> > 
> > So I get to maintain a Unix tradition which might still have some life it
> > after all, and Doug gets a very easy way to patch in his own version of
> > sanity.
> > 
> > (comments always welcome - I have made the changes described above and pushed
> > them to git://neil.brown.name/mdadm, but it isn't to late to change it
> > completely if that turns out to be best)
> 
> I made my proposal in another email.  But, I didn't necessarily argue
> for it.  Since you've argued for yours, and since this is going to a
> mailing list that I don't think significant parts of the original thread
> went to, I'll present mine with the arguments.
> 
> Let's look at this on a file by file basis.  First, for mdadm:
> 
> mdadm.map - incremental map file, needs to be read/write before / is
> read/write if using incremental assembly on root array.  Used to be
> stored in /var/run/mdadm/mdadm.map.  This isn't read/write early enough,
> so incremental assembly would break.  Neil noted something above about
> if /var/run/mdadm doesn't exist and isn't writable then mdadm does
> something different in mdadm current, but I looked in the git repo and
> could not see where the specific problem a readonly /var/run caused
> would be fixed, so I'll assume for now that a readonly /var/run is still
> just as broken as before.  We moved the file to /dev/md/.mdadm.map, but
> Neil didn't like that and made it /dev/.mdadm.map instead.  I would
> actually propose /dev/md/incremental.map as it A) isn't hidden and I
> believe it shouldn't be hidden because of E later on, B) clearly
> indicates the purpose of the file, C) would be in an md specific/owned
> area of /dev, D) is unlike to ever conflict with someone's desired md
> device name, E) is a file specific to the enumeration and bring up of md
> device special files and as such can be argued to belong in /dev anyway,
> and F) solves the problem of needing a read/write /var/run for
> incremental assembly to work.

The mapfile isn't used only for incremental assembly, so "incremental.map"
wouldn't be a good name.
There are (if I remember correctly) two main uses for the "mapfile".

The first is as a cache for the mapping from UUID to md device (major/minor
number).  This is particularly need for Incremental mode so that when a new
device is found, it is easy to find if an md device already is (partially)
assembled for that array.
Being a cache, this information can be recreated at any time - simply read
the meta from some device in each array in record the UUID.  This can be
done with
   mdadm --incremental --rebuild-map
(or mdadm -Ir).
I think "mdadm --incremental" might even do this transparently if the mapfile
cannot be found.

The other use is to record the 'name' of the array.  This 'name' might be
extracted from the metadata (if the metadata stores a name), might be
specified on the mdadm command line or in /etc/mdadm.conf, or might be
generated from the metadata, the chosen minor device and other 'random'
information to generate a unique name in cases where a clash with a
preexisting name cannot be ruled out and would be inconvenient.
This name is used by the udev rules to tell udev what name to create
in /dev/md/.

This isn't a pure cache as the name may be based on user input, or on the
order of array discovery.
However the names created by "mdadm -Ir" during boot should be the same
as any names generated by mdadm calls in the initramfs unless there were
significant differences between mdadm.conf in initramfs versus the final root.

So it is probable that we don't need to preserve the mapfile across
pivot_root.   I think we did before, but there have been a number of
improvements in --incremental since then, particularly the auto-generation of
the mapfile.


> 
> mdadm.pid - this is only used my mdadm in monitor mode, which is not
> started until after the filesystem is read/write.  This can safely
> reside in /var/run/mdadm as it does today, no changes needed.

Agreed.


> 
> Now the files for mdmon:
> 
> devname.pid, devname.sock - we use one mdmon per imsm array and each
> mdmon has its own pid and sock file named after the array it is
> watching.  The problem being that if our root filesystem is on one of
> these imsm arrays, we need mdmon up and running so it can mark the array
> dirty because we will likely cause writes via possible journal replays
> as we mount root.  Likewise, even though there is code in mdmon to clean
> up the pid/sock files, if we are talking about the mdmon for the root
> filesystem, that cleanup can't happen as we need mdmon around to mark
> the array clean after the final writes from going readonly are complete
> (and in fact, during the final halt script on Fedora, we specifically
> exclude *all* mdmon instances from the last killall that we do, then we
> call mdadm to --wait-clean so we know that all the mdmons have marked
> the devices clean after the readonly remount, then we reboot, so we
> don't even kill the mdmon programs, ever).  That means they will never
> clean up their sock and pid files.  As it turns out, being on a tmpfs,
> permanently, is best for the mdmon files.  We need them to be written
> before the system comes up, and we need them to stick around while the
> system goes down (we actually read the pid files to find what pids to
> omit from the global killall we do), but we also want them to go away
> when we reboot.  So, location wise, /dev isn't necessarily the right
> place for them.  However, now that we use udev for dev, semantic wise
> it's perfect.  And we do have the one argument that they are at least
> related to the bring up and take down of device special files.  So, for
> these files, I would actually argue for either /dev/.udev/mdmon with a
> symlink from /var/run/mdmon to this location, or for /dev/md/.mdmon,
> again with a symlink from /var/run/mdmon.

Points where I differ are:
  1/ clean-up: it is a non-issue.  initscripts already do that.
  2/ udev model:  I don't agree that it is a good model to copy.

> 
> So that's my suggestion for how to handle this stuff.
> 
Thanks.

Following this step in the discussion I plan to:

 1/ remove the 'switchroot' option (option 2 in a previous Email).
    from mdmon.  I don't think anyone will use it and it has
    no convincing benefit, and some real costs.
 2/ remove the watching of /proc/mounts to see when /var becomes
    writeable.  Rather I will require (and document) and
    /var/run/ should be writeable (and cleaned) before 
            mdmon --all
    is run to take over from any mdmon that might still be running
    from the initramfs.  This removes any possible race with
    automatic cleaning of /var/run/
 3/ Document that at mdmon may prevent /var from being unmounted and
    recommend "-o remount,ro" as an alternative.
 4/ Use the "alternate run" directory as an alternate location for
    the mapfile, rather than explicitly using /dev/.mdadm.map.
    I should have done this before, but forgot.

If we get two (or more) distros agreeing on a generic name for a scratch area
to carry files over from before the pivot_root, then I will certainly
consider using that rather than /lib/init/rw, even if it is in /dev.
Hopefully it will not have a leading '.' in any name component.

Thanks,
NeilBrown
