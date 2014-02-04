From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Soft RAID and EFI systems
Date: Tue, 4 Feb 2014 08:40:57 -0700
Message-ID: <B024B0B9-6E6E-4988-B371-644EF2641F77@colorremedies.com>
References: <CAC9WiBjSjBw8Y=cCd8bpwQhuy-1+swYVdHkBT7bynv6Hx8_6zA@mail.gmail.com> <70EFD3D5-F7AC-4359-8888-99EB6CCA9E4F@colorremedies.com> <52EEB9F2.2000607@gmail.com> <3D3B8F1A-F525-459D-95F2-9D7889C222CD@colorremedies.com> <52F0A58D.6000400@gmail.com> <52F0AB60.8000800@hesbynett.no>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52F0AB60.8000800@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Francis Moreau <francis.moro@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Feb 4, 2014, at 1:57 AM, David Brown <david.brown@hesbynett.no> wrote:
> The most important way to protect your FAT32 system is simply to avoid
> writing to it except when absolutely necessary.  If it is mounted
> read-only, and only updated when changing grub or updating the kernel,
> then just make sure you don't power-cycle your machine at that time.
> The smaller the critical window, the smaller the chances of problems.

I agree. I even question why most linux distros persistently mount the EFI System partition at /boot/efi for no apparently good reason. Windows and OS X do not keep the ESP mounted even read-only. It's pretty much never updated. If we're constantly updating the ESP for things like grub.cfg modifications, I think the implementation is flawed.

On EFI, grubx64.efi/core.img needs to look for grub.cfg /boot/grub2 not /boot/efi/EFI/fedora
https://bugzilla.redhat.com/show_bug.cgi?id=1048999



Chris Murphy

