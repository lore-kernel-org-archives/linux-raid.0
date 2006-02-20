From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: block level vs. file level
Date: Mon, 20 Feb 2006 17:53:18 +0100
Message-ID: <62b0912f0602200853m72af5676y4f2dcd07fe358ef8@mail.gmail.com>
References: <43EF8CFB.5080403@kfa.org> <20060212213157.GX32687@strugglers.net>
	 <43EFDDF7.6090405@kfa.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43EFDDF7.6090405@kfa.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: it <itech@kfa.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

it wrote:
> Ouch.
>
> How does hardware raid deal with this? Does it?

Hardware RAID controllers deal with this by rounding the size of
participant devices down to nearest GB, on the assumption that no
drive manufacturers would have the guts to actually sell eg. a 250 GB
drive with less than exactly 250.000.000.000 bytes of space on it.

(It would be nice if the various flavors of Linux fdisk had an option
to do this. It would be very nice if anaconda had an option to do
this.)
