From: Bernd Fischer <bernd@begu.net>
Subject: Re: mbr-install for Raid 1
Date: Tue, 05 Oct 2004 20:25:02 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4162E6FE.90400@begu.net>
References: <20041005093440.2b639e71@zrr.local>	<41626483.60505@tls.msk.ru> <20041005154755.021a0f72@zrr.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20041005154755.021a0f72@zrr.local>
To: RAID Linux <linux-raid@vger.kernel.org>
Cc: "Zeno R.R. Davatz" <zdavatz@ywesee.com>
List-Id: linux-raid.ids

Zeno R.R. Davatz wrote:

 > I am just thinking of one more problem that turned up.

 > You suppose that I am running a RAID1 as you say I should install the
 > boot-image of lilo to my root partition because Install-Mbr checks
 > for it there. My problem: My Root-Partition is a RAID5. I would like
 > to boot from a RAID1 and get my RAID5 going from there.

Basically the same procedure. Just replace the words "root partition"
with "boot partition" or "partition on which you install your kernel" in
Michaels instructions.

Bernd Fischer
