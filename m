From: Stephan van Hienen <raid@a2000.nu>
Subject: Re: fsck out of memory
Date: Fri, 7 Feb 2003 18:08:07 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.53.0302071807270.1306@ddx.a2000.nu>
References: <Pine.LNX.4.33.0302071719520.13536-100000@nooks.wimpunk.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.33.0302071719520.13536-100000@nooks.wimpunk.com>
To: Wim Vinckier <wim-raid@tisnix.be>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 7 Feb 2003, Wim Vinckier wrote:

> I would really use fsck.ext3...  I guess it will give a lot less errors...

fsck.ext3 = fsck.ext2

]# fsck.ext3 /dev/md0
e2fsck 1.32 (09-Nov-2002)

