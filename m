From: maarten <maarten@ultratux.net>
Subject: Re: raid5 initialization errors during boot not after boot. raid5 driver loaded both times.
Date: Mon, 10 Jan 2005 23:12:18 +0100
Message-ID: <200501102312.18652.maarten@ultratux.net>
References: <200501101611.27350.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501101611.27350.mlaks@verizon.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 10 January 2005 22:11, Mitchell Laks wrote:
> Hi,
> I am running debian sarge linux kernel 2.6.8.  I boot from a sata
> drive /dev/sda, and set up a raid5 on /dev/hda, /dev/hdc, /dev/hde,
> /dev/hdg.
>
> I turned off udev, and created /dev/md0 and I loaded raid5 module into
> initrd.img.

(Just a guess): make sure that you have "md" and "raid5" in initrd.

> raid5: device hdc1 operational as raid disk 1
> raid5: device hda1 operational as raid disk 0
> raid5: not enough operational devices for md0 (2/4 failed)

It says there what's wrong: it sees only hda and hdc at that point.

So I have to assume not all needed boot modules (libata, sata-*) are included 
in your initrd.

Maarten

-- 


