From: Jean Jordaan <jean@upfrontsystems.co.za>
Subject: Re: Recovering RAID5 array
Date: Tue, 20 Jan 2004 09:17:51 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <400CD61F.9010502@upfrontsystems.co.za>
References: <400CD0BF.2010808@upfrontsystems.co.za> <16396.53737.911347.812076@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16396.53737.911347.812076@notabene.cse.unsw.edu.au>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil

Thanks for the answer!

>    mdadm --detail /dev/md0
> didn't tell you??

It probably tried, but I was too rattled to parse all the
lun/target/part stuff at that point .. :(

> mdadm --assemble /dev/md0 --force /dev/hd[abc]3

OK, I'll try it on the copy, and if that doesn't work on
the original data, since it isn't really an option to
send the originals for recovery ..

-- 
Jean Jordaan
http://www.upfrontsystems.co.za

