From: Ethan Wilson <ethan.wilson@shiftmail.org>
Subject: Re: Extremely High mismatch_cnt on RAID1 system
Date: Tue, 07 Oct 2014 16:23:04 +0200
Message-ID: <5433F748.1040705@shiftmail.org>
References: <CAOWcSW5+8ZkWAyXL7VTk9JO+yrozFJS8RwroKqtudkiKD-fvXA@mail.gmail.com>	 <5433E72E.60805@shiftmail.org> <BLU436-SMTP23591E5AC8AD1D0191C134D98A20@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU436-SMTP23591E5AC8AD1D0191C134D98A20@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/10/2014 15:58, Wilson, Jonathan wrote:
> Would mismatches happen if an "assume clean" was used

--assume-clean during creation, then yes, until the first "repair" and 
then "check".


> , either for a good
> reason (say to forced a dropped disk back in

I don't think it is possible to force the addition of a disk with 
--assume-clean, I think that's an option only for --create

> ) or in error, so that while
> the data on the secondary disk(s) becomes self correcting as new
> writes/updates are performed, to all disks, should the "primary" drive
> fail the second one would contain out of sync data, where it had never
> been (re)written. Although which is "primary" and which is "secondary"
> is I guess not really a good description.
>
> I would have thought that doing a DD to a _FILE_ that fills up the file
> system would also reduce the mismatch count

Yes, except theoretically for raid5 which operates RMW mode, because 
that mode propagates existing parity errors if non-full-stripes are written.
But a large file is written sequentially, probably full stripes will be 
written, so in that case, yes again.

> , as it would force
> "correct(ing)" data to all the disks, baring reserved file system
> blocks/areas.

Indeed yours is a good way to determine if mismatches are mapped to 
existing files or to unused space on the filesystem.
Once all the filesystem space is overwritten with a file, if 
mismatch_cnt is still nonzero, the mismatches are evidently located on 
files, which means data corruption.
If Dennis tells us that the mismatches count still raises after kernel 
upgrade and raid repair (repair itself will bring it to 0), we can 
suggest this test, to check for data corruption.

EW
