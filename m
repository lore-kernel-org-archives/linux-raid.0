From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: Re: GPT corruption on Primary Header, backup OK, fixing primary nuked
 array -- help?
Date: Tue, 26 Jul 2016 15:24:52 -0500
Message-ID: <5797C714.30409@suddenlinkmail.com>
References: <5796B46B.6060905@suddenlinkmail.com>
 <413b1150-ca38-1907-ea5d-b68ad2f75710@websitemanagers.com.au>
 <5796F4E0.9070206@suddenlinkmail.com> <57971D3C.8040602@suddenlinkmail.com>
 <ff6872cd-98eb-aad2-a71a-7af52050ff30@websitemanagers.com.au>
 <54ca746c-36eb-c1cb-1975-9ecc619fb1b2@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54ca746c-36eb-c1cb-1975-9ecc619fb1b2@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/26/2016 12:14 PM, Phil Turmel wrote:
> The drive probably came with a single large partition in a GPT table.
> mdadm was created using the whole disk, which neither needs nor expects
> there to be a partition table.  (I do not use partitions for my big
> arrays -- whole disks only.)
> 
> When mdadm created the array, it probably wiped out the starting table,
> but not the GPT backup.  Which may or may not be outside the used data
> area of the array.  So you allowed a partition tool to "fix" a partition
> table that isn't being used.  The simplest solution is to zero the first
> 4k of the disk and zero the GPT backup partition table location.
> 
> I suggest re-adding /dev/sdd to the array (not /dev/sdd1, and not
> --add), whether you delete the table or not.  A --re-add will probably
> be nearly instant, since there is a bitmap.

Well, no, that was my stupidity in forgetting to add the '1' at the end of
sdc/sdd during mdadm --create. So you are saying it would be OK to add sdd back
into the array and just use the whole drive, even though there is an
empty/unformatted sdd1 (as there was all along) and that the whole-drive array
is OK?

Will adding it back into the array overwrite the primary PT again, or was that
just a result of initial array creation due to the fact I was using the whole
drive _and_ sdd1 existed as well.

(Well that looks to be the gdisk complaint, the sdd1 table was overwritten, but
that didn't effect the array operation because it was using the whole drive. --
so I could have ignored the gdisk warning and gone about my merry way without
this day of learning and angst? Ah, but what's the fun in that...?)

-- 
David C. Rankin, J.D.,P.E.
