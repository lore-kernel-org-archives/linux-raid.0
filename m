From: "Martin Eriksson" <nitrax@giron.wox.org>
Subject: Re: Enable HTT with dual xeon fileserver ?
Date: Wed, 18 Sep 2002 11:53:04 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <001d01c25ef9$6bc25240$900d0d93@M02WS17219>
References: <Pine.LNX.4.44.0209162301200.24650-100000@ddx.a2000.nu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: raid@ddx.a2000.nu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

----- Original Message -----
From: <raid@ddx.a2000.nu>
To: <linux-raid@vger.kernel.org>
Sent: Monday, September 16, 2002 11:02 PM
Subject: Enable HTT with dual xeon fileserver ?


> I'm building a Dual Xeon Fileserver
> i can enable HTT in the bios (so i have 4 logical processors)

I'm very sceptical that a fileserver would gain any performance from HT.

In fact, I don't really realize why you even need two CPU's? If you are
doing database lookups it's another thing though, also HT could give a
performance gain in that case (if it's supported by the linux kernel?).

> what is the advise for a fileserver ?
> (both running hardware raid5 (3ware) and software raid5 (on promise
> controllers)

A follow-up question: Does sw-raid5 checksumming use multiple CPUs in any
way?

/Martin

