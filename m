From: John Hendrikx <hjohn@xs4all.nl>
Subject: Re: multiple Sata SATAII 150, TX4  - how to tell which drive is which?
 headaches galore!
Date: Mon, 23 Jan 2006 21:53:15 +0100
Message-ID: <43D5423B.3010006@xs4all.nl>
References: <20060123204404.41cfc6ef@ted.secure-tunnel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060123204404.41cfc6ef@ted.secure-tunnel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shawn Usry <shawn@joebacardi.com>
Cc: PFC <lists@peufeu.com>, Mitchell Laks <mlaks@verizon.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Shawn Usry wrote:
> The drives physically support SMART, but apparently the roadblock is lacking support in the libata drivers.  If you can force "legacy" mode from your Bios and drive your SATA disks with drivers/ide you can get full SMART support.
>
> The details:
> http://smartmontools.sourceforge.net/#testinghelp
>   
Thanks -- I didn't have to change anything in the bios, just adding "-d 
ata" to smartctl worked for me.  Apparently I have a recent enough kernel.

