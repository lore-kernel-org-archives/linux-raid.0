From: PFC <lists@peufeu.com>
Subject: Re: Large single raid and XFS or two small ones and EXT3?
Date: Fri, 23 Jun 2006 10:59:40 +0200
Message-ID: <op.tblclqd3cigqcu@apollo13>
References: <449AEB7C.6040108@cjx.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <449AEB7C.6040108@cjx.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Allen <chris@cjx.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


	- XFS is faster and fragments less, but make sure you have a good UPS
	- ReiserFS 3.6 is mature and fast, too, you might consider it
	- ext3 is slow if you have many files in one directory, but has more  
mature tools (resize, recovery etc)

	I'd go with XFS or Reiser.
	
