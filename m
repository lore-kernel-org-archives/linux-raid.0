From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RAID-6: help wanted
Date: Tue, 26 Oct 2004 22:56:12 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <417F387C.7010807@zytor.com>
References: <cleqh6$ps4$1@terminus.zytor.com>	<16764.37392.910080.718564@cse.unsw.edu.au>	<20041025062026.GA17502@jim.sh> <16767.6168.695527.234379@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16767.6168.695527.234379@cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Jim Paris <jim@jtan.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Okay, I think the "inode 7" problem is unrelated, because it happens 
without any disk failures, it happens on RAID-0, RAID-5, and even on a 
plain loop device.  I suspect there is something wrong in the ppc64 
kernel; I'll try it again on i386 and report back.

	-hpa

