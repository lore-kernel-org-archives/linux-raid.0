From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: safe segmenting of conflicting changes
Date: Tue, 27 Apr 2010 14:04:29 -0400
Message-ID: <4BD7272D.3040500@cfl.rr.com>
References: <loom.20100423T152429-20@post.gmane.org> <4BD1B7E8.9020602@cfl.rr.com> <4BD1E491.3090603@cfl.rr.com> <4BD5C65B.7080707@redhat.com> <4BD5D20B.9020900@cfl.rr.com> <4BD5D5F7.208@redhat.com> <4BD5DEEE.7020208@cfl.rr.com> <4BD5E477.2010201@redhat.com> <4BD5EBC0.9030801@cfl.rr.com> <4BD622DC.7030309@redhat.com> <4BD70ECE.3090200@cfl.rr.com> <4BD71E9D.1040206@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BD71E9D.1040206@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/27/2010 1:27 PM, Doug Ledford wrote:
> And the state "removed" is labeled as such because the device has been
> removed from the list of slave devices that the kernel keeps.  Nothing
> more.  You are reading into it things that weren't intended.  What you
> are reading into it might even be a reasonable interpretation, but it's
> not the actual interpretation.

Then it is a useless and non existent state.  Whether the kernel
currently has the disk open or not is purely ephemeral; there is no
reason to bother recording it in the superblock.  Why bother recording
that bit in the superblock if you are just going to ignore it?  It is
there, so it should not be ignored.

> This is, in fact, completely contrary to where we are heading with
> things.  We in fact *do* want udev invoked incremental rules to readd
> the device after it has been removed.  The entire hotunplug/hotplug
> support I'm working on does *exactly* that.  On device removal is does
> both a fail and remove action, an on device insertion is does a readd or
> add as needed.

Only because failed and removed are currently entangled states rather
than different states.  If they were disentangled so that removed
actually meant something different than failed, then failed would be the
state that you want to automatically pick back up in --incremental, and
removed should only be set when you explicitly --remove.

> So, as I said, you are reading more into "removed" than we intend, and
> we *will* be automatically removing devices when they go away, so it's
> entirely appropriate that if we automatically remove them then we don't
> consider "removed" to be a manual intervention only state, it is a valid
> automatic state and recovery from it should be equally automatic.

Again, failed and removed should be two different states.  If the disk
fails, it should be marked as failed, not removed.

> This is because of the interaction between hotplug discovery and the
> fact that we merely removed the drive from the list of slaves to the
> array, we did not mark the drive as "not to be used".

That's what removed /should/ be since under the current definition, the
state actually does not exist in a persistent way.  You may as well
remove the bit from the superblock entirely since it is always ignored.

> mdadm /dev/md0 -f /dev/sdc1 -r /dev/sdc1; mdadm --zero-superblock /dev/sdc1
> 
> and that should be sufficient to satisfy your needs.  If we race between
> the remove and the zero-superblock with something like a power failure
> then obviously so little will have changed that you can simply repeat
> the procedure until you successfully complete it without a power failure.

Except that now I can't manually re-add the disk to the array.

> This is intentional.  A remove event merely triggers a kernel error
> cycle on the target device.  We don't differentiate between a user
> initiated remove and one that's the result of catastrophic disc failure.

Why not?  Seems to be because of a broken definition of the removed state.

>  However, trying to access a dead disc causes all sorts of bad behavior
> on a real running system with a real disc failure, so once we know a
> disc is bad and we are kicking it from the array, we only try to write
> that data to the good discs so we aren't hosing the system.

That is what failed is for.  Once failed, you can't write to the disk
anymore.  If it isn't failed, you should be able to remove it, and the
superblock should be updated prior to detaching.

> We are specifically going in the opposite direction here.  We *want* to
> automatically readd removed devices because we are implementing
> automatic removal on hot unplug, which means we want automatic addition
> on hot plug.

Again, this is because you are conflating removed, and failed.  If you
treat them separately then you don't have this problem.  Failed happens
automatically, so can be undone automatically, removed does not.

> Again, we are back to the fact that you are interpreting removed to be
> something it isn't.  We can argue about this all day long, but that
> option has had a specific meaning for long enough, and has been around
> long enough, that it can't be changed now without breaking all sorts of
> back compatibility.

This may be true for the --remove switch, but as it stands right now,
the removed flag in the superblock is utterly meaningless.  If you want
--remove to continue to behave the way it does, then you could add a
--really-remove command to set the removed flag, though this seems a
little silly.
