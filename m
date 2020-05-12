From: Song Liu <song@kernel.org>
Subject: Re: Assemblin journaled array fails
Date: Mon, 11 May 2020 18:27:34 -0700
Message-ID: <CAPhsuW4WcqkDXOhcuG33bZtSEZ-V-KYPLm87piBH24eYEB0qVw@mail.gmail.com>
References: <f8c61278-1758-66cd-cf25-8a118cb12f58@yandex.pl>
 <70dad446-7d38-fd10-130f-c23797165a21@yandex.pl> <56b68265-ca54-05d3-95bc-ea8ee0b227f6@yandex.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56b68265-ca54-05d3-95bc-ea8ee0b227f6@yandex.pl>
Sender: linux-raid-owner@vger.kernel.org
To: Michal Soltys <msoltyspl@yandex.pl>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, May 11, 2020 at 4:13 AM Michal Soltys <msoltyspl@yandex.pl> wrote:
>
> On 5/10/20 1:57 AM, Michal Soltys wrote:
> > Anyway, I did some tests with manually snapshotted component devices
> > (using dm snapshot target to not touch underlying devices).
> >
> > The raid manages to force assemble in read-only mode with missing
> > journal device, so we probably will be able to recover most data
> > underneath this way (as a last resort).
> >
> > The situation I'm in now is likely from uncelan shutdown after all (why
> > the machine failed to react to ups properly is another subject).
> >
> > I'd still want to find out why is - apparently - a journal device giving
> > issues (contrary to what I'd expect it to do ...), with notable mention of:
> >
> > 1) mdadm hangs (unkillable, so I presume in kernel somewhere) and eats 1
> > cpu when trying to assemble the raid with journal device present; once
> > it happens I can't do anything with the array (stop, run, etc.) and can
> > only reboot the server to "fix" that
> >
> > 2) mdadm -D shows nonsensical device size after assembly attempt (Used
> > Dev Size : 18446744073709551615)
> >
> > 3) the journal device (which itself is md raid1 consisting of 2 ssds)
> > assembles, checks (0 mismatch_cnt) fine - and overall looks ok.
> >
> >
> >  From other interesting things, I also attempted to assemble the raid
> > with snapshotted journal. From what I can see it does attempt to do
> > something, judging from:
> >
> > dmsetup status:
> >
> > snap_jo2: 0 536870912 snapshot 40/33554432 16
> > snap_sdi1: 0 7812500000 snapshot 25768/83886080 112
> > snap_jo1: 0 536870912 snapshot 40/33554432 16
> > snap_sdg1: 0 7812500000 snapshot 25456/83886080 112
> > snap_sdj1: 0 7812500000 snapshot 25928/83886080 112
> > snap_sdh1: 0 7812500000 snapshot 25352/83886080 112
> >
> > But it doesn't move from those values (with mdadm doing nothing eating
> > 100% cpu as mentioned earlier).
> >
> >
> > Any suggestions how to proceed would very be appreciated.
>
>
> I've added Song to the CC. If you have any suggestions how to
> proceed/debug this (mdadm stuck somewhere in kernel as far as I can see
> - while attempting to assembly it).
>
> For the record, I can assemble the raid successfully w/o journal (using
> snapshotted component devices as above), and we did recover some stuff
> this way from some filesystems - but for some other ones I'd like to
> keep that option as the very last resort.

Sorry for delayed response.

A few questions.

For these two outputs:
#1
               Name : xs22:r5_big  (local to host xs22)
               UUID : d5995d76:67d7fabd:05392f87:25a91a97
             Events : 56283

     Number   Major   Minor   RaidDevice State
        -       0        0        0      removed
        -       0        0        1      removed
        -       0        0        2      removed
        -       0        0        3      removed

        -       8      145        3      sync   /dev/sdj1
        -       8      129        2      sync   /dev/sdi1
        -       9      127        -      spare   /dev/md/xs22:r1_journal_big
        -       8      113        1      sync   /dev/sdh1
        -       8       97        0      sync   /dev/sdg1

#2
/dev/md/r1_journal_big:
           Magic : a92b4efc
         Version : 1.1
     Feature Map : 0x200
      Array UUID : d5995d76:67d7fabd:05392f87:25a91a97
            Name : xs22:r5_big  (local to host xs22)
   Creation Time : Tue Mar  5 19:28:58 2019
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 536344576 (255.75 GiB 274.61 GB)
      Array Size : 11718355968 (11175.50 GiB 11999.60 GB)
   Used Dev Size : 7812237312 (3725.17 GiB 3999.87 GB)
     Data Offset : 262144 sectors
    Super Offset : 0 sectors
    Unused Space : before=261872 sectors, after=0 sectors
           State : clean
     Device UUID : c3a6f2f6:7dd26b0c:08a31ad7:cc8ed2a9

     Update Time : Sat May  9 15:05:22 2020
   Bad Block Log : 512 entries available at offset 264 sectors
        Checksum : c854904f - correct
          Events : 56289

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Journal
    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)


Are these captured back to back? I am asking because they showed different
"Events" number.

Also, when mdadm -A hangs, could you please capture /proc/$(pidof mdadm)/stack ?

18446744073709551615 is 0xffffffffffffffffL, so it is not initialized
by data from the disk.
I suspect we hang somewhere before this value is initialized.

Thanks,
Song
