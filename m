From: "Don Dupuis" <dondster@gmail.com>
Subject: Re: Md corruption using RAID10 on linux-2.6.21
Date: Wed, 30 May 2007 20:52:16 -0500
Message-ID: <632b79000705301852p743be9f1la4fe440940b8f10e@mail.gmail.com>
References: <632b79000705161138h359f71egdf4ad5d483731dbe@mail.gmail.com>
	 <17995.46536.195175.894763@notabene.brown>
	 <632b79000705161957j5443e3b9h1d6da8593395f736@mail.gmail.com>
	 <632b79000705161958m67a192bav73ab3dafc08825d0@mail.gmail.com>
	 <632b79000705162050w70a2feb1w14919fde6e98818c@mail.gmail.com>
	 <632b79000705211232gfb57e0focae8cdd0bf25bef@mail.gmail.com>
	 <18002.15951.765872.809204@notabene.brown>
	 <632b79000705211947k471cc6fdr76dc74f334b8112c@mail.gmail.com>
	 <18002.27283.485975.942744@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18002.27283.485975.942744@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil, I sent the scripts to you. Any update on this issue?

Thanks
Don

On 5/21/07, Neil Brown <neilb@suse.de> wrote:
> On Monday May 21, dondster@gmail.com wrote:
> > I was going to get back with you concerning the low resync rates. The
> > data corruption happens like this.
> > 1.  Start with fully active array. Everything is fine.
> > 2.  I remove a drive. Everything is fine. I then will power off the machine.
> > 3.  I powerup and load up an initramfs which has my initial root
> > filesystem and scripts for handling the assembly of the array. My init
> > script will determine which drive was remove and assemble the
> > remaining 3.
>
> Could I see this script please?
>
> NeilBrown
>
