From: Doug Ledford <dledford@redhat.com>
Subject: Re: RFC swap over raid1
Date: Fri, 02 Aug 2013 11:40:12 -0400
Message-ID: <51FBD2DC.3010900@redhat.com>
References: <CAH3kUhFoNKgHErujKuCLMvx_qbDa2dwhW+sMD=7W9W0hHTWB-w@mail.gmail.com> <51FAE985.1040809@redhat.com> <CAH3kUhH-uc-tXitqZ=xuUYz5A8GY_+dhy+LnvvZTR9gSUJ0Y4A@mail.gmail.com> <51FB63C8.2090300@hardwarefreak.com> <CAH3kUhE2ys1nGetLy0p=9rj2BxajAvBdWACFXHMe4TP81zNh=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH3kUhE2ys1nGetLy0p=9rj2BxajAvBdWACFXHMe4TP81zNh=w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 08/02/2013 10:21 AM, Roberto Spadim wrote:
> hummm, wow very new informations to me...
> 
> today linux don't have a generic badblock remap?! that's what i understood?
> for example... ext2,3,4,xfs,reiserfs,zfs, and others fs, they handle
> badblock by their self? right?

No, not really.  I think back in the day, badblock support mattered, but
it was really just limited to having a list of known bad sectors that
the filesystem would never use because once the sector failed, it was
toast.  But that was when the firmware on the disk controllers didn't
have a pool of spare sectors that were available to remap bad blocks.

Now a days, the drives automatically remap bad sectors into their own
internal spare sector pool.  The only time the OS sees a bad block is
when it went bad by surprise to the drive and so the data couldn't be
read and remapped before it went away.

In that case, you just rewrite something to the bad sector, and
generally the drive firmware will have remap-on-write-error enabled and
generally the failed sector will not only fail to be read but will also
fail to be written, and so the drive will remap the bad sector to a
spare as long as it has spares available.

It's for this reason that, with modern drives, a failed read is somewhat
acceptable as it will likely be fixed simply by writing back to the same
sector, but if that sector persists in being bad even after a write,
then you know that the drive's internal pool of spare sectors are all
allocated and so all future failures on the drive will be permanent
failures.  It's at that point that you need to replace the drive ASAP.

However, filesystems don't keep two copies of their data laying around
in order to rewrite bad sectors.  The md raid layer does (when using a
reliable level of course).  Basically, badblock management by
filesystems has always just been to mark a sector as bad and work around
it (with a possibly corrupted file as a result).  Badblock management by
the raid subsystem is to try and get the drive to reallocate the sector
by rewriting the correct data to that sector.

> it's a nice information i never thinked about a layer only for
> badblock reallocation, i read/write in this list of linux-raid when
> the started the badblock development, in some time near to raid1 write
> multithread
> 
> today the badblock of raid1 is embedded in the source? or it's easy to
> implement a new layer just to badblock realloc logic?
> 
> about "mkswap -c" it just show information like you told, i'm a bit
> surprised about no badblock at swap that's information is new to me i
> will read about others os (freebsd, reactos, etc) to check how they
> handle this there
> 
> I'm rethinking now about the swap as a file in a filesystem, this
> could increase security or another solution is better?

It used to be that a swapfile on a filesystem was slower than swap on
its own partition.  I think they cleared that up some time ago so that
the speed difference is mostly negligible.  But having it as a file on
the filesystem makes management of partitions easier, so that's
something in the swapfile's favor.

