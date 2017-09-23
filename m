From: Phil Turmel <philip@turmel.org>
Subject: Re: Raid recovery after unfinished shrink reshape
Date: Sat, 23 Sep 2017 11:18:54 -0400
Message-ID: <d6014486-e55b-7d8b-bf33-36dc4b003344@turmel.org>
References: <CADtnS+yfWJKV8rbna8veSJbR1iCkW0XjGixHRYVxsBQ9p2665A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADtnS+yfWJKV8rbna8veSJbR1iCkW0XjGixHRYVxsBQ9p2665A@mail.gmail.com>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Dan Porter <dpreid@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good morning Dan,

It seems no-one noticed your report.

On 09/22/2017 06:00 AM, Dan Porter wrote:
> Synology weren't willing to help as I shrank an array, which they won't
> support. I don't want to minimise my chances of recovery, so I thought I'd
> reach out here first.>
> The problem I am facing today is that after a reboot, all disks in the
> Synology are showing as 'Initialized'. It also shows there are no Disk Groups
> or Volumes in the system. This was not the case prior to a reboot.

Eww.  I don't know much about Synology's user interface, but it doesn't
sound helpful here.

> Prior to a reboot, a consistency check was stuck on 100.0% for a period of
> about 2 weeks. I'd been unable to find a solution online, but today opted to
> reboot for an update. Currently all of the data is inaccessible, I hope you
> can help me.

Probably.

> On 7/14, the array made it's reshape and completion up to 9 drives in RAID 6.
> At some point, a drive failed, and a replacement drive could not be sourced
> within a reasonable time frame. To keep the array operating at 2-disk
> redundancy, on 8/1 I opted for reducing the array size to 8 disks, with the
> following commands:
> 
> mdadm --grow /dev/md2 --array-size 35134148736
> mdadm --grow -n8 /dev/md2 --backup-file /root/mdadm.md2.backup

I wish your thought process had included how much you were going to be
stressing this array (for reshape) while in such a vulnerable state.

> On 8/8, it was first noticed that the reshape had hung, and was stuck on
> 100.0% according to the synology interface (though 99% on mdadm:
> https://www.irccloud.com/pastebin/eonrdAHu/mdadm%20output

Strange.  This detail report says it is reshaping from 8 => 7, while the
member exams correctly show 9 => 8.

I don't trust the version of mdadm Synology is using in this device, nor
the Synology UI.  Consider taking careful note of all drive serial
numbers and moving the whole array temporarily to another system (if you
can), or booting with a rescue disk (SystemRescueCD is what I recommend).

> The array continued unabated until this Tuesday (9/19) where a reboot occured,
> and the array didn't come back. The backup file i created, annoyingly no
> longer exists, as Synology wipe the root home directory on reboot.

MD doesn't need a backup file in most cases, nowadays, as it can
manipulate the data offset instead.  Halves the number of reads and
writes, too.

> Here is the status from each individual drive (partition) that was part of the
> array: https://pastebin.com/Hn9PbTf3

I don't see anything there that would prevent you assembling except for
the missing backup file.  Which can be dealt with by supplying the
--invalid-backup option.  (You've lost the one stripe that was in the
backup file.)  The reshape was in the area of the array where the
content's metadata is likely to be, so you may have damage to your
filesystem's directories or LVM's metadata.

Use a new folder that Synology won't wipe to hold your backup file.

Phil
