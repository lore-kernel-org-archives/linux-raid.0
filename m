From: Beolach <beolach@gmail.com>
Subject: Re: RAID 5 parity layout left-symmetric vs right symmetric vs other choices
Date: Mon, 7 Feb 2011 10:41:22 -0700
Message-ID: <AANLkTi=obb956-kKrucfeU+EGyE-jifkkPoG0SRpB_eh@mail.gmail.com>
References: <4D49E849.7080409@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D49E849.7080409@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Budai Laszlo <laszlo.budai@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Feb 2, 2011 at 16:27, Budai Laszlo <laszlo.budai@gmail.com> wrote:
> Hello everybody,
>
> can someone direct me to some documentation describing the pros and cons
> for choosing a certain layout.
> Any explanation on this topic is welcome.
>

There's very little difference between the different raid5 layouts;
the default left-symmetric should be good for almost everything.
Right/left refers to how the parity blocks are distributed between
disks, and should have no real impact on performance.
Symmetric/asymmetric refers to how the data blocks adjacent to the
parity blocks are ordered, with symmetric having a slight performance
advantage for large sequential I/O.  The other raid5 layouts are
special cases for reshaping & should be automatically handled by
mdadm; or are DDF-compatible layouts, intended to give "a basic level
of interoperability between different suppliers of RAID technology"
[5].

Links for more detailed info:
1 - http://www.issociate.de/board/goto/25704/raid5_parity_algorithm.html
- the next two links I got from here.
2 - http://www.accs.com/p_and_p/RAID/LinuxRAID.html
3 - http://www.pdl.cmu.edu/PDL-FTP/Declustering/ASPLOS.ps - Post Script file.
4 - http://www.mail-archive.com/misc@openbsd.org/msg90952.html - from
OpenBSD's mailing list, questioning their use of left-asymmetric as
the default, when symmetric is expected to have a slight advantage for
large sequential I/O, and the thread starter hadn't been able to find
any advantages for asymmetric.  Linux MD raid defaults to
left-symmetric.
5 - http://www.snia.org/tech_activities/standards/curr_standards/ddf/
