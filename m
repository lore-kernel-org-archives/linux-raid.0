From: CaT <cat@zip.com.au>
Subject: raid5 resizing
Date: Mon, 1 May 2006 15:23:34 +1000
Message-ID: <20060501052334.GB2741@zip.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hey folks.

There's no point in using LVM on a raid5 setup if all you intend to do
in the future is resize the filesystem on it, is there? The new raid5
resizing code takes care of providing the extra space and then as long
as the say ext3 filesystem is created with resize_inode all should be
sweet. Right? Or have I missed something crucial here? :)

-- 
    "To the extent that we overreact, we proffer the terrorists the
    greatest tribute."
    	- High Court Judge Michael Kirby
