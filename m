From: <me@heyjay.com>
Subject: Re: Can't add or delete a device from raid 1
Date: Wed, 26 May 2004 08:33:32 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <003e01c44326$0b682790$6705a8c0@a30>
References: <Pine.LNX.4.33.0405261443440.32533-100000@lw2.cc-computer.de>
Reply-To: <me@heyjay.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: mk423@lw1.cc-computer.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>
> What do "mdadm --detail /dev/md0" and "mdadm --examine /dev/hda1"
> report?
>
> Regards,
> Martin

When I did --detail it showed the array having 2 devices, the first of which
was faulty (the bottom of the screen).  Unfortunately, I can't do
the --examine.  This morning I got frustrated and:

dd if=/dev/zero of=/dev/hda &
dd if=/dev/zero of=/dev/hdc &

I'm going to start over with clean drives

Thanks
Jay

