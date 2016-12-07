From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH v2 03/12] raid5-cache: add a new policy
Date: Wed, 7 Dec 2016 15:36:57 +0100
Message-ID: <ba67c43b-067e-c565-8c70-4bb5544392a3@intel.com>
References: <20161205153113.7268-1-artur.paszkiewicz@intel.com>
 <20161205153113.7268-4-artur.paszkiewicz@intel.com>
 <87d1h44lcj.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87d1h44lcj.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, shli@kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/07/2016 01:46 AM, NeilBrown wrote:
> On Tue, Dec 06 2016, Artur Paszkiewicz wrote:
> 
>> Add a source file for the new policy implementation and allow selecting
>> the policy based on the policy_type parameter in r5l_init_log().
>>
>> Introduce a new flag for rdev state flags to allow enabling the new
>> policy from userspace.
> 
> This seems odd.  Why is this a per-device flag?
> It makes sense for "journal" to be a per-device flag, because only one
> device is the journal device and it is obviously different from the
> others.
> 
> But with the ppl, all devices serve as journal devices.  So we would
> need to set journal_ppl on all devices?  What happens if you set it on
> some, but not others?  I see you get an error.
> 
> I think some sort of array-wide setting would make more sense, would it
> not?

Yes, it would. The problem exists only for external metadata, because
for native there is a feature flag in the superblock and a corresponding
flag in mddev->flags. Patch 12 adds a sysfs attribute to control the
policy at runtime but it would have to be moved out of raid5 personality
into the main md code. I didn't like the idea of adding something
specific to raid5 to generic code and visible in sysfs for unrelated
raid levels.

> And what is an RWH???  A Really Weird Handle ??
> 
> I guess it is probably a Raid5 Write Hole ?  At the very least there
> should be a comment explaining this when you define the enum. (remember,
> you are trying to make it easier for reviewers).

That's right, RWH stands for RAID Write Hole. I think I introduced it in
the cover letter, but I'll explain it also in the code.

> It might almost make sense for bitmap/metadata to be used here.
> It can currently be "external" "internal" "clustered".
> Allow also "journalled" or "partial-partiy-log" ???
> 
> Maybe not ... but I'd definitely prefer a global setting, and one that
> didn't use an obscure abbreviation.

So do you think the sysfs attribute from patch 12 ("rwh_policy") could
be made global? This would simplify things but it doesn't seem right.
And about the abbreviation, should it be called "write_hole_policy" or
"raid5_write_hole_policy"? Maybe using bitmap/metadata is not a bad
idea...

Artur
