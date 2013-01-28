From: Phil Turmel <philip@turmel.org>
Subject: Re: help recovering a software raid5 device
Date: Sun, 27 Jan 2013 20:28:21 -0500
Message-ID: <5105D435.8090401@turmel.org>
References: <CAAXKdzzERB_zzcdPPzuwdL+afFO334X3bck1EvrRV5rFvEEg6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAXKdzzERB_zzcdPPzuwdL+afFO334X3bck1EvrRV5rFvEEg6Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Theo Cabrerizo Diem <diem@carpediem.sh>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/27/2013 08:52 AM, Theo Cabrerizo Diem wrote:
> Hello,
> 
> I had (hopefully still have ;) ) a raid5 setup using 4x 2Tb HDDs.
> Recently when I was on vacations one disk failed and before I could
> come back (15 days after) a second one failed also.
> 
> Of course I had no backups ;) and to make it worse the raid device had
> luks running on top of it, but that would come later. Just as
> clarfication I did encrypt the md device, and not built a md on top of
> luks devices.
> 
> I did read the wiki, and took a copy of mdadm --examine /dev/sd[ghij]1
> before doing anything. I've tried to run :
> 
> mdadm --create --assume-clean --level=5 --chunk 64 --raid-devices=4
> /dev/md/stuff1 /dev/sdh1 /dev/sdg1 /dev/sdj1 /dev/sdi1

For some reason, people are unwilling to use "--assemble --force", which
is made for these situations.

This is the correct device order, though, so you aren't toast yet.

> Including the "supposed" correct order taken from examine command and
> all possible permutations of the disk orders with no luck.
> 
> From there I have three questions :
> - From the output of --examine I have "Chunk Size: 64K". I suppose I
> should add "--chunk 64" on the mdadm --create line right?

Yes.

> - Should I attempt "mdadm --create" command with just the last 3 good
> disks and a "missing" one or should I attempt with all four ?
> - Any further suggestions to try to recover it ?

I would leave out the disk that failed first (/dev/sdg1, I believe).
Presumably there was still some activity on the system?

> Following my output of mdadm --examine after a reboot (don't know why
> the distro detected and assembled the raid with only two devices in a
> inactive state)

The appended --examine reports show a creation time from 2011, but an
update time from just a little while ago.  Did you cancel the "--create"
operation(s)?  (That would be good, actually.)

Please show the saved "--examine" reports, and current "--examine" reports.

It wouldn't hurt to also post the "smartctl -x" for each of these drives.

Phil
