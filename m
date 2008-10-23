From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: backup using raid
Date: Thu, 23 Oct 2008 10:09:50 +0200
Message-ID: <slrngg0cae.ond.Mario.Holbe@darkside.dyn.samba-tng.org>
References: <d5fe39840810222221j26fbaa12t17ba8577186e3dbc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Max Waterman <davidmaxwaterman@fastmail.co.uk> wrote:
> For example, if you have raid1 array, and have an 'extra' spare (is
> spare the correct word) on a removable drive, then it can be

A spare is not enough, since spares get not synched.

> Is this a crazy idea? Have people thought of this before? Are there
> any other gotchas?

I'm doing my backups this way quite a long time now. All my RAID1 have
an empty slot (i.e. I'm running 3-mirror RAID1s degraded to 2 mirrors)
where I plug my backup disks in from time to time. For the bigger RAIDs
I'm using bitmaps to reduce the backup-time.
However, I would never suggest my way to "the average user". There are
lots of things you can easily do wrong. Especially if you do this
on-line: You have to make sure the filesystem is in a clean state when
you pull the backup-disk. With bitmaps, only one backup generation
works. etc. pp. Not to mention all the gotchas "the average fool" would
stumble upon... synching in the wrong direction and things like that :)

Btw... The Intel Matrix Storage Manager has a "mirror on demand" feature
that seems to do something similar. I don't know how they deal with
inconsitent filesystem states, etc.


regards
   Mario
-- 
There are two major products that come from Berkeley: LSD and UNIX.
We don't believe this to be a coincidence.    -- Jeremy S. Anderson

