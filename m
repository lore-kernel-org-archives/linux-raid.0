From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Velociraptor biting the dust (9th disk, continued to use it,
 and..)
Date: Sat, 22 Nov 2008 21:55:29 +0000
Message-ID: <20081122215529.1973f820@lxorguk.ukuu.org.uk>
References: <alpine.DEB.1.10.0811221638360.707@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0811221638360.707@p34.internal.lan>
Sender: linux-ide-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, smartmontools-support@lists.sourceforge.net, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids

> [625188.381125]          res 51/40:a8:7b:57:8a/00:01:1c:00:00/e0 Emask 0x9 (medi
> a error)
> [625188.381130] ata1.00: status: { DRDY ERR }
> [625188.381133] ata1.00: error: { UNC }

UNC - uncorrectable error (eg a bad block)

> [631340.401912] ata1.00: status: { DRDY ERR }
> [631340.401914] ata1.00: error: { ABRT }

ABRT - usually unsupported command

> [632714.975844] ata1.00: status: { DRDY ERR }
> [632714.975847] ata1.00: error: { IDNF }

IDNF - ID not found, usually these days means 'asked for a sector out of
range'

Alan
