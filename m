From: Glenn Greibesland <glenngreibesland@gmail.com>
Subject: Re: Raid6 recovery
Date: Sat, 21 Mar 2020 23:12:12 +0100
Message-ID: <CA+9eyiicKrPh9YTrGN5FjOU7zMVMqO3=8yGszWkV67fJxrtKrw@mail.gmail.com>
References: <CA+9eyijuUEJ7Y8BuxkKaZ=v8zbPpwixOezngPjtJzaLsBd+A4Q@mail.gmail.com>
 <5E75163B.2050602@youngman.org.uk> <CA+9eyigMV-E=FwtXDWZszSsV6JOxxFOFVh6WzmeH=OC3heMUHw@mail.gmail.com>
 <ab2a40b6-b4ab-9ff8-aef6-02d8cce8d587@youngman.org.uk> <CA+9eyig8U2Tzi1wF97k7eDu5vKg5Jc2sRXKaw0OCy7Cbc9HMog@mail.gmail.com>
 <c55be05d-22ee-4676-7878-5bf99ccc80f9@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c55be05d-22ee-4676-7878-5bf99ccc80f9@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: antlists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

l=C3=B8r. 21. mar. 2020 kl. 20:24 skrev Phil Turmel <philip@turmel.org>:
> {Convention on kernel.org lists is to interleave replies or bottom post,
> and to trim non-relevant quoted material.  Please do so in the future.}

Sorry about that.

> Since you seem comfortable reading source code, you might consider byte
> editing that drive's superblock to restore it to "active device 10".
> That is what I would do.  With that corrected, --assemble --force should
> give you a running array.

I did some more digging in the source code, but it looks like the
superblock is replicated onto all drives and that I probably would
have to edit the superblock of all disks, but I'm not sure.
With newfound confidence (thanks) I decided to try the --create
--asume-clean option instead.
It worked fine and I am now copying the data that is not already backed up.

I'll wait until the data is copied onto other drives before I add the
last two disks to the array and start rebuilding.

> I also noted the drives with Error Recovery Control turned off.  That is
> not an issue while your array has no redundancy, but is catastrophic in
> any normal array.  It is as bad as having a drive that doesn't do ERC at
> all.  Don't do that.  Do read the "Timeout Mismatch" documentation that
> Anthony recommended, if you haven't yet.

I'll read up on this documentation to ensure reliable operation in the
future. Thanks Phil and Anthony.

So to summarize what happened and what I've learned:
I had a RAID6 array with only 16 out of 18 working drives.
I received an email from mdadm saying another drive failed.
I ran a full offline smart test that completed successfuly.

The drive was in F (failed) state. I used --re-add and mdadm overwrote
the superblock turning it into a spare drive instead of putting the
drive back into slot 10.
I should have used --assemble --force.

Am I correct?

Glenn
