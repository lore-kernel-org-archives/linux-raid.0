From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Exporting which partitions to md-configure
Date: Mon, 30 Jan 2006 18:38:47 -0800
Message-ID: <43DECDB7.2070604@zytor.com>
References: <43DEB4B8.5040607@zytor.com>	<17374.47368.715991.422607@cse.unsw.edu.au>	<859CB9D0-A1D3-4931-9D9F-96153D0F3E1B@mac.com> <17374.50453.727662.493504@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17374.50453.727662.493504@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Kyle Moffett <mrmacman_g4@mac.com>, klibc list <klibc@zytor.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> 
> Mac partition tables doesn't currently support autodetect (as far as I
> can tell).  Let's keep it that way.
> 

For now I guess I'll just take the code from init/do_mounts_md.c; we can 
worry about ripping the RAID_AUTORUN code out of the kernel later.

	-hpa

