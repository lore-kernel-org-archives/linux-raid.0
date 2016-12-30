From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: PROBLEM: Kernel BUG with raid5 soft + Xen + DRBD - invalid opcode
Date: Fri, 30 Dec 2016 15:54:00 -0500
Message-ID: <wrfj8tqxf89j.fsf@redhat.com>
References: <585D6C34.2020908@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <585D6C34.2020908@gmail.com> (MasterPrenium's message of "Fri, 23
        Dec 2016 19:25:56 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: MasterPrenium <masterprenium.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, xen-users@lists.xen.org, linux-raid@vger.kernel.org, shli@kernel.org, "MasterPrenium@gmail.com" <MasterPrenium@gmail.com>, xen-devel@lists.xenproject.org
List-Id: linux-raid.ids

MasterPrenium <masterprenium.lkml@gmail.com> writes:
> Hello Guys,
>
> I've having some trouble on a new system I'm setting up. I'm getting a
> kernel BUG message, seems to be related with the use of Xen (when I
> boot the system _without_ Xen, I don't get any crash).
> Here is configuration :
> - 3x Hard Drives running on RAID 5 Software raid created by mdadm
> - On top of it, DRBD for replication over another node (Active/passive cluster)
> - On top of it, a BTRFS FileSystem with a few subvolumes
> - On top of it, XEN VMs running.
>
> The BUG is happening when I'm making "huge" I/O (20MB/s with a rsync
> for example) on the RAID5 stack.
> I've to reset system to make it work again.
>
> Reproducible : ALWAYS (making the i/o, it crash in 2-5mins). Also
> reproducible on another system with the same hardware.
>
> Kernel versions impacted (at least): kernel-4.4.26, kernel-4.8.15, kernel-4.9.0

Well you have one foreign object in there that is not part of the
kernel and which shows up in the OOPS: DRDB

What happens when you remove that from the equation?

Jes
