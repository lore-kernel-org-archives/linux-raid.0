From: Neil Brown <neilb@suse.de>
Subject: Re: Md corruption using RAID10 on linux-2.6.21
Date: Tue, 22 May 2007 13:59:15 +1000
Message-ID: <18002.27283.485975.942744@notabene.brown>
References: <632b79000705161138h359f71egdf4ad5d483731dbe@mail.gmail.com>
	<17995.46536.195175.894763@notabene.brown>
	<632b79000705161957j5443e3b9h1d6da8593395f736@mail.gmail.com>
	<632b79000705161958m67a192bav73ab3dafc08825d0@mail.gmail.com>
	<632b79000705162050w70a2feb1w14919fde6e98818c@mail.gmail.com>
	<632b79000705211232gfb57e0focae8cdd0bf25bef@mail.gmail.com>
	<18002.15951.765872.809204@notabene.brown>
	<632b79000705211947k471cc6fdr76dc74f334b8112c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Don Dupuis on Monday May 21
Sender: linux-raid-owner@vger.kernel.org
To: Don Dupuis <dondster@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday May 21, dondster@gmail.com wrote:
> I was going to get back with you concerning the low resync rates. The
> data corruption happens like this.
> 1.  Start with fully active array. Everything is fine.
> 2.  I remove a drive. Everything is fine. I then will power off the machine.
> 3.  I powerup and load up an initramfs which has my initial root
> filesystem and scripts for handling the assembly of the array. My init
> script will determine which drive was remove and assemble the
> remaining 3.

Could I see this script please?

NeilBrown
