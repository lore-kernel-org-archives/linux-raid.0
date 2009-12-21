From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Typical RAID5 transfer speeds
Date: Mon, 21 Dec 2009 14:50:52 +1300
Message-ID: <4B2ED47C.7010307@sauce.co.nz>
References: <B26AD6F5-45F6-4CC6-AE63-E4253E60076C@mac.com>	 <4B2D4731.3090702@gmail.com>	 <4877c76c0912192021s2c3da63au57f5dcb0391b3eb3@mail.gmail.com>	 <4B2E6CDB.3000707@gmail.com> <4877c76c0912201718l6d7ab948q4c57a07109678cb5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c0912201718l6d7ab948q4c57a07109678cb5@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: Roger Heflin <rogerheflin@gmail.com>, Matt Tehonica <matt.tehonica@mac.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Evans wrote:

> seems to be only one manufacturer, and only one seller currently.  I
> guess most people building >6 drive arrays have the cash to waste on
> limited boxed solutions or higher-end hardware controllers that
> abstract the details (and often flexibility) from the system.

Or use dumb LSI SAS controllers (sas3442e-r with IT firmware loaded, 
$200) and port expander based chassis that allow considerable 
flexibility regarding md RAID and number of SAS/SATA drives attached.

The only current caveat that is being worked on, is that use of 
smartmontools causes drives to disconnect.

Regards,

Richard
