From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH] DM-RAID: Fix RAID10's check for sufficient redundancy
Date: Thu, 10 Jan 2013 09:02:36 -0600
Message-ID: <05723465-2748-4BF8-8268-63989289E5A2@redhat.com>
References: <1357783259.9103.5.camel@f16> <1357783352.9103.7.camel@f16> <20130110170340.6f4d0508@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130110170340.6f4d0508@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>, Alasdair Kergon <agk@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>
List-Id: linux-raid.ids


On Jan 10, 2013, at 12:03 AM, NeilBrown wrote:

> On Wed, 09 Jan 2013 20:02:32 -0600 Jonathan Brassow <jbrassow@redhat.com>
> wrote:
> 
>> 
>> On Wed, 2013-01-09 at 20:00 -0600, Jonathan Brassow wrote:
>>> DM RAID:  Fix RAID10's check for sufficient redundancy
>>> 
>>> Before attempting to activate a RAID array, it is checked for sufficient
>>> redundancy.  That is, we make sure that there are not too many failed
>>> devices - or devices specified for rebuild - to undermine our ability to
>>> activate the array.  The current code performs this check twice - once to
>>> ensure there were not too many devices specified for rebuild by the user
>>> ('validate_rebuild_devices') and again after possibly experiencing a failure
>>> to read the superblock ('analyse_superblocks').  Neither of these checks are
>>> sufficient.  The first check is done properly but with insufficient
>>> information about the possible failure state of the devices to make a good
>>> determination if the array can be activated.  The second check is simply
>>> done wrong in the case of RAID10 because it doesn't account for the
>>> independence of the stripes (i.e. mirror sets).  The solution is to use the
>>> properly written check ('validate_rebuild_devices'), but perform the check
>>> after the superblocks have been read and we know which devices have failed.
>>> This gives us one check instead of two and performs it in a location where
>>> it can be done right.
>>> 
>>> Only RAID10 was affected and it was affected in the following ways:
>>> - the code did not properly catch the condition where a user specified
>>>  a device for rebuild that already had a failed device in the same mirror
>>>  set.  (This condition would, however, be caught at a deeper level in MD.)
>>> - the code triggers a false positive and denies activation when devices in
>>>  independent mirror sets have failed - counting the failures as though they
>>>  were all in the same set.
>>> 
>>> The most likely place this error was introduced (or this patch should have
>>> been included) is in commit 4ec1e369 - first introduced in v3.7-rc1.
>>> 
>>> Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
>> 
>> Neil,
>> 
>> This patch should apply cleanly on top of recent changes, but will not
>> apply cleanly on an older kernel (like 3.7) due to version # changes and
>> introduction of the new 'far' and 'offset' RAID10 algorithms.  If you
>> think this fix should be pushed back into 3.7 rather than just applying
>> on the latest code, I will make a patch for 3.7 - although I'm not
>> certain how I'd handle the version number conflict.
> 
> Thanks Jon, I've applied that patch.
> 
> I can't say if it should be back-ported.  What is the worst-case scenario if
> something goes wrong?  Do the current user-space code contain appropriate
> tests itself too?
> 
> I don't see how version numbers will be a concern - they are just comments in
> a 'Documentation' file aren't they?   If necessary, add extra text to explain
> any possible confusion.

The first condition mentioned above isn't that big of a problem since MD will catch the error deeper down.  The second problem can be pretty bad, but is somewhat limited.  The array will run as you would expect while it is active.  It is only when you attempt to re-activate or repair the array that the problem would occur.  In that case, it would only activate if there are 'copies - 1' or less failed devices present.  This doesn't count any spares that may have been introduced.  So, if you had a 2-stripe, 2-copy array (i.e. 'AA BB') and 2 of the devices failed ('A- B-'), you would not be able to reactivate the array unless you replaced at least one of the devices with a spare (e.g. 'A- BS').  There is no corruption or anything, but loosing more than one device and not having any spares wou
 ld leave you in a pickle.

The version number is tricky because we use it to determine what features a target has.  Testing of a particular feature keys off of this number rather than the kernel version.  I will have unit tests to make sure this bug is fixed and does not resurface, but it will only run if version = 1.4.2.  I can't assign the 3.7 kernel with 1.4.2 because that also implies that the 'far' and 'offset' algorithms are there (introduced in 1.4.1).  Tests for those algorithms would then fail because the feature isn't actually there.  What I could do is choose 1.3.2 (one more than the 3.7 version number, 1.3.1).  This would signal the fix but avoid implying Mikulas' changes or the new algorithms.  Then I would simply test for '(version == 1.3.2) || (version > 1.4.1)' for this particular unit test.  For the
  average bloke, things would just work the way they expect.

 brassow

