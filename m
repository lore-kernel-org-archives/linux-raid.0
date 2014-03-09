From: Raul Dias <raul@dias.com.br>
Subject: Re: Linux software-RAID and bootloader
Date: Sun, 9 Mar 2014 00:52:09 -0300
Message-ID: <CAE6VuKH2E0rMVZAg8ugjR8BRmknyUNS_D8EOOr4UjBbFsuVeOg@mail.gmail.com>
References: <CAJx5YvGGM7yziWQEefs=_Wte4jy13w1x1oG6MuUOggSgTfodMQ@mail.gmail.com>
	<67153819-285E-430A-A745-A96D6ECDA4DB@colorremedies.com>
	<CAJx5YvF7t=suX8jzQso4cjPPqFgCgBDXiop9i47F+C2A2KtR=g@mail.gmail.com>
	<20C9589F-7F5F-49D0-916E-9A6AA6B833BA@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20C9589F-7F5F-49D0-916E-9A6AA6B833BA@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2014-03-08 18:20 GMT-03:00 Chris Murphy <lists@colorremedies.com>:

> If BIOS, yes grub-install to each member disk. If UEFI, install to one, and then manually create and copy to the others (for now).

Simply mounting eachUEFI vfat partitions and copy the files is enough?
Does it need to be updated on every new kernel update (grub menu
item)?

thanks
