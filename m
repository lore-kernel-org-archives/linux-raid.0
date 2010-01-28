From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Why does one get mismatches?
Date: Thu, 28 Jan 2010 21:24:46 +0100
Message-ID: <874om6m0z5.fsf@frosties.localdomain>
References: <201001252043.o0PKhseR027690@wind.enjellic.com>
	<27F5783C-96DC-4B04-A3EF-D5E7F5F1DD6B@crc.id.au>
	<AC5E1C3367E37D44970B81A6ADD1DA2C08AE1690@SDCEXCHANGE01.ad.amcc.com>
	<AC5E1C3367E37D44970B81A6ADD1DA2C08AE1842@SDCEXCHANGE01.ad.amcc.com>
	<87iqamxf4l.fsf@frosties.localdomain>
	<AC5E1C3367E37D44970B81A6ADD1DA2C08AE18C4@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AC5E1C3367E37D44970B81A6ADD1DA2C08AE18C4@SDCEXCHANGE01.ad.amcc.com>
	(Tirumala Reddy Marri's message of "Thu, 28 Jan 2010 11:03:59 -0800")
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Tirumala Reddy Marri" <tmarri@amcc.com> writes:

> I just tried and miss-match count is zero. Interesting, is XOR engine
> doing something wrong ? . Then I ran a test where I raw-write the file
> to /dev/md0. Then did the raw-read for the same size. In this case XOR
> matched as expected. Then I failed a drive using "mdadm -f /dev/md0
> /dev/sda". Then I read the same size data again from /dev/md0. And
> checksum matches too. 
> What is this mean XOR engine is doing right thing. But "chec/repair"
> test is not functioning properly with XOR-engine ?
>
> Or is this something to do with  how the buffers are handled ? may they
> are cached ?
>
>
> -Marri

No idea. But if everything works without the XOR engine and gives
mismatches with then I would think there is a software or hardware error
there and not in the cable or disks.

MfG
        Goswin
