From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: partitions on software-raid
Date: Tue, 16 Dec 2003 11:02:00 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3FDF2C78.A3CE64F5@SteelEye.com>
References: <3FDF285D.806@ratnet.stw.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: schmidt@naa.net
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Norman Schmidt wrote:

> Is this functionality implemented yet? I do not understand much C, so I

No, the md driver does not support partitions.


> I am willing to test if this functionality exists, if not, I am forced
> to partition the underlying drives.

With md, at least, that's your only option right now. You could maybe
look into lvm to do (non-standard) partitioning...

--
Paul
