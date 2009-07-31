From: "NeilBrown" <neilb@suse.de>
Subject: Re: Linux Software Raid hangs after months of operation
Date: Sat, 1 Aug 2009 07:30:20 +1000 (EST)
Message-ID: <e72f4b43785f28a7b3ef0188514b6648.squirrel@neil.brown.name>
References: <a125a870907311205k6380fafcy3eecbac6150f23f5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a125a870907311205k6380fafcy3eecbac6150f23f5@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Fredrik Andersson <nablaman@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, August 1, 2009 5:05 am, Fredrik Andersson wrote:
> Hi, I have a bunch of machines running Linux 2.6.29.1 on x86_64 which
> are running Linux software raid consisting of two disk partitions
> merged into a single raid0 in /dev/md0. This setup is for performance
> reasons.
> The OS is not run from the raid, it is only used to hold a set of data
> files.
>
> This seems to work great for weeks to months at a time, but then all
> of a sudden access to the raid filesystem completely locks up. A
> process trying to access any file in there hangs to the point where it
> cannot be killed even with -9, so I suppose it's locked up in a
> syscall.
> I can't attach a debugger to the process, for then the terminal locks
> up too. But the system is operational as long as I don't read anything
> from the raid mount.
>
> Th only thing that helps is a reboot. Then the raid will function
> correctly again.
>
> The version of mdadm is v2.6.7.1 - 15th October 2008.
>
> Here is my /etc/mdadm.conf:
> DEVICE /dev/sda5
> DEVICE /dev/sdb3
> ARRAY /dev/md0 devices=/dev/sda5,/dev/sdb3
>
> /proc/mdstat from a locked machine:
> Personalities : [raid0]
> md0 : active raid0 sda5[0] sdb3[1]
> 898362368 blocks 256k chunks
>
> unused devices: <none>
>
> The raid has an ext4 filesystem on it.

In that case, I would suggest that it is much more likely to
be an ext4 problem than an md/raid problem.
raid0 is very simple and is extremely unlikely to cause
anything like that again.

If you have a system with processes that are hung like this,
I would recommend

   echo t > /proc/sysrq-trigger

which will cause a stack trace of every process to be written
to the kernel log.  This can show exactly where processes are
hanging.

NeilBrown


>
> I can find no other logs or status files for the software raid system.
> There's nothing in /var/log/messages or any other standard log.
>
> Does anybody know what is going on? Is this a known bug in md or the
> kernel?
>
> Thank you for any help!
>
> Fredrik
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

