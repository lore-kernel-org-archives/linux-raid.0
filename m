From: Doug Ledford <dledford@redhat.com>
Subject: Re: "Missing" RAID devices
Date: Tue, 21 May 2013 12:23:40 -0400
Message-ID: <519B9F8C.3080104@redhat.com>
References: <CAGPLN=viGgdw0MM18tiNxwjNadg0cj8xjntW3ne1qMNkfgocaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGPLN=viGgdw0MM18tiNxwjNadg0cj8xjntW3ne1qMNkfgocaA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jim Santos <iluvgadgets@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/21/2013 08:51 AM, Jim Santos wrote:
> santos@bender:/etc/mdadm$ sudo mdadm --examine /dev/sda7
> 
> /dev/sda7:
> Magic : a92b4efc
> Version : 0.90.00
            ^^^^^^^

There's your problem.  Seriously.

> Preferred Minor : 126

So, how did you ever get version 0.90 superblocks that count from 127
backwards?  Mdadm doesn't do that.  In fact, mdadm relies on you *not*
doing that.

Here's the deal.  When you use version 0.90 superblocks, the number is
taken from the superminor field, usually starting at 0 and counting up,
and the device file is then /dev/md<number>.  With version 1.x
superblocks, we care about the name of the device, not the number, and
the name is taken from the name field of the superblock, and we create
the device as /dev/md/<name>.  However, when this support was added, the
kernel didn't support named elements (aka, you couldn't have a md/root
device in the kernel namespace, it needed to be md<number>), so the
/dev/md/<name> file is actually a symlink to a /dev/md<number> file, and
we would allocate from 127 and count backwards so that they would be as
unlikely as possible to conflict with numbered names from version 0.90
superblocks.

You are running into that impossible conflict.  I would remake all of
your version 0.90 raid arrays as version 1.0 raid arrays (the superblock
should sit in the exact same space and the arrays should be the same
size, but I can't say that for certain because newer mdadm might reserve
more space between the end of the filesystem and the superblock than
older mdadm did, so a test would be necessary first), and in the process
I would give them all names, and then I would totally eliminate all
references to /dev/md<number> in your system setup and stick with just
/dev/md/<name> for everything, and then I would remake your initrd and
be done with it all.

