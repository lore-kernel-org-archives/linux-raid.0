From: Erich Newell <erich.newell@gmail.com>
Subject: Re: Data errors on clean, degraded Raid5. Help Please.
Date: Fri, 2 Dec 2005 05:12:52 +0000
Message-ID: <d39ad6430512012112y5545c2b1v29f93c741d41ffdb@mail.gmail.com>
References: <d39ad6430512011852g47d155a7i3f03db36996c01b2@mail.gmail.com>
	 <17295.50156.217214.617838@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17295.50156.217214.617838@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you for the feedback Neil.

Although, your last comment did confuse me a little...run what in
parallel? Should I be running badblocks against the unassembled
components of the raid and then doing something like:
     >fsck -l /badblockfile_sda3.txt /dev/md0
     >fsck -l /badblockfile_sdb3.txt /dev/md0
     >fsck -l /badblockfile_sdc3.txt /dev/md0
     >fsck -l /badblockfile_sdd3.txt /dev/md0

This runs contrary to my understanding on how badblocks works...I
thought it worked only on a complete filesystem (e.g. /dev/md0). What
would I pass it for the blocksize?

I got the following for dumpe2fs /dev/md0:
     dumpe2fs 1.38 (30-Jun-2005)
     Filesystem volume name:   /
     Last mounted on:          <not available>
     Filesystem UUID:          e836c5d0-dbfc-4694-b53d-69951c8dd74e
     Filesystem magic number:  0xEF53
     Filesystem revision #:    1 (dynamic)
     Filesystem features:      has_journal filetype sparse_super large_file
     Default mount options:    (none)
     Filesystem state:         clean
     Errors behavior:          Continue
     Filesystem OS type:       Linux
     Inode count:              90718208
     Block count:              181417968
     Reserved block count:     9070898
     Free blocks:              66621090
     Free inodes:              90203736
     First block:              0
     Block size:               4096
     Fragment size:            4096
     Blocks per group:         32768
     Fragments per group:      32768
     Inodes per group:         16384
     Inode blocks per group:   512
     Last mount time:          Wed Nov 30 05:46:11 2005
     Last write time:          Wed Nov 30 09:25:22 2005
     Mount count:              20
     Maximum mount count:      30
     Last checked:             Sun Oct 16 18:13:18 2005
     Check interval:           0 (<none>)
     Reserved blocks uid:      0 (user root)
     Reserved blocks gid:      0 (group root)
     First inode:              11
     Inode size:               128
     Journal inode:            8
     Journal backup:           inode blocks


I was about to proceed with "fsck -c -n /dev/md0"...but it sounds like
you have something better in mind maybe?


On 12/2/05, Neil Brown <neilb@suse.de> wrote:
> On Friday December 2, erich.newell@gmail.com wrote:
> >
> > Which generates errors when I try and copy off large amounts of data:
> >      About ten of these:
> >           ata1: translated ATA stat/err 0x25/00 to SCSI SK/ASC/ASCQ 0x4/00/00
> >           ata1: status=0x25 { DeviceFault CorrectedError Error }
> >           SCSI error : <0 0 0 0> return code = 0x8000002
> >           sda: Current: sense key: Hardware Error
> >           Additional sense: No additional sense information
> >           end_request: I/O error, dev sda, sector 489794513
>
> Sounds like there is something badly wrong with your hardware.  I've
> no idea what though ... maybe a bad cable??
>
> >
> > Should I do this:
> >     > fsck -n -c /dev/md0
> >     > mdadm --assemble /dev/md0
> >     > mdadm --add /dev/md0 /dev/sdb3
>
> The ordering looks wrong (you cannot fsck before you assemble) , but
> it is probably your best bet (assume you don't have ongoing hardware
> errors).
>
> >
> > or this:
> >      > mdadm -c /dev/md0 -l 5 -n 4 -x 0 -f /dev/sdd3 /dev/sdc3
> > /dev/sdb3 /dev/sda3
> >      > mdadm -S /dev/md0
> >      > mdadm --assemble --update=resync /dev/md0
>
> You mean '-C', not '-c', and the last two steps are pointless after
> the first.  But your first option is probably best, not that there is
> liekly to be a big difference in the result.
>
> >
> > or ???
> >
> > If anyone has this knowledge, please share. I'm in over my head on this one.
> >
> > Thanks in advance!
> >
> > P.S. I am currently running a non-distructive badblock check while I
> > wait for expert advice:
>
> That's a good idea.  I would do that on all the devices... in parallel.
>
> NeilBrown
>


--
"A man is defined by the questions that he asks; and the way he goes
about finding the answers to those questions is the way he goes
through life."
