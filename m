From: Doug Ledford <dledford@redhat.com>
Subject: Re: raid array with 3T disks and GPT partition
Date: Thu, 01 Sep 2011 12:55:08 -0400
Message-ID: <4E5FB8EC.5040801@redhat.com>
References: <20110901154759.GA32649@apartia.fr> <20110901155913.GA20825@cthulhu.home.robinhill.me.uk> <20110901163334.GA13347@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110901163334.GA13347@apartia.fr>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/01/2011 12:33 PM, Louis-David Mitterrand wrote:
> On Thu, Sep 01, 2011 at 04:59:13PM +0100, Robin Hill wrote:
>> On Thu Sep 01, 2011 at 05:47:59PM +0200, Louis-David Mitterrand wrote:
>>>
>>> I'm trying to create a raid6 array from 10x3T disks. Since disks>  2T
>>> must use the GPT partion table I used parted to created a single
>>> partition on each drive with the correct GPT partion type.
>>>
>>> Now how do I make sure that these partitions have the correct "raid
>>> autodetect" (fd) id? Is it even still needed? I didn't find any way to
>>> set that flag in (g)parted.
>>>
>> It's only needed for kernel auto-assembly (in which case you're also
>> limited to 0.90 metadata and 2TB drives), so no, there's no need to use
>> that. 0xDA seems to be the recommended partition type for RAID arrays
>> nowadays - that should prevent the OS from trying to read them directly.
>
> Auto-assembly and metadata are not related: I regularly use 1.2 metadata
> on non-boot partitions and they auto-assemble fine.

They most certainly are related.  There is kernel autoassembly, then 
there is user space assembly that's done by udev.  They are two 
different things.  The kernel will only autoassemble version 0.9 arrays, 
any other arrays are assembled by user space either in the initramfs or 
later on in the boot cycle.  That you don't have to manually run mdadm 
-As doesn't mean that the kernel autoassembly is working on those arrays.

> However lilo won't boot on anything other than 0.9, this I found the
> hard way :)

Lilo should be able to boot on version 1.0 arrays too.  It's just 
version 1.1 and 1.2 arrays that kill lilo.  But, then again, lilo is so 
long since dead that one has to wonder why you are still using it.

> Kernel auto-assembly seems quite useful and desirable to me, especially
> when using, say, initrd to unlock dm-crypt partitions (no need to
> configure madadm.conf in the initrd).
>
> BTW, what is that 0xDA type?

Non-FS Data, which we hijacked for our purposes as it will keep the 
system (any OS in fact) from thinking there should be a filesystem 
there, leaving it free for us to pick up anytime in the boot process.

