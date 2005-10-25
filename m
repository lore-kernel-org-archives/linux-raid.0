From: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Subject: Re[2]: split RAID1 during backups?
Date: Tue, 25 Oct 2005 22:48:38 +0200
Message-ID: <1044207669.20051025224838@kaneda.iguw.tuwien.ac.at>
References: <E1EUGvu-0006Sr-00@toko.jab.org>
Reply-To: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E1EUGvu-0006Sr-00@toko.jab.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

don't know if my comment helps:

how about using xfs instead of reiserfs ? xfs was designed for high
performance on heavy-loaded big irons.

since we now have such a heavy-loaded big iron here, it would be
interesting to see the difference in performance.

-- 
Best regards,
 Rainer                            mailto:rfu@kaneda.iguw.tuwien.ac.at

