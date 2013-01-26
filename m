From: Phil Turmel <philip@turmel.org>
Subject: Re: Recovering from an URE on a RAID5 rebuild/resize
Date: Sat, 26 Jan 2013 18:40:54 -0500
Message-ID: <51046986.1080300@turmel.org>
References: <20130125171459.5f855c92@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130125171459.5f855c92@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/25/2013 06:14 AM, Roman Mamedov wrote:
> Hello,
> 
> Recently there has been some talk on this list, about probability of seeing an
> URE during a RAID5 rebuild on modern large (e.g. 2TB) drives.
> 
> I would like to ask for some advice of what would be the best way to proceed
> when such an URE is encountered. This is mostly theoretical, no real situation
> at hand at the moment.
> 
> As I understand, a RAID5 that is being resized or rebuilt, has no redundancy;
> it is essentially as reliable as a RAID0 of total members-1, or even less.
> 
> So on an unreadable sector that mdadm needs to read (because it has no
> redundancy to recover it from), mdadm will:
> 
>   - mark the corresponding array member as "failed";
>   - mark the one that was being rebuilt/resized onto as "spare";
>   - and the whole array as down and "not enough members to start the array".

No.  On modern kernels, you have to experience multiple read errors in a
short time (compile time constant 20, if I recall correctly) before the
device is failed.  So for a single unrecoverable sector, or a small
number of them, the error will be passed to the filesystem, and possibly
on to the application.

> Let's assume only a couple of sectors on that member were unreadable, and then
> their readability was restored (either by drive replacement or by overwriting
> them to making the drive remap), and I would be okay with losing data that was
> in those sectors.

If you are in this situation, rewriting the files that contain the bad
sectors is an option, if the sectors are in a file at all.  If they hold
filesystem metadata, you might lose more.

> What would be the best way to proceed from there?

1) With the array stopped, dd_rescue the array members onto new drives.
 Allow bad sectors to be replaced with zeroes, possibly keep a record of
the bad sector locations.  Set the original drives aside for later
forensics, if needed.

2) Start up with the new members.  Add another new drive and allow the
rebuild to finish.  fsck the filesystem and assess the corruption,
possibly rewriting files identified with the bad block data from (1).

3) Take one of the original drives, zero its superblock, add it to the
array, and reshape to raid6.

4) Use regular "check" scrubs with raid6 to never be in the situation again.

HTH,

Phil
