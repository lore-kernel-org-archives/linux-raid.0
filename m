From: Georgios Petasis <petasisg@yahoo.gr>
Subject: Re: raid 1 assembled but inactive - works from a "live"
 distribution...
Date: Fri, 21 Jul 2017 17:04:52 +0300
Message-ID: <fcb36ab3-ad80-7b41-0f3a-f1f1b38864ac@yahoo.gr>
References: <b9a1822b-ab01-2cb3-e417-85aafec9a3d2@yahoo.gr>
 <8504efd5-dc98-afe6-6d6c-5b1352a9c134@yahoo.gr>
 <5970B35F.1030007@youngman.org.uk>
Reply-To: petasisg@yahoo.gr
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5970B35F.1030007@youngman.org.uk>
Content-Language: English & Greek
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Στις 20/7/2017 16:42, ο Wols Lists έγραψε:
> On 20/07/17 12:52, Georgios Petasis wrote:
>> Another puzzling fact, is that booting fedora 25 with the previous
>> kernel works.
>> With the latest kernel does not.
>> I tried because I saw "md: personality for level 1 is not loaded!" in
>> the logs...
> Has the initrd or similar been changed somehow? I'll let the experts
> chime in more, but this sounds like the kernel module for raid1 has
> become inaccessible.
I think the problem is a kernel update that was issued by fedora. I have 
updated to the newest kernel, but since this is a server running 24/7, I 
had the problem after I reboot. And it took me many hours to find out it 
was a kernel issue.
I have filed a bug report: 
https://bugzilla.redhat.com/show_bug.cgi?id=1473308
and I am waiting what will happen.
>
> You've got superblock v1.2, which means the old trick of booting off of
> one disk read-only, before assembling the raid and switching root
> read/write won't work. Therefore you
>
> (a) *MUST* have raid1 support in grub, in order to be able to read the
> mirror to find the kernel, and
>
> (b) must have raid1 support in the kernel, so the kernel can see /.
My configuration does not use raid at /. The /boot and / partitions are 
on a plain SSD. What I have as raid-1 are /var, /home, and /free (an 
irrelevant space you can drop things).

What happens during Fedora 25 boot with kernel 4.11.10-200.fc25 is:
everything is normal until the boot process mounts the file systems. 
There is waits from 1,5 minute to find all three devices, and then times 
out and enters in emergency mode.
In there, the 3 raid devices are available, but inactive. The reason 
they are inactive, is because personalities is empty.
For sure raid-1 personality is missing, there can be also other 
personalities missing but I don't have them in my system to check.

There is a clear message in the boot logs that says:
md: personality for level 1 is not loaded!

So, I suspect relevant modules are missing from the specific kernel.
>
> As I say, that message makes me suspect that either the grub or the
> kernel raid-1 support module has disappeared ...
I also think that the kernel module for raid-1 has disappeared...

Thanks,
George
>
> Cheers,
> Wol
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

