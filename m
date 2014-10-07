From: "Wilson, Jonathan" <piercing_male@hotmail.com>
Subject: Re: Extremely High mismatch_cnt on RAID1 system
Date: Tue, 7 Oct 2014 14:58:54 +0100
Message-ID: <BLU436-SMTP23591E5AC8AD1D0191C134D98A20@phx.gbl>
References: <CAOWcSW5+8ZkWAyXL7VTk9JO+yrozFJS8RwroKqtudkiKD-fvXA@mail.gmail.com>
	 <5433E72E.60805@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5433E72E.60805@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ethan Wilson <ethan.wilson@shiftmail.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2014-10-07 at 15:14 +0200, Ethan Wilson wrote:
> On 04/10/2014 15:46, Dennis Grant wrote:
> > Hello all.
> >
> > ...
> >
> > Even after multiple checks, repairs, and rebuilds, the arrays on the
> > bigger drives (/ and /home) are showing insanely high mismatch_cnt
> > values. This has me concerned.
> >
> 
> Dennis,
> since nobody more knowledgeable replied, I will try.
> 
> Some mismatches on raid1 have been there since always, and nobody ever 
> deeply investigated what they were caused by, nor if they happen on 
> unallocated filesystem space or on real live data. It seems that if LVM 
> is between raid1 and the filesystem then they don't happen anymore, but 
> again nobody is really sure of why.

Would mismatches happen if an "assume clean" was used, either for a good
reason (say to forced a dropped disk back in) or in error, so that while
the data on the secondary disk(s) becomes self correcting as new
writes/updates are performed, to all disks, should the "primary" drive
fail the second one would contain out of sync data, where it had never
been (re)written. Although which is "primary" and which is "secondary"
is I guess not really a good description.

I would have thought that doing a DD to a _FILE_ that fills up the file
system would also reduce the mismatch count, as it would force
"correct(ing)" data to all the disks, baring reserved file system
blocks/areas.
 
NOTE DD to a FILE on the file system, NOT the raid device, the latter
will DESTROY ALL data!





