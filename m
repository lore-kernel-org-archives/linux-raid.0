From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: multi-hosting support for carrier grade Linux
Date: Tue, 05 Apr 2005 20:21:39 -0400
Message-ID: <42532B93.5010300@steeleye.com>
References: <20050405204155.GA32724@blade.az.mvista.com> <4253081F.6000901@steeleye.com> <4253206F.7020600@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4253206F.7020600@mvista.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Jiang <djiang@mvista.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dave Jiang wrote:
> Paul Clements wrote:
>> Dave Jiang wrote:

>  From my understanding of SCSI reservations ownership of the entire disk 
> claimed. If we have multiple host blades, it is possible that multiple 

SCSI 3 reservations can be used to lock an extent (e.g., a partition) of 
a disk (you can even do read only reservations, which lock out only 
writes). But yes, given your requirements, that may not be the easiest 
solution.


> Perhaps the UUID within the superblock could be built via a function 
> that could be abstracted or overloaded. The data within only needs to be 
> unique within its environment so it could contain geographical 
> addressing, target information or whatever fits. Perhaps this sounds a 
> bit less intrusive and requires little or perhaps no kernel changes?

Yes, the md driver doesn't care what the UUID is, so you can make it 
anything you want and then assemble the array. When you change 
initiators, you rewrite the UUID (you just have to make sure that the 
UUID is unique and that all UUIDs for disks in a given array are the 
same). The UUID is 128 bits long, so it should suffice for your purposes.

--
Paul
