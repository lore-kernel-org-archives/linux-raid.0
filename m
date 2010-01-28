From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Why does one get mismatches?
Date: Thu, 28 Jan 2010 19:23:38 +0100
Message-ID: <87iqamxf4l.fsf@frosties.localdomain>
References: <201001252043.o0PKhseR027690@wind.enjellic.com>
	<27F5783C-96DC-4B04-A3EF-D5E7F5F1DD6B@crc.id.au>
	<AC5E1C3367E37D44970B81A6ADD1DA2C08AE1690@SDCEXCHANGE01.ad.amcc.com>
	<AC5E1C3367E37D44970B81A6ADD1DA2C08AE1842@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AC5E1C3367E37D44970B81A6ADD1DA2C08AE1842@SDCEXCHANGE01.ad.amcc.com>
	(Tirumala Reddy Marri's message of "Thu, 28 Jan 2010 09:20:29 -0800")
Sender: linux-raid-owner@vger.kernel.org
To: Tirumala Reddy Marri <tmarri@amcc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Tirumala Reddy Marri" <tmarri@amcc.com> writes:

> I have noticed that if I zero the /dev/md0 using "dd if=/dev/zero
> of=/dev/md0 bs=4k count=64k". Then I run the "echo check >
> /sys/block/md0/md/sync_action", no mismatch_cnt reported.  If I use
> "if=/some/file" then I see miss match count to set to huge number.
>
> I am testing with small RAID-5 size for quick testing.  How a reliable
> is this test ? I am using HW accelerated XOR engine for RAID-5.

Have you tried without?

Maybe the XOR engine creates garbage.

MfG
        Goswin
