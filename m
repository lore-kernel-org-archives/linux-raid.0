From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Need clarification on raid1 resync behavior with bitmap support
Date: Sat, 21 Jul 2007 12:59:49 -0400
Message-ID: <170fa0d20707210959q11153d38u3281062c98d3adb7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/1/06, NeilBrown <neilb@suse.de> wrote:
>
> When an array has a bitmap, a device can be removed and re-added
> and only blocks changes since the removal (as recorded in the bitmap)
> will be resynced.

Neil,

Does the same apply when a bitmap-enabled raid1's member goes faulty?
Meaning even if a member is faulty, when the user removes and re-adds
the faulty device the raid1 rebuild _should_ leverage the bitmap
during a resync right?

I've seen messages like:
[12068875.690255] raid1: raid set md0 active with 2 out of 2 mirrors
[12068875.690284] md0: bitmap file is out of date (0 < 1) -- forcing
full recovery
[12068875.690289] md0: bitmap file is out of date, doing full recovery
[12068875.710214] md0: bitmap initialized from disk: read 5/5 pages,
set 131056 bits, status: 0
[12068875.710222] created bitmap (64 pages) for device md0

Could you share the other situations where a bitmap-enabled raid1
_must_ perform a full recovery?
- Correct me if I'm wrong, but one that comes to mind is when a server
reboots (after cleanly stopping a raid1 array that had a faulty
member) and then either:
1) assembles the array with the previously faulty member now available

2) assembles the array with the same faulty member missing.  The user
later re-adds the faulty member

AFAIK both scenarios would bring about a full resync.

regards,
Mike
