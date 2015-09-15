From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Recommendations for RAID setup needed
Date: Tue, 15 Sep 2015 19:08:31 +0100
Message-ID: <55F85E9F.1070100@youngman.org.uk>
References: <CAB1R3sjKb-aXJV+4E5t6OsWid4QB+r6aCteZt+F+57=cWLhHWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB1R3sjKb-aXJV+4E5t6OsWid4QB+r6aCteZt+F+57=cWLhHWw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alex <mysqlstudent@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 15/09/15 18:39, Alex wrote:
> Hi,
> I have a fedora22 system and would like to build a backup server. I
> have four 3TB SATA disks and would like to build a RAID5 array. I
> understand rebuild times can be extensive, possibility creating a
> scenario where another disk fails during that rebuild time, but I'm
> not sure I want to lose the extra space with creating a RAID6 array. I
> believe RAID5 also has faster write speeds?

What disks are you using? Are they proper raid disks? A 12TB array can
have a soft read error every complete pass, and still be within the
disk-manufacturer's specs. If your disks are not raid-compliant, this
will stop your array from rebuilding, ever!

(Chances are, your disks are above spec and won't give a problem. Do you
want to take the risk?)
> 
> Is a 9TB RAID5 partition too risky in terms of rebuild time?
> 
> What's the preferred filesystem for a backup server these days? Should
> I use XFS or ext4?

Throwing something completely different into the mix, how about
considering btrfs? It's not 100% solid yet, so you need to be careful
with it, but if you back up with rsync and the "in place" option, it'll
give you full backups for the cost of incremental.

What you MUST do is KEEP AN EYE ON DISK SPACE! The main failure mode for
btrfs I'm aware of, is that a disk full can cause a fatal error. As in
"I've just trashed the disk - it's 'format c:' time". So if you hit 80%
or so, alarm bells should be ringing. Very loud.
> 
> Thanks,
> Alex

Cheers,
Wol

