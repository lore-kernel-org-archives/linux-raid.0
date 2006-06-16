From: Neil Brown <neilb@suse.de>
Subject: Re: Raid5 reshape
Date: Sat, 17 Jun 2006 08:44:49 +1000
Message-ID: <17555.13409.834439.80361@cse.unsw.edu.au>
References: <449250ED.7090302@irule.net>
	<17554.21119.487820.638171@cse.unsw.edu.au>
	<4492D5B1.60004@nigelterry.net>
	<4492D8D9.7010101@irule.net>
	<17555.12441.42212.93049@cse.unsw.edu.au>
	<4493330E.30501@nigelterry.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Nigel J. Terry on Friday June 16
Sender: linux-raid-owner@vger.kernel.org
To: "Nigel J. Terry" <nigel@nigelterry.net>
Cc: Tim T <irule@irule.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday June 16, nigel@nigelterry.net wrote:
> Thanks for all the advice. One final question, what kernel and mdadm 
> versions do I need?

For resizing raid5:

mdadm-2.4 or later
linux-2.6.17-rc2 or later

NeilBrown
