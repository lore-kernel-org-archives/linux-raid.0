From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Status of discard support in MD RAID
Date: Sat, 13 Sep 2014 14:19:06 -0600
Message-ID: <68C63E6D-EECB-4AE9-9697-8B5B1C3DF4A2@colorremedies.com>
References: <1ED0286A-56DA-491D-853A-1C1045449201@redhat.com> <26CB8B36-9CD9-4EE0-BFF2-4B183DBDD033@colorremedies.com> <20140912153915.473bc562@natsu>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140912153915.473bc562@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Sep 12, 2014, at 3:39 AM, Roman Mamedov <rm@romanrm.net> wrote:

> On Thu, 11 Sep 2014 18:46:04 -0600
> Chris Murphy <lists@colorremedies.com> wrote:
> 
>> If it doesn't, a check check > md/sync_action will report mismatches in
>> md/mismatch_cnt; and a repair will probably corrupt the volume.
> 
> At least with RAID1/10, why would it?

It's a good question.

On the one hand:
ftp://ftp.t10.org/t10/document.08/08-347r1.pdf

In particular slides 5, 8, 9.

And then on the other hand:
https://lkml.org/lkml/2010/11/19/193

It's an overstatement to have said "repair will probably corrupt" when everything is working normally. I can't know that. What happens in the case of a crash, power failure, or a drive that dies? If drive 1of2 fully dies, then the user has a more certain outcome, at least it's one non-deterministic drive 2of2 remaining to use as a source to rebuild with a new drive.

But the non-deterministic output from SSD trimmed blocks means the user can't depend on raid mechanism to confirm whether the rebuild worked. There will always be mismatches on check, and we have no way of knowing if those mismatches occur only in trimmed areas that we don't care about, or in data/metadata areas that we do care about. What's the work around? Separately degrade mount each mirror and produce a file checksum list and compare them? Ick.

ZFS and Btrfs wouldn't get tripped up, because their scrubs only operate on in-use blocks. So that's also a plausible work around for non-deterministic trim. But I don't know how well tested delete followed by trim is on either of them. Like Ted says, the filesystem has to be certain the delete has committed to stable media before issuing trim or all bets are off.


> 
>> and you can't do repair type scrubs.
> 
> If the FS issues TRIM on a certain region, by definition it no longer cares
> about what's stored there (as it's is no longer in use by the FS). So even if
> a repair ends up coping some data from one SSD to another, in effect changing
> the contents of that region, this should not affect anything whatsoever from
> the FS standpoint.

That's true, it should not, so long as everything else is working normally and correctly. But we still lose the ability to verify the veracity of the repair.


Chris Murphy

