From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: [PATCH 008 of 8] md/bitmap: Change md/bitmap file handling to
 use bmap to file blocks.
Date: Sat, 13 May 2006 11:29:32 -0400
Message-ID: <4465FB5C.6070808@steeleye.com>
References: <20060512160121.7872.patches@notabene>	<1060512060809.8099@suse.de>	<20060512104750.0f5cb10a.akpm@osdl.org>	<17509.22160.118149.49714@cse.unsw.edu.au> <20060512235934.4f609019.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060512235934.4f609019.akpm@osdl.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Andrew Morton wrote:

> The loss of pagecache coherency seems sad.  I assume there's never a
> requirement for userspace to read this file.

Actually, there is. mdadm reads the bitmap file, so that would be 
broken. Also, it's just useful for a user to be able to read the bitmap 
(od -x, or similar) to figure out approximately how much more he's got 
to resync to get an array in-sync. Other than reading the bitmap file, I 
don't know of any way to determine that.

--
Paul

