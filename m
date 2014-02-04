From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: Soft RAID and EFI systems
Date: Tue, 04 Feb 2014 10:45:42 +0100
Message-ID: <52F0B6C6.50905@gmail.com>
References: <CAC9WiBjSjBw8Y=cCd8bpwQhuy-1+swYVdHkBT7bynv6Hx8_6zA@mail.gmail.com> <70EFD3D5-F7AC-4359-8888-99EB6CCA9E4F@colorremedies.com> <52EEB9F2.2000607@gmail.com> <3D3B8F1A-F525-459D-95F2-9D7889C222CD@colorremedies.com> <52F0A58D.6000400@gmail.com> <52F0AB60.8000800@hesbynett.no> <52F0AD83.4030300@gmail.com> <52F0B453.3070108@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52F0B453.3070108@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>, Chris Murphy <lists@colorremedies.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/04/2014 10:35 AM, David Brown wrote:
[...]
>>
>> It seems odd to have chosen FAT32 in the first place then.
> 
> FAT32 is the worst possible choice of a filesystem, except for three
> aspects - it is quite simple and can be implemented in a small amount of
> code (such as in EFI or a bootloader), it is usable on small disks or
> partitions, and it is supported by brain-dead OS's that don't understand
> better alternatives (NTFS has journalling, but is a monster to implement
> in something the size of EFI).
> 
> It's a crap filesystem, but it is the "industry standard" for small
> disks and small systems.

If readonly support is only needed, there're some alternative to FAT32.

But I agree FAT32 is well known by the industry standard.

> 
>>
>>>
>>> The most important way to protect your FAT32 system is simply to avoid
>>> writing to it except when absolutely necessary.  If it is mounted
>>> read-only, and only updated when changing grub or updating the kernel,
>>> then just make sure you don't power-cycle your machine at that time.
>>
>> Well, the problem is that you never know when power failures happen at
>> least for me with a small server without any power backup.
> 
> The answer here is staring you in the face... get an UPS.  A small one
> is not expensive - you only need it to run the server for a couple of
> minutes.  Even though journalled filesystems can keep their /metadata/
> consistency after a power failure, they don't normally guarantee /data/
> consistency, and certainly cannot guarantee /application level/
> consistency.  You get that from doing a proper shutdown.  And remember
> also that after an unclean shutdown, restarts involve long consistency
> checks at the raid level and at the filesystem level - an UPS will let
> you avoid that.

I understand your point.

Thanks.
