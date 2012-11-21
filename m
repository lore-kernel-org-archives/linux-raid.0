From: "George Spelvin" <linux@horizon.com>
Subject: Re: want-replacement got stuck?
Date: 21 Nov 2012 13:08:01 -0500
Message-ID: <20121121180801.5601.qmail@science.horizon.com>
References: <20121121224120.65129930@natsu>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121121224120.65129930@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: linux@horizon.com, rm@romanrm.ru
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> This is a message that your system even got a checksum error when verifying an
> UDP packet received from the network -- something completely unrelated to
> Ext4, MD or disks in general.
> 
> I'd say you just have bad RAM/motherboard/CPU or some related general hardware
> failure.

Please think a second and realize how ridiculous a suggestion that is.

The reason that network packet checksums exist is because networks
sometimes corrupt packets.  It is not surprising to see one every
few hours.

The system is running on ECC memory, with few errors logged (but not zero;
scrubbing logs work!) and has been very stable for years, including
lengthy mprime (prime95) runs.

How about the more likely alternative that the packet was actually
corrupted in the network?  Or even sent with a bad checksum as part
of some sort of vulnerability scan?

Look at the packet:
UDP: bad checksum. From 187.194.52.187:65535 to 71.41.210.146:6881 ulen 70

Source: port 65535 is not a typical OS-chosen port number.
The source host appears to be an ISP in Mexico.
The destination port is a common bittorrent port, which is not in use.

This is some bot-net port-scanning.

The packet isn't in RAM for more than a few microseconds before the
checksum is verified and rejected.  Any error in my machine would have
to be in the network card (in which case it wouldn't affect the disk),
or the RAM error rate would have to be so high it would insta-crash.
