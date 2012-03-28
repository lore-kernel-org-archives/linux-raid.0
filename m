From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: re-adding a disk to a raid1 array with bitmap
Date: Wed, 28 Mar 2012 17:17:06 +0200
Message-ID: <4F732B72.6030607@redhat.com>
References: <4F5A2ACE.4090003@redhat.com> <20120328114014.1ac009dc@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120328114014.1ac009dc@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Doug Ledford <dledford@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 03/28/12 02:40, NeilBrown wrote:
> On Fri, 09 Mar 2012 17:07:42 +0100 Jes Sorensen <Jes.Sorensen@redhat.com>
> wrote:
> 
>> > Neil,
>> > 
>> > I have been spinning my head over this for a bit trying to figure out
>> > what is the right solution to this problem.
>> > 
>> > In bedd86b7773fd97f0d708cc0c371c8963ba7ba9a you added a test to reject
>> > re-adding a drive to an array in some cases.
>> > 
>> > The problem I have been looking at is if one has a raid1 with a bitmap.
>> > Basically in the situation where we have one of the drives pulled from
>> > the array, then if I try to add it back, it fails like this:
>> > 
>> > [root@monkeybay ~]#  mdadm -I --run /dev/sdf5
>> > mdadm: failed to add /dev/sdf5 to /dev/md32: Invalid argument.
>> > 
>> > However this works:
>> > 
>> > [root@monkeybay ~]# mdadm -a /dev/md32 /dev/sdf5
>> > mdadm: re-added /dev/sdf5
>> > 
>> > I dug through the kernel and it shows up that the failure is due to this
>> > test in the above mentioned commit:
>> > 
>> > +                    rdev->raid_disk != info->raid_disk)) {
>> > 
>> > So basically when doing -I it seems the disk itself expects to be
>> > raid_disk = 0, whereas the kernel expects it should be raid_disk = 1.
>> > 
>> > I agree with the previous discussion that it makes sense to reject a
>> > drive in the normal case without a bitmap. However it seems illogical to
>> > me that -a works but -I should fail in this case.
>> > 
>> > What would be the right fix here? Relaxing the test in the kernel to not
>> > require the raid_disk numbers match up for a bitmap raid, or should
>> > mdadm be taught to examine the raids and set the expected disk number
>> > before submitting the add_new_disk ioctl?
> Does this patch fix it?
> 
> http://neil.brown.name/git?p=mdadm;a=commitdiff;h=69fe207ed68e560d76a592fd86af32a9d1deca25
> 
> I found it in a collection of half-forgotten patches recently and decided it
> was almost certainly correct, but I didn't remember what motivated it.
> 
> It is entirely possible that it was seeing something like the problem you
> mention.
> 
> The comment for that patch says "This is particularly important for getting
> info.disk.state correct", but maybe it is equally important for getting 
> info.disk.raid_disk correct.
> 
> So I think your last suggestion is right: "mdadm be taught to examine the
> raids and set the expected disk number" - and that patch should do the trick.
> 
> (and thanks for the reminder to reply to this).
> 
> Note that you might need
>    POLICY action=re-add
> in mdadm.conf for this to work.  I don't think it is a given that when a
> recently failed disk is found that it should always be re-added.  So if the
> admin wants that it is reasonable to require the policy be explicitly stated.
> 
> But I'm not sure if this is currently enforced....

Voila! Yes it does indeed. It works even without adding the POLICY
statement to mdadm.conf

Thanks, I love getting bugfixes delivered like this :)

Cheers,
Jes
