From: "Francois Barre" <francois.barre@gmail.com>
Subject: Re: trying to "brute-force" my RAID 5...
Date: Tue, 18 Jul 2006 10:17:44 +0200
Message-ID: <fd8d0180607180117u73aa0259i3cdfcf5580148bc3@mail.gmail.com>
References: <44BAB76D.9070809@start.no>
	 <17596.15323.451555.218541@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17596.15323.451555.218541@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Sevrin Robstad <quackyo@start.no>
List-Id: linux-raid.ids

> What are you expecting fdisk to tell you?  fdisk lists partitions and
> I suspect you didn't have any partitions on /dev/md0
> More likely you want something like
>    fsck -n -f /dev/md0
>
> and see which one produces the least noise.

Maybe a simple file -s /dev/md0 could do the trick, and would only
produce output different from the mere "data" when the good
configuration is found...

-- 
F.-E.B.
