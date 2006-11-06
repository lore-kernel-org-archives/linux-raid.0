From: dean gaudet <dean@arctic.org>
Subject: Re: [PATCH 001 of 6] md: Send online/offline uevents when an md
 array starts/stops.
Date: Mon, 6 Nov 2006 00:38:32 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0611060030320.20361@twinlark.arctic.org>
References: <20061031164814.4884.patches@notabene> <1061031060046.5034@suse.de>
 <20061031211615.GC21597@suse.de> <3ae72650611020413q797cf62co66f76b058a57104b@mail.gmail.com>
 <17737.58737.398441.111674@cse.unsw.edu.au> <1162475516.7210.32.camel@pim.off.vrfy.org>
 <17738.59486.140951.821033@cse.unsw.edu.au> <1162542178.14310.26.camel@pim.off.vrfy.org>
 <17742.32612.870346.954568@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17742.32612.870346.954568@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <gregkh@suse.de>, Andrew Morton <akpm@osdl.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 6 Nov 2006, Neil Brown wrote:

> This creates a deep disconnect between udev and md.
> udev expects a device to appear first, then it created the
> device-special-file in /dev.
> md expect the device-special-file to exist first, and then created the
> device on the first open.

could you create a special /dev/mdx device which is used to 
assemble/create arrays only?  i mean literally "mdx" not "mdX" where X is 
a number.  mdx would always be there if md module is loaded... so udev 
would see the driver appear and then create the /dev/mdx.  then mdadm 
would use /dev/mdx to do assemble/creates/whatever and cause other devices 
to appear/disappear in a manner which udev is happy with.

(much like how /dev/ptmx is used to create /dev/pts/N entries.)

doesn't help legacy mdadm binaries... but seems like it fits the New World 
Order.

or hm i suppose the New World Order is to eschew binary interfaces and 
suggest a /sys/class/md/ hierarchy with a bunch of files you have to splat 
ascii data into to cause an array to be created/assembled.

-dean
