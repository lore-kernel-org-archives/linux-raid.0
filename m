From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Issue recovering a md device with first 4kB lost.
Date: Tue, 9 Oct 2012 09:19:34 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1210090918240.21297@uplift.swm.pp.se>
References: <CAPpPG0WfVjk7qoC=EdJ=E=vt1uK8amMr9Hb0Q_P0tVyy63f+_w@mail.gmail.com> <CAPpPG0UTjpwiWQyxKsT+JcZt3VgDeGBVddUBd_+8a2+U-50AzA@mail.gmail.com> <5073CF69.4@xs4all.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5073CF69.4@xs4all.net>
Sender: linux-raid-owner@vger.kernel.org
To: Miquel van Smoorenburg <mikevs@xs4all.net>
Cc: Massimo Gais <massimo.gais@iki.fi>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 9 Oct 2012, Miquel van Smoorenburg wrote:

> On 9-10-12 12:46 AM, Massimo Gais wrote:
>> I think all what is missing in order to access the ext4 filesystem is
>> the md superblock, but what can I do to recreate it?
>
> If you know where the ext4 filesystem starts, and you just want to access it, 
> then why not use a loopback device with an offset to get at the filesystem ?
>
> Something like
>
> 	losetup -o <offset-of-ext4-fs> /dev/loop0 /dev/sdd5
> 	mount -text4 -o ro /dev/loop0 /mnt

That assumes that lvm has allocated a continous amount of blocks for the 
filesystem. It might be better to try to find the lvm offset and then get 
lvm started properly and then getting the filesystem through lvm.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
