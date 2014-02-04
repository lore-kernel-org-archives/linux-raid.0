From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Soft RAID and EFI systems
Date: Tue, 4 Feb 2014 08:27:03 -0700
Message-ID: <553643B2-CF66-4B96-9A15-231E6D27C706@colorremedies.com>
References: <CAC9WiBjSjBw8Y=cCd8bpwQhuy-1+swYVdHkBT7bynv6Hx8_6zA@mail.gmail.com> <70EFD3D5-F7AC-4359-8888-99EB6CCA9E4F@colorremedies.com> <52EEB9F2.2000607@gmail.com> <3D3B8F1A-F525-459D-95F2-9D7889C222CD@colorremedies.com> <52F0A58D.6000400@gmail.com> <52F0AB60.8000800@hesbynett.no> <52F0AD83.4030300@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52F0AD83.4030300@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: David Brown <david.brown@hesbynett.no>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Feb 4, 2014, at 2:06 AM, Francis Moreau <francis.moro@gmail.com> wrote:
>> 
> Ok, so basically RAID helps only in case of disk failure, right ?

Correct. (Although the Btrfs raid1 implementation can detect and correct for corruption, including phantom writes, so it makes the question "what is raid and isn't raid?" more open ended.)

> 
> It seems odd to have chosen FAT32 in the first place then.

I'm not sure what else they could have picked. FAT32 is brain dead simple and has the least amount of plausible IP attached to it, and Microsoft was willing to set aside those IP concerns for anything having to do with EFI. FAT32 has changed hardly at all in 15 years. Yet NTFS, ext, HFS have all gone through quite a bit of change.

FWIW, the UEFI spec says FAT12 or FAT16 for removable media. And FAT32 for boot devices like hard drives. However, by default dosfstools chooses bitness based on the size of the partition being formatted, rather than removable vs not. So I've found that e.g. Fedora's installer creates a 200MB EFI System partition, and formats it using mkdosfs without options, and therefore results in FAT16 EFI System partitions.

https://bugzilla.redhat.com/show_bug.cgi?id=1046577


Chris Murphy

