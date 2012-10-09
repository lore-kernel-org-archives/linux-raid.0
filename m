From: Massimo Gais <massimo.gais@iki.fi>
Subject: Re: Issue recovering a md device with first 4kB lost.
Date: Tue, 9 Oct 2012 11:12:54 +0300
Message-ID: <CAPpPG0XhSij61UmXhUOq3kZbW=n53e8ccPmDO-7xkBdtM1rmcA@mail.gmail.com>
References: <CAPpPG0WfVjk7qoC=EdJ=E=vt1uK8amMr9Hb0Q_P0tVyy63f+_w@mail.gmail.com>
	<CAPpPG0UTjpwiWQyxKsT+JcZt3VgDeGBVddUBd_+8a2+U-50AzA@mail.gmail.com>
	<5073CF69.4@xs4all.net>
	<alpine.DEB.2.00.1210090918240.21297@uplift.swm.pp.se>
	<CAPpPG0W0JB3r499LTDeEPDYUe1PjKhvU8tRFS6WMrhQptnM-TA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPpPG0W0JB3r499LTDeEPDYUe1PjKhvU8tRFS6WMrhQptnM-TA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>, Miquel van Smoorenburg <mikevs@xs4all.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Oct 9, 2012 at 10:28 AM, Massimo Gais <massimo.gais@iki.fi> wrote:
>
> How to find that offset for the ext4? And I guess that to verify
> whether lvm has allocated a continuous amount of blocks, a "fsck -n
> /dev/loop0" would allow to test that the fs is in a consistent state.
>
> Otherwise, which command to use to start lvm properly?

Update: I checked and found that at offset 201728 there is the begin
of a ext4 superblock.
Comparing with a working ext4 fs, I see that superblock should be a
1024 from beginning of the partition,
so I tried Miquel's suggestion and run a "losetup -o 200704 /dev/loop0
/dev/sdd5"
It seems that has worked as an "fsck -n /dev/loop0" finally finds
something valid...

>fsck 1.41.14 (22-Dec-2010)
>e2fsck 1.41.12 (17-May-2010)
>Warning: skipping journal recovery because doing a read-only filesystem check.
>1.41.12-1285 contains a file system with errors, check forced.
>Pass 1: Checking inodes, blocks, and sizes
>Pass 2: Checking directory structure
>Pass 3: Checking directory connectivity
>Pass 4: Checking reference counts
>Pass 5: Checking group summary information
>Block bitmap differences:  -1100820 -1101341 -1101842 -1487894 -37977108
>Fix? no
>
>Free blocks count wrong (22975283, counted=12863078).
>Fix? no
>
>Free inodes count wrong (60447101, counted=60446034).
>Fix? no
>

Do you think that the fs is in a usable state?

Thanks
