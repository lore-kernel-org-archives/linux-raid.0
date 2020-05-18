From: Song Liu <song@kernel.org>
Subject: Re: Assemblin journaled array fails
Date: Mon, 18 May 2020 16:55:24 -0700
Message-ID: <CAPhsuW4byXUvseqoj3Pw4r5nRGu=fHekdDec8FG6vj3of1wCyg@mail.gmail.com>
References: <f8c61278-1758-66cd-cf25-8a118cb12f58@yandex.pl>
 <70dad446-7d38-fd10-130f-c23797165a21@yandex.pl> <56b68265-ca54-05d3-95bc-ea8ee0b227f6@yandex.pl>
 <CAPhsuW4WcqkDXOhcuG33bZtSEZ-V-KYPLm87piBH24eYEB0qVw@mail.gmail.com>
 <b9b6b007-2177-a844-4d80-480393f30476@yandex.pl> <CAPhsuW70NNozBmt1-zsM_Pk-39cLzi8bC3ZZaNwQ0-VgYsmkiA@mail.gmail.com>
 <f9b54d87-5b81-1fa3-04d5-ea86a6c062cb@yandex.pl> <CAPhsuW5ZfmCowTHNum5CSeadHqqPa5049weK6bq=m+JmnDE9Vg@mail.gmail.com>
 <d0340d7b-6b3a-4fd3-e446-5f0967132ef6@yandex.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d0340d7b-6b3a-4fd3-e446-5f0967132ef6@yandex.pl>
Sender: linux-raid-owner@vger.kernel.org
To: Michal Soltys <msoltyspl@yandex.pl>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, May 18, 2020 at 4:43 AM Michal Soltys <msoltyspl@yandex.pl> wrote:
>
> On 5/16/20 2:15 AM, Song Liu wrote:
> > On Thu, May 14, 2020 at 4:07 AM Michal Soltys <msoltyspl@yandex.pl> wro=
te:
> >>
> >> On 5/13/20 6:17 PM, Song Liu wrote:
> >>>>>
> >>>>> Are these captured back to back? I am asking because they showed di=
fferent
> >>>>> "Events" number.
> >>>>
> >>>> Nah, they were captured between reboots. Back to back all event fiel=
ds show identical value (at 56291 now).
> >>>>
> >>>>>
> >>>>> Also, when mdadm -A hangs, could you please capture /proc/$(pidof m=
dadm)/stack ?
> >>>>>
> >>>>
> >>>> The output is empty:
> >>>>
> >>>> xs22:/=E2=98=A0 ps -eF fww | grep mdadm
> >>>> root     10332  9362 97   740  1884  25 12:47 pts/1    R+     6:59  =
|   \_ mdadm -A /dev/md/r5_big /dev/md/r1_journal_big /dev/sdi1 /dev/sdg1 /=
dev/sdj1 /dev/sdh1
> >>>> xs22:/=E2=98=A0 cd /proc/10332
> >>>> xs22:/proc/10332=E2=98=A0 cat stack
> >>>> xs22:/proc/10332=E2=98=A0
> >>>
> >>> Hmm... Could you please share the strace output of "mdadm -A" command=
? Like
> >>>
> >>> strace mdadm -A /dev/md/r5_big /dev/md/r1_journal_big /dev/xxx ...
> >>>
> >>> Thanks,
> >>> Song
> >>
> >> I did one more thing - ran cat on that stack in another terminal every
> >> 0.1 seconds, this is what was found:
> >>
> >> cat: /proc//stack: No such file or directory
> >> cat: /proc//stack: No such file or directory
> >> cat: /proc//stack: No such file or directory
> >> [<0>] submit_bio_wait+0x5b/0x80
> >> [<0>] r5l_recovery_read_page+0x1b6/0x200 [raid456]
> >> [<0>] r5l_recovery_verify_data_checksum+0x19/0x70 [raid456]
> >> [<0>] r5l_start+0x99e/0xe70 [raid456]
> >> [<0>] md_start.part.48+0x2e/0x50 [md_mod]
> >> [<0>] do_md_run+0x64/0x100 [md_mod]
> >> [<0>] md_ioctl+0xe7d/0x17d0 [md_mod]
> >> [<0>] blkdev_ioctl+0x4d0/0xa00
> >> [<0>] block_ioctl+0x39/0x40
> >> [<0>] do_vfs_ioctl+0xa4/0x630
> >> [<0>] ksys_ioctl+0x60/0x90
> >> [<0>] __x64_sys_ioctl+0x16/0x20
> >> [<0>] do_syscall_64+0x52/0x160
> >> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >> cat: /proc//stack: No such file or directory
> >> [<0>] submit_bio_wait+0x5b/0x80
> >> [<0>] r5l_recovery_read_page+0x1b6/0x200 [raid456]
> >> [<0>] r5l_recovery_verify_data_checksum+0x19/0x70 [raid456]
> >> [<0>] r5l_start+0x99e/0xe70 [raid456]
> >> [<0>] md_start.part.48+0x2e/0x50 [md_mod]
> >> [<0>] do_md_run+0x64/0x100 [md_mod]
> >> [<0>] md_ioctl+0xe7d/0x17d0 [md_mod]
> >> [<0>] blkdev_ioctl+0x4d0/0xa00
> >> [<0>] block_ioctl+0x39/0x40
> >> [<0>] do_vfs_ioctl+0xa4/0x630
> >> [<0>] ksys_ioctl+0x60/0x90
> >> [<0>] __x64_sys_ioctl+0x16/0x20
> >> [<0>] do_syscall_64+0x52/0x160
> >> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >> cat: /proc//stack: No such file or directory
> >> cat: /proc//stack: No such file or directory
> >> cat: /proc//stack: No such file or directory
> >> cat: /proc//stack: No such file or directory
> >>
> >>
> >> Strace output attached.
> >
> > So mdadm hangs at "ioctl(4, RUN_ARRAY", right?
> >
>
> Yes, it's consistent across attempts.
>
> > Does /proc/<pid of hanging mdadm>/stack always shows the same output ab=
ove?
>
> Having peeked closer - it actually tries to do something somehow -
> attached the stack file dumped every ~0.01 seconds.
>
> After a while I can hit non-empty cat /proc/<pid>/stack every 5-15
> seconds this way.
>
> At one point "hanged" mdadm has been running this way for 24hr+ without
> any practical effect in the end.
>

Thanks for these information.

It looks like the kernel had some issue in recovery. Could you please
try the following:

1. check dmesg, we should see one of the following at some point:
    pr_info("md/raid:%s: starting from clean shutdown\n",
or
    pr_info("md/raid:%s: recovering %d data-only stripes and %d
data-parity stripes\n",

2. try use bcc/bpftrace to trace r5l_recovery_read_page(),
specifically, the 4th argument.
With bcc, it is something like:

    trace.py -M 100 'r5l_recovery_read_page() "%llx", arg4'

-M above limits the number of outputs to 100 lines. We may need to
increase the limit or
remove the constraint. If the system doesn't have bcc/bpftrace. You
can also try with
kprobe.

Thanks,
Song
