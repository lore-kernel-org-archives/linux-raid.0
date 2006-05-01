From: Mike Hardy <mhardy@h3c.com>
Subject: Re: raid5 resizing
Date: Mon, 01 May 2006 05:28:50 -0700
Message-ID: <4455FF02.4050404@h3c.com>
References: <20060501052334.GB2741@zip.com.au> <17493.40381.454128.908875@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17493.40381.454128.908875@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: CaT <cat@zip.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Neil Brown wrote:
> On Monday May 1, cat@zip.com.au wrote:
> 
>>Hey folks.
>>
>>There's no point in using LVM on a raid5 setup if all you intend to do
>>in the future is resize the filesystem on it, is there? The new raid5
>>resizing code takes care of providing the extra space and then as long
>>as the say ext3 filesystem is created with resize_inode all should be
>>sweet. Right? Or have I missed something crucial here? :)
> 
> 
> You are correct.  md/raid5 makes the extra space available all by
> itself. 

Further - even if you don't create the filesystem with the right amount
of extra metadata space for online resizing, you can resize any ext2/3
filesystem offline, and it doesn't take very long. You just use
resize2fsf instead of ext2online

-Mike
