From: George Rapp <george.rapp@gmail.com>
Subject: Re: Preventing automatic start of ARRAY on Kubuntu
Date: Thu, 16 Oct 2014 12:19:50 -0400
Message-ID: <CAF-Kpgap28pB0i0U5XvzLsL8sv3wHU37=GSPRH3w2NqsN0cKLA@mail.gmail.com>
References: <543FEB86.5070902@gautschi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <543FEB86.5070902@gautschi.net>
Sender: linux-raid-owner@vger.kernel.org
To: "P. Gautschi" <linuxlist@gautschi.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Oct 16, 2014 at 12:00 PM, P. Gautschi <linuxlist@gautschi.net> wrote:
>
> I'm currently experimenting with RAID5 on Kubuntu 14.10 Beta 2.
>
> When the system boots, /dev/md127 is automatically started. This occurs
> whether the line (output after creation of mdadm --detail --scan)
> ARRAY /dev/md0 metadata=1.2 name=test:0 UUID=2e0d5db2:47c49e4b:75c06b8b:11bf68cf
> is in /etc/mdadm/mdadm.conf or not.
>
> I would expected that the array is only started when the line is in the file
> and then as /dev/md0 and not as md127.
>
> My final goal is to prevent the start of the array when it is degraded
> (missing or previously failed disk).
>
> I had problems with a power cable and one disk had failed. While checking
> the cables a second disk failed temporarily. Even though I wasn't writing
> to the fs on the array I ended with and array that could not be assembled
> again, after all disk were working again. (I have tried reboots,
> mdadm --assemble --force and the other tricks from
> https://raid.wiki.kernel.org/index.php/RAID_Recovery
> but ended with a corrupt fs.)
>
> I'm now trying to minimize the risk of data loss. Not starting the
> array when degraded (or starting it read-only) is one of my ideas
> but I don't know where and how to implement this.

[re-sending this without the HTML, which the list manager doesn't care for]

 Patrick -

Here's what I did (on Fedora, but I suspect the process will be
similar on any distro):
    Make whatever changes you need to in /etc/mdadm.conf (for example,
removing /dev/md0 and /dev/md127);
    Create a new initramfs to reflect your changes:
    # cd /boot
    # mv initramfs-$(uname -r).img initramfs-$(uname -r).img.backup
    # dracut --mdadmconf /boot/initramfs-$(uname -r).img $(uname -r)
(The dracut command is not provided in Fedora by default, but requires
a package; in Fedora 20, the current package is
dracut-037-11.git20140402.fc20.i686.)

This creates a new initramfs with your updated mdadm.conf. After you
reboot with the new initramfs image, you will have to start whatever
MD array(s) you want manually. At this point, for example, you could
try to start the array without --force, and it would refuse to start
if degraded.

> Another idea is, that the array could switch to read only when
> degraded during runtime. Ideally this would be delayed until the
> fs does a flush/sync to be in a recoverable state. Of course file
> accesses would fail is such a situation but it prefer this to
> the rick of loosing data.
> Is it possible to do this?

My Fedora 20 kernel (3.16.4-200.fc20.i686+PAE) seems to do this
automatically for me. My RAID 5 suffered a disk failure that dropped
it down to one (of three) component devices, and the kernel stopped
writes immediately to prevent data loss. After powering off and
reassembling my array with --force to sync up the event counters, I
didn't lose anything.

Good luck.

-- 
George Rapp  (Pataskala, OH) Home: george.rapp -- at -- gmail.com
Work: george.rapp -- at -- hp.com (or) george.rapp.ctr -- at -- dfas.mil

A wise and frugal government, which shall restrain men from injuring
one another, which shall leave them otherwise free to regulate their
own pursuits of industry and improvement, and shall not take from the
mouth of labor the bread it has earned. This is the sum of
good government... - Thomas Jefferson, First Inaugural Address
