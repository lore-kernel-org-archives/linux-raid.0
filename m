From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: Kernel 2.6.23.9 / P35 Chipset + WD 750GB Drives (reset port)
Date: Sat, 1 Dec 2007 17:47:33 +0100
Message-ID: <20071201174733.646a5c35@absurd>
References: <Pine.LNX.4.64.0712010619150.25643@p34.internal.lan>
	<Pine.LNX.4.64.0712011310410.30316@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0712010722590.28887@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0712010722590.28887@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz said:     (by the date of Sat, 1 Dec 2007 07:23:41 -0500 (EST))

> >> dd if=/dev/zero of=/dev/sdc
>
> The purpose is with any new disk its good to write to all the blocks and 
> let the drive to all of the re-mapping before you put 'real' data on it. 
> Let it crap out or fail before I put my data on it.

better use badblocks. It writes data, then reads it afterwards:
In this example the data is semi random (quicker than /dev/urandom ;)

badblocks -c 10240 -s -w -t random -v /dev/sdc

-- 
Janek Kozicki                                                         |
