From: Neil Brown <neilb@suse.de>
Subject: Re: raid5 resizing
Date: Mon, 1 May 2006 15:33:49 +1000
Message-ID: <17493.40381.454128.908875@cse.unsw.edu.au>
References: <20060501052334.GB2741@zip.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from CaT on Monday May 1
Sender: linux-raid-owner@vger.kernel.org
To: CaT <cat@zip.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday May 1, cat@zip.com.au wrote:
> Hey folks.
> 
> There's no point in using LVM on a raid5 setup if all you intend to do
> in the future is resize the filesystem on it, is there? The new raid5
> resizing code takes care of providing the extra space and then as long
> as the say ext3 filesystem is created with resize_inode all should be
> sweet. Right? Or have I missed something crucial here? :)

You are correct.  md/raid5 makes the extra space available all by
itself. 

NeilBrown
