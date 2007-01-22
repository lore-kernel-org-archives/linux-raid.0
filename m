From: "Liang Yang" <multisyncfe991@hotmail.com>
Subject: What is the exacting meaning of Striped_Cache_Size?
Date: Sun, 21 Jan 2007 22:38:01 -0700
Message-ID: <BAY125-DAV159818650D5FE72FE853E393AE0@phx.gbl>
References: <Pine.LNX.4.64.0701200718290.29223@p34.internal.lan> <Pine.LNX.4.64.0701200745420.3756@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Message-ID: <000301c73de7$7b0ce1d0$0401a8c0@bellevue>
In-Reply-To: <Pine.LNX.4.64.0701200745420.3756@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have tried to increase the Striped_Cache_Size from 256 (default for my
MD-RAID5 array) to 8192, it does improve the MD-RAID5 Write performance
which varies with the size of I/O packet.

However, I'm still not very clean the meaning and the potential performance
impact of this Striped_Cache_Size? Is the unit for this parameter Byte or
KiloByte?

Could anyone here explain with a little bit more details?

Thanks,

Liang


