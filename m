From: Phil Turmel <philip@turmel.org>
Subject: Re: Soft RAID and EFI systems
Date: Tue, 04 Feb 2014 07:27:51 -0500
Message-ID: <52F0DCC7.7050307@turmel.org>
References: <CAC9WiBjSjBw8Y=cCd8bpwQhuy-1+swYVdHkBT7bynv6Hx8_6zA@mail.gmail.com> <70EFD3D5-F7AC-4359-8888-99EB6CCA9E4F@colorremedies.com> <52EEB9F2.2000607@gmail.com> <3D3B8F1A-F525-459D-95F2-9D7889C222CD@colorremedies.com> <52EECD53.30802@turmel.org> <52F0A79F.7090707@gmail.com> <52F0A976.9080306@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52F0A976.9080306@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>, Francis Moreau <francis.moro@gmail.com>, Chris Murphy <lists@colorremedies.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/04/2014 03:48 AM, David Brown wrote:
> On 04/02/14 09:41, Francis Moreau wrote:

>> Are both v0.9 and v1.0 MD  put their metadata at the end of a partition
>> ? I thought only v0.9 would do that.
> 
> Yes, it is only 0.9 format that is at the end of the partition.  This
> means that a plain raid1 mirror (with as many disks as you like, as long
> as they are simple mirrors and not raid10) looks just like a normal
> partition for other tools.  As long as it is read-only, tools that are
> not raid-aware can use it.  For example, grub and lilo can happily boot
> from a 0.9 metadata raid1 array just like from a normal partition.
> (Actually, modern grub understands a lot of md raid formats.)  The same
> thing should apply to EFI, as long as it does not attempt to write to
> the partition.

No, both 0.9 and 1.0 have metadata after the data area.  v1.1 and 1.2
have their metadata before the data area.

I've been using v1.0 on my /boot mirrors for a long time.

Phil

