From: Neil Brown <neilb@suse.de>
Subject: Re: questions about ext3, raid-5, small files and wasted disk space
Date: Mon, 14 Nov 2005 15:30:49 +1100
Message-ID: <17272.4857.555578.252094@cse.unsw.edu.au>
References: <000901c5e6ff$0865deb0$b7df0f3d@kyleont8n3poyo>
	<17269.54844.139.18467@cse.unsw.edu.au>
	<003901c5e8ce$1d1c0610$b7df0f3d@kyleont8n3poyo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from kyle on Monday November 14
Sender: linux-raid-owner@vger.kernel.org
To: kyle <kylewong@southa.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday November 14, kylewong@southa.com wrote:
> I understand now, thanks. RAID is more low level than filesystem, working at
> block device level, parity doesn't related to filesystem and file size at
> all, right?

Exactly right.

NeilBrown
