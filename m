From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: [Jfs-discussion] maximum filesystem size limit
Date: Wed, 9 Oct 2002 11:53:59 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200210091153.59452.roy@karlsbakk.net>
References: <8D587D949A61D411AFE300D0B74D75D703F0BF1B@server.s8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8D587D949A61D411AFE300D0B74D75D703F0BF1B@server.s8.com>
To: Cameron Bahar <CBahar@s8.com>, "'jfs-discussion@www-124.ibm.com'" <jfs-discussion@www-124.southbury.usf.ibm.com>
Cc: Kernel mailing list <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday 08 October 2002 23:14, Cameron Bahar wrote:
> I need support for a single 12 TB filesystem on Linux. The documentation
> indicates that JFS supports a theoretical 4PB limit, but that other
> limitations (32 bit offsets) within limit prevent scaling to this large
> size.
>
> Can someone please tell me if I can use JFS to create a single 12TB
> filesystem under Linux?

Afaik, you have a problem here concerning the Linux 2.4 maximum block device 
size of 2TB.

Anyone that knows if there's a workaround for this using LVM or something?

roy

-- 
Roy Sigurd Karlsbakk, Datavaktmester
ProntoTV AS - http://www.pronto.tv/
Tel: +47 9801 3356

Computers are like air conditioners.
They stop working when you open Windows.

