From: "Tuomas Leikola" <tuomas.leikola@gmail.com>
Subject: Re: Can't mount /dev/md0 after stopping a synchronization
Date: Sun, 9 Apr 2006 23:48:11 +0300
Message-ID: <5b170a7d0604091348w68403d9ub34f26472b9dd1e6@mail.gmail.com>
References: <c79e949d0604042045w2fb901c2rfb4c00984f6b8761@mail.gmail.com>
	 <4433E073.8040502@fnuck.dk>
	 <c79e949d0604050839k2287fefdm53f6abb08dfcae89@mail.gmail.com>
	 <5b170a7d0604050920p674e10a9u9e26a52fcf3933c1@mail.gmail.com>
	 <c79e949d0604050959o6feb6badx5f854a937a337a1d@mail.gmail.com>
	 <5b170a7d0604070617s304b3366i4573e97b4fbe6650@mail.gmail.com>
	 <c79e949d0604080845m720f2bard3a140486155c006@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c79e949d0604080845m720f2bard3a140486155c006@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Mike Garey <random51k@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 4/8/06, Mike Garey <random51k@gmail.com> wrote:
> I have one last question though.. When I update /boot/grub/menu.lst
> while booted from /dev/md0 with both disks available, does this file
> get written to the MBR on both disks, or do I have to do this
> manually?
>

Grub's configuration lives on both mirrors, as it's in the filesystem,
not in MBR. At boot time, grub kinda "mounts" the filesystem and reads
the configuration from there. (grub doesn't understand the mirror, but
it doesn't need to)
