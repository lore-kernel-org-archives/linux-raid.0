From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: query regarding raidtool and 2.6 kernel
Date: Tue, 4 May 2004 12:31:02 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16535.102.662088.857364@cse.unsw.edu.au>
References: <20040420134257.10801.qmail@web61004.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from John Abraham on Tuesday April 20
To: John Abraham <johnabraham291077@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday April 20, johnabraham291077@yahoo.com wrote:
> Hello List
> I am newbie for raid so sorry of a silly query. I have
> following query regarding the raid support on linux. 
>  
> In linux kernel 2.6 source i have found there is
> implementation of version 1 superblock (in file
> drivers/md/md.c), but i have not found any raidtool,
> which is using this version of superblock.
> I have looked at raidtools-1.00.3 (i suppose it is
> latest one, if not pls provide me latest tools which
> are using version 1.0 of super block) and found that
> tools are using 0.90 version of raid super block.
>  
> Can anybody tell me, why the newer version of raid
> superblock is introduced in linux kenel 2.6 ? Any
> updates regarding this would be helpful.
>  
> Kindly cc reply to me also as i am not member of list.

There is not yet any tool for working with version 1 superblocks.

NeilBrown
