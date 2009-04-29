From: Daniel Reurich <daniel@centurion.net.nz>
Subject: Re: md extension to support booting from raid whole disks.
Date: Wed, 29 Apr 2009 14:08:25 +1200
Message-ID: <1240970905.18303.1085.camel@ezra>
References: <1240574900.4507.2076.camel@ezra>
	 <18935.35883.181289.739254@notabene.brown>  <49F79331.1050007@zytor.com>
	 <1240963507.18303.866.camel@ezra>  <49F79A0B.1000805@zytor.com>
	 <1240965373.18303.929.camel@ezra>  <49F7A2E3.4000908@zytor.com>
	 <1240968482.18303.1028.camel@ezra>  <49F7B162.8060301@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49F7B162.8060301@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Grub2 can't be "fixed" with anything less than replicating the entire
> device driver system of Linux in it, which is equivalent to turning it
> into Linux.
> 
Ok then....

So we need then to make mdadm --add hook into some tools that can
automatically replicate the partition table layout and add each
respective partition into it's respective raid volume, and
install/replicate the bootloader onto the disk.

Also then we should really have tool to set this up properly as well on
the initial creation of the raid.


-- 
Daniel Reurich

Centurion Computer Technology (2005) Ltd
Ph 021 797 722

