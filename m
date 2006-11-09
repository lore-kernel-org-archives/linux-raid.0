From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 001 of 6] md: Send online/offline uevents when an md
	array starts/stops.
Date: Thu, 9 Nov 2006 11:17:57 +1100
Message-ID: <17746.29621.106336.339322@cse.unsw.edu.au>
References: <20061031164814.4884.patches@notabene>
	<1061031060046.5034@suse.de>
	<20061031211615.GC21597@suse.de>
	<3ae72650611020413q797cf62co66f76b058a57104b@mail.gmail.com>
	<17737.58737.398441.111674@cse.unsw.edu.au>
	<1162475516.7210.32.camel@pim.off.vrfy.org>
	<17738.59486.140951.821033@cse.unsw.edu.au>
	<1162542178.14310.26.camel@pim.off.vrfy.org>
	<17742.32612.870346.954568@cse.unsw.edu.au>
	<1162984482.16735.25.camel@pim.off.vrfy.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Kay Sievers on Wednesday November 8
Sender: linux-raid-owner@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@osdl.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday November 8, kay.sievers@vrfy.org wrote:
> 
> Is there a sysfs file or something similar(we could also call a md-tool)
> udev could look at, before it tries to open the device? Like:
>   KERNEL=="md*", ATTR{state}=="active", IMPORT{program}= ...

If the /sys/block/mdX directory exists at all, it is safe to open the
device-special file.  But that is racy.  It could disappear between
checking that the dir exists, and opening the device-special-file.

I still think it would make SO much sense if /sys/block/md4/dev were a
device-special-file instead of a (silly) ascii file with 9:4.  Then
this race could be closed.  But I feel that is a battle I've never
going to win.

You could look at /sys/block/mdX/md/array_state.  If that contains
'clean' or 'inactive' then there is no point opening the device.
Otherwise there might be a point, and the race would be a lot harder
to lose.

I guess it is time for me to learn about udev config files...

NeilBrown
