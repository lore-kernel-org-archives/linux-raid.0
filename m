From: MasterPrenium <masterprenium.lkml@gmail.com>
Subject: Re: PROBLEM: Kernel BUG with raid5 soft + Xen + DRBD - invalid opcode
Date: Sat, 31 Dec 2016 01:00:31 +0100
Message-ID: <5866F51F.3050702@gmail.com>
References: <585D6C34.2020908@gmail.com> <wrfj8tqxf89j.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <wrfj8tqxf89j.fsf@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-kernel@vger.kernel.org, xen-users@lists.xen.org, linux-raid@vger.kernel.org, shli@kernel.org, "MasterPrenium@gmail.com" <MasterPrenium@gmail.com>, xen-devel@lists.xenproject.org
List-Id: linux-raid.ids

Hello,

Thanks for your reply. DRBD isn't part of the kernel ? I was thinking it 
has been included since 2.6.3x ?

I've just tested without DRBD, the issue seems to remain. Can't see the 
"BUG", but the kernel crashed also. (A little bit later)
I don't have full dump since I lost my network connection and my serial 
connection.
Here is a picture of what I got : 
http://img15.hostingpics.net/pics/113882KernelError6.png
Another one : http://img11.hostingpics.net/pics/164702KernelError7.png

It also seems to me that having the "glances" monitoring software 
running in dom0, makes the kernel crashes quicker, don't think this can 
help but... just in case...

Any idea / test I can make ? This is really a blocking issue with 
potential data loss...

Best regards,
MasterPrenium


Le 30/12/2016 21:54, Jes Sorensen a écrit :
> MasterPrenium<masterprenium.lkml@gmail.com>  writes:
>> Hello Guys,
>>
>> I've having some trouble on a new system I'm setting up. I'm getting a
>> kernel BUG message, seems to be related with the use of Xen (when I
>> boot the system _without_ Xen, I don't get any crash).
>> Here is configuration :
>> - 3x Hard Drives running on RAID 5 Software raid created by mdadm
>> - On top of it, DRBD for replication over another node (Active/passive cluster)
>> - On top of it, a BTRFS FileSystem with a few subvolumes
>> - On top of it, XEN VMs running.
>>
>> The BUG is happening when I'm making "huge" I/O (20MB/s with a rsync
>> for example) on the RAID5 stack.
>> I've to reset system to make it work again.
>>
>> Reproducible : ALWAYS (making the i/o, it crash in 2-5mins). Also
>> reproducible on another system with the same hardware.
>>
>> Kernel versions impacted (at least): kernel-4.4.26, kernel-4.8.15, kernel-4.9.0
> Well you have one foreign object in there that is not part of the
> kernel and which shows up in the OOPS: DRDB
>
> What happens when you remove that from the equation?
>
> Jes
