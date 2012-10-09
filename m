From: Miquel van Smoorenburg <mikevs@xs4all.net>
Subject: Re: Issue recovering a md device with first 4kB lost.
Date: Tue, 09 Oct 2012 09:16:57 +0200
Message-ID: <5073CF69.4@xs4all.net>
References: <CAPpPG0WfVjk7qoC=EdJ=E=vt1uK8amMr9Hb0Q_P0tVyy63f+_w@mail.gmail.com> <CAPpPG0UTjpwiWQyxKsT+JcZt3VgDeGBVddUBd_+8a2+U-50AzA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPpPG0UTjpwiWQyxKsT+JcZt3VgDeGBVddUBd_+8a2+U-50AzA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Massimo Gais <massimo.gais@iki.fi>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9-10-12 12:46 AM, Massimo Gais wrote:
> I think all what is missing in order to access the ext4 filesystem is
> the md superblock, but what can I do to recreate it?

If you know where the ext4 filesystem starts, and you just want to 
access it, then why not use a loopback device with an offset to get at 
the filesystem ?

Something like

	losetup -o <offset-of-ext4-fs> /dev/loop0 /dev/sdd5
	mount -text4 -o ro /dev/loop0 /mnt

Mike.
