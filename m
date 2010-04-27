From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: safe segmenting of conflicting changes
Date: Tue, 27 Apr 2010 12:20:30 -0400
Message-ID: <4BD70ECE.3090200@cfl.rr.com>
References: <loom.20100423T152429-20@post.gmane.org> <4BD1B7E8.9020602@cfl.rr.com> <4BD1E491.3090603@cfl.rr.com> <4BD5C65B.7080707@redhat.com> <4BD5D20B.9020900@cfl.rr.com> <4BD5D5F7.208@redhat.com> <4BD5DEEE.7020208@cfl.rr.com> <4BD5E477.2010201@redhat.com> <4BD5EBC0.9030801@cfl.rr.com> <4BD622DC.7030309@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BD622DC.7030309@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/26/2010 7:33 PM, Doug Ledford wrote:
> And in English raid means a hostile or predatory incursion, it has
> nothing to do with disc drives.  And in English cat is an animal you
> pet.  So technical jargon and regular English don't always agree, what's
> your point?

RAID is an acronym that just happens to also spell an English word.
Removed and Failed are not, and your cat example is a complete non
sequitur.  My point is that when naming technical things you should do
so sanely.  You wouldn't label the state a disk goes into when it keeps
failing IO requests as "Iceland" would you?  Of course not.  The state
is named failed because the disk has failed.

>>  Elements which are not part of the array should not
>> be MADE part of the array just because they happen to be there.
> 
> Sorry, but that's just not going to happen, ever.  There any number of
> valid reasons why someone might want to temporarily remove a drive from
> an array and then readd it back later, and when they readd it back they
> want it to come back, and they want it to know that it used to be part
> of the array and only resync the necessary bits (if you have a write
> intent bitmap, otherwise it resyncs the whole thing).

I didn't say never allow it to be added back, I said don't go doing it
automatically.  An explicit add should, of course, work as it does now,
but it should not be added just because udev decided it has appeared and
called mdadm --incremental on it.

> No, it's not.  The udev rules that add the drive don't race with
> manually removing it because they don't act on change events, only add
> events.

And who is to say that you won't get one of those?  A power failure
after --remove and when the system comes back up, viola, the disk gets
put back into the array.  Or maybe your hotplug environment has a loose
cable that slips out and you put it back.  This clearly violates the
principal of least surprise.

> Not going to happen.  Doing what you request would undo a number of very
> useful features in the raid stack.  So you might as well save your
> breath, we aren't going to make a remove event equivalent to a zero
> superblock event because then the entire --readd option would be
> rendered useless.

I didn't say that.  I said that a remove event 1) should actually bother
recording the removed state on the disk being removed ( right now it
only records it on the other disks ), and 2) the fact that the disk is
in the removed state should prevent --incremental from automatically
re-adding it.

> Because there are both transient and permanent failures.  Experience
> caused us to switch from treating all failures as permanent to treating
> failures as transient and picking up where we left off if at all
> possible because too many people were having a single transient failure
> render their array degraded, only to have a real issue come up sometime
> later that then meant the array was no longer degraded, but entirely
> dead.  The job of the raid stack is to survive as much failure as
> possible before dying itself.  We can't do that if we allow a single,
> transient event to cause us to stop using something entirely.

That's a good thing and is why it is fine for --incremental to activate
a disk in the failed state if it appears to have returned to being
operational and it is safe to do so ( meaning hasn't also been activated
degraded ).  It should not do this for the removed state however.

> Besides, what you seem to be forgetting is that those events that make
> us genuinely not want to use a device also make it so that at the next
> reboot the device generally isn't available or seen by the OS
> (controller failure, massive failure of the platter, etc).  Simply
> failing and removing a device using mdadm mimics a transient failure.
> If you fail, remove, then zero-superblock then you mimic a permanent
> failure.  There you go, you have a choice.

Failed and removed are two different states; they should have different
behaviors.  Failed = temporary, removed = more permanent.
zero-superblock is completely permanent.  Removed should be a good
middle ground where you still CAN re-add the device, but it should not
be done automatically.
