From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: does chunksize matter in raid-1?
Date: Sat, 06 Aug 2005 08:44:49 -0400
Message-ID: <42F4B0C1.1080306@steeleye.com>
References: <e03b90ae05080521077404ad09@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e03b90ae05080521077404ad09@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: jeff@jab.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jeff Breidenbach wrote:
> Does chunk size matter *at all* for RAID-1?
> 
> mdadm --create /dev/md0 --level=1 --chunk=8 /dev/sdc1 /dev/sdd1   
> mdadm --create /dev/md0 --level=1 --chunk=128 /dev/sdc1 /dev/sdd1
> 
> In my mental model of how RAID works, it can't possibly matter
> what my chunk size is whether I've got 1KB files or 1GB files because
> no striped reading occurs. 
> 
> Is my mental model wrong?


No, chunk size does not matter for raid1. In fact, some/most? kernels 
will print a message to that effect if you specify a chunk size for a 
raid1 array.

--
Paul
