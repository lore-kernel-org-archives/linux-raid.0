From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID 1+0 makes BUG in raid1.c, but 0+1 works?
Date: Sat, 4 Jan 2003 08:05:25 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15893.64277.245126.966529@notabene.cse.unsw.edu.au>
References: <20021225172009.Z1089@questra.com>
	<15891.33465.348466.886941@notabene.cse.unsw.edu.au>
	<00b501c2b35e$33730970$6a01a8c0@bmoon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from bmoon on Friday January 3
To: bmoon <bo@anthologysolutions.com>
Cc: Scott Mcdermott <smcdermott@questra.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday January 3, bo@anthologysolutions.com wrote:
> Neil,
> 
> I am using 2.4.x(2.4.5  and 2.4.20) but I do not have "sync_page_io(" on
> /drivers/md/md.c.
> I am using RAID10, too. If it is critical I need to fix it.
> Should I try this patch?

No.  This patch is only relevant if you are using a 2.4.21-pre
kernel. 2.4.5 and 2.4.20 don't need it.

NeilBrown
