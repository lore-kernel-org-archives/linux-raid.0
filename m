From: Phil Turmel <philip@turmel.org>
Subject: Re: Issue with Raid 10 super block failing
Date: Mon, 19 Nov 2012 08:39:57 -0500
Message-ID: <50AA36AD.4080100@turmel.org>
References: <CAPAnFc_USC=a8S_0wcsK36Sx=HXgfVTQ4LPC=m9Y9mDFrYrepg@mail.gmail.com> <50A82267.9030802@turmel.org> <CAPAnFc_ZtiE_-6usMHZA56Vx9JOw=gT3O3ABdpb2kcqLV6hcBw@mail.gmail.com> <50A8F247.8060002@turmel.org> <CAPAnFc9_AqQCHnzpNukVJNuaAZ0k9+i0wEZn6SAX=ucF_X_k2g@mail.gmail.com> <50A91487.70806@turmel.org> <CAPAnFc9KLBDhCDt1WYiOye5wvRv=zvBDfL1=8OEYg04VBCLHBQ@mail.gmail.com> <50A92F53.5080100@turmel.org> <CAPAnFc_siNMWcYtYf56dYO1LgkCKPxMDhC-PuMD-18D4jNJcqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPAnFc_siNMWcYtYf56dYO1LgkCKPxMDhC-PuMD-18D4jNJcqw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Drew Reusser <dreusser@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Drew,

On 11/18/2012 02:10 PM, Drew Reusser wrote:

[trim /]

> Sorry - did not know the rules about top posting.  Is there something
> specific in the dmesg you are looking for?  I tried to mount it again
> and copied everything in the buffer.

Here's what I wanted to see:

> [270303.640240] EXT4-fs (md0): VFS: Can't find ext4 filesystem

This suggests that the ext4 superblock isn't near the beginning like
it's supposed to be.  One of the ways that happens with MD raid is if
someone does "mdadm --create" and destroys their old raid superblocks.

I went back and looked at:

>   Creation Time : Thu Nov 15 16:08:02 2012

and:

>     Data Offset : 262144 sectors

So you've re-created the MD array.  That's bad.  Chunk size and Data
offset size and alignment defaults have changed in the past couple
years, so re-creating an array with a different mdadm version can cause
these problems.  You can also lose the original order of devices, with
similar consequences.

(Side note:  there's various pieces of advice floating around the
internet on recovering a broken array that start with re-creating the
array.  It's horribly wrong, and only a last resort, and only after
recording all the details about the original array.)

Unless you kept a copy of "mdadm --examine /dev/sd[abde]1" for the
original array, this will be difficult to debug further.  Your best
chance is to go back to the version of mdadm available when you first
built the system and recreate with that, trying the various device order
combinations.

Don't attempt to mount to check for success.  First, use "fsck -n" to
non-destructively check the FS.  If that gives few errors, then you can
mount the FS.

Phil
