From: "Robin Bowes" <robin@robinbowes.com>
Subject: Re: ANNOUNCE: mdadm 1.6.0 - A tool for managing Soft RAID under
     Linux
Date: Fri, 4 Jun 2004 11:12:31 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40287.194.60.85.4.1086343951.squirrel@194.60.85.4>
References: <16576.5818.189830.563396@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16576.5818.189830.563396@cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, June 4, 2004 7:29, Neil Brown said:
>   - Further support for partitionable arrays included "--auto=" option
>     and "auto=" config file entry which instructs mdadm to create the necessary
>     device files after allocating an unused array number.

Neil,

I am interpreting this to mean that I can create, for example, a large (e.g. 1TB) RAID5
array and create smaller partitions (/home, /usr, etc) on top of the RAID5 array? Is
this correct?

Where can I read more about this?

Thanks,

R.
-- 
http://robinbowes.com

