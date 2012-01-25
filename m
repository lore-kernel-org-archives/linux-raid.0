From: pg@lxra2.to.sabi.co.UK (Peter Grandi)
Subject: Re: disk-sleep problems
Date: Wed, 25 Jan 2012 16:36:41 +0000
Message-ID: <20256.12185.952242.330030@tree.ty.sabi.co.UK>
References: <CACFydqtrYbjCqzic-ke0B69abWyCpXoFm+3ge=EaBc9GvvgnWg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACFydqtrYbjCqzic-ke0B69abWyCpXoFm+3ge=EaBc9GvvgnWg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>> On Tue, 17 Jan 2012 01:09:34 +0100, Wim Delvaux
>>> <wrl.delvaux@gmail.com> said:

> Hi all, I have two 2TB disks half set up using raid 1 (full
> mirroring ?) and the other half using striping. very
> frequently my system, a kubuntu 11.10, hangs (gui is
> unresponsive). pressing alt-esc to popup the process monitor
> shows that key processes are hanging on disk-sleep. Often this
> is the flush daemon or the mdadm processes or sometimes just
> two or three applications.

It could be many different reasons. You should check 'dmesg' and
run run 'vmstat 1' in a window while this happens.

Most likely causes:

  - Your 2TB disks have long fixed error recovery timeouts and
    some sectors are going bad. In this case there is no fix
    other than replacing the disks.

  - The disks literally go to 'sleep' (that is power-saving
    mode). The fix here is to specify 'hdparm -S 0'.

  - The disk elevator keeps starving reads or writes during high
    disk activity. The fix here is to use 'deadline' which is
    known to have fewer starvation bugs than others.

  - A lot of unwritten pages are allowed to accumulate in
    memory, and the flush daemon and other applications hang
    while they are being written out. The fix here is to specify
    a small value for 'dirty_background_ratio' (like 1 or 2) and
    a large one for 'dirty_ratio' (like 40 or 50), or equivalent
    '_bytes'.

  - Since you have 8GiB of RAM, this is least likely: high
    traffic on the swap space combined with the very bad page
    swap logic in the Linux kernel.

Usually it is large values of 'dirty_background_ratio' on
large-memory configurations.

[ ... ]
