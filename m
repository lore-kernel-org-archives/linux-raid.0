From: "Anders K. Pedersen" <akp@cohaesio.com>
Subject: Re: adding disk to raid5 array
Date: Wed, 10 Apr 2002 21:11:06 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3CB48E4A.A1513ACB@cohaesio.com>
References: <20020409111408.A11555@pida.in.idoox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Hajek wrote:
> is it possible to adding disks to existing software
> RAID 5 array without backup/restore cycle?

Take a look at raidreconf available from
http://unthought.net/raidreconf/index.shtml. No matter what, you should
make sure a good backup exists, but this might save you from doing the
restore.

Regards,
Anders K. Pedersen
