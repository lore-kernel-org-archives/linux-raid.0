From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm spare-group not working for me
Date: Fri, 23 Jul 2004 13:30:05 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16640.34365.538177.870871@cse.unsw.edu.au>
References: <Pine.LNX.4.58.0407070745260.20019@praktifix.dwd.de>
	<16619.54193.685669.468567@cse.unsw.edu.au>
	<Pine.LNX.4.58.0407071114270.20019@praktifix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Holger Kiehl on Wednesday July 7
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday July 7, Holger.Kiehl@dwd.de wrote:
> 
> Is it possible to influence the order at which the spares are taken
> from the group? Reason is that I have four spare partitions on two
> ide disks (2 partitions on each disk). Removing a second disk I
> noticed it picked the second partition from the same disk. The spares
> where added in this order hde7 hda7 hde6 hda6, but mdadm picked hde7
> and then hde6. Better would be hde then hda.

No, it is not possible to do that reliably.

mdadm will tend to choose the first one it finds.  So if you add the
best choices as spared first, and then add the poorer choices, it
might be more likely to choose the one you want.

NeilBrown
