From: Massimo Gais <massimo.gais@iki.fi>
Subject: Re: Issue recovering a md device with first 4kB lost.
Date: Tue, 9 Oct 2012 10:28:28 +0300
Message-ID: <CAPpPG0W0JB3r499LTDeEPDYUe1PjKhvU8tRFS6WMrhQptnM-TA@mail.gmail.com>
References: <CAPpPG0WfVjk7qoC=EdJ=E=vt1uK8amMr9Hb0Q_P0tVyy63f+_w@mail.gmail.com>
	<CAPpPG0UTjpwiWQyxKsT+JcZt3VgDeGBVddUBd_+8a2+U-50AzA@mail.gmail.com>
	<5073CF69.4@xs4all.net>
	<alpine.DEB.2.00.1210090918240.21297@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1210090918240.21297@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Miquel van Smoorenburg <mikevs@xs4all.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Oct 9, 2012 at 10:19 AM, Mikael Abrahamsson <swmike@swm.pp.se> wrote:

>> If you know where the ext4 filesystem starts, and you just want to access
>> it, then why not use a loopback device with an offset to get at the
>> filesystem ?
>>
>> Something like
>>
>>         losetup -o <offset-of-ext4-fs> /dev/loop0 /dev/sdd5
>>         mount -text4 -o ro /dev/loop0 /mnt
>
>
> That assumes that lvm has allocated a continous amount of blocks for the
> filesystem. It might be better to try to find the lvm offset and then get
> lvm started properly and then getting the filesystem through lvm.
>

How to find that offset for the ext4? And I guess that to verify
whether lvm has allocated a continuous amount of blocks, a "fsck -n
/dev/loop0" would allow to test that the fs is in a consistent state.

Otherwise, which command to use to start lvm properly?
