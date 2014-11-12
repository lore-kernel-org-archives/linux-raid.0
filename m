From: pg@lxra2.foro.sabi.co.UK (Peter Grandi)
Subject: Re: RAID 6 (containing LUKS dm-crypt) recovery help.
Date: Wed, 12 Nov 2014 11:01:38 +0000
Message-ID: <21603.15890.184931.564027@tree.ty.sabi.co.uk>
References: <545C5C9D.9000309@retard.io>
	<21596.40429.244605.398712@tree.ty.sabi.co.uk>
	<545CAFA8.2030602@retard.io>
	<21596.54723.487775.652906@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <21596.54723.487775.652906@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> You can try to recreate the MD set superblocks specifying the
> right data offset and member size for each member, as given by
> the '--examine' outputs. Google knows how...

Just in case, this describes a very similar case:

http://www.spinics.net/lists/raid/msg39353.html
