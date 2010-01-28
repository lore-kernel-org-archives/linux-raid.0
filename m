From: Thomas Backlund <tmb@mandriva.org>
Subject: Re: kernel BUG at fs/dcache.c:670 using dmraid
Date: Thu, 28 Jan 2010 11:37:02 +0200
Message-ID: <4B615ABE.7000702@mandriva.org>
References: <4B60C5C5.3040604@mandriva.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B60C5C5.3040604@mandriva.org>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, ataraid-list@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thomas Backlund skrev 28.1.2010 01:01:
> Hi, (please cc me on response)
>

[fixed typo in subject and message]

>
> I'm hitting a kernel BUG at fs/dcache.c:670 bug using dmraid on 2.6.32
> and 2.6.33-rc5-git2 kernels:
>
> Distro: Mandriva Linux Cooker
> Arch: x86_64
>
> Hardware: Intel ICH10R with 4 x 500GB disks in biosraid10,
> System has 8GB ram
>
> OOPS: http://tmb.mine.nu/Mandriva/Cooker/bugs/fs-dcache-bug/dsc00918.jpg
> config: http://tmb.mine.nu/Mandriva/Cooker/bugs/fs-dcache-bug/x86_64.config
>
> This happends on 2.6.33-rc5-git2, 2.6.32, and seems to be as old as
> 2.6.32-rc1.
>
> 2.6.31 is the latest kernel that actually boots on this system.
>
> I tried to bisect between 2.6.31 and 2.6.32-rc1, but it failed...
>
> Now before I start a second bisect, I decided to post here in case some
> one has some suggestions / pointers...
>

--
Thomas
