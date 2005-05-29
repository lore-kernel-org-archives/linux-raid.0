From: "Gordon Mohr (@ Bitzi)" <gojomo@bitzi.com>
Subject: Re: raid1 w/ 3 active mirrors?
Date: Sun, 29 May 2005 14:03:13 -0700
Message-ID: <429A2E11.2070002@bitzi.com>
References: <429A13BC.2090809@bitzi.com> <429A1DF8.6050409@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <429A1DF8.6050409@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev wrote:
> Gordon Mohr (@ Bitzi) wrote:
> 
>> I may have missed this is various docs, but is there any way to make
>> a raid1 array which has 3 (or more) active mirrors, rather than 2 mirrors
>> and spares?
> 
> 
> On our machines with software raid, I usually use all available disks to
> create (small) root filesystem on raid1 - which is 2, 3, 4, 5, or even 8
> on one machine.  There's no special restriction on number of mirrors in
> a raid1 set.  You create raid1 array on top of N disks exactly the same
> as you create it on 2 disks.

How do you make all the disks active mirrors? When I add a third partition
to an functioning RAID1 array (mdadm -a), it always enters as a 'spare'. Only
after another disk fails out will it be brought into sync with the remaining
active partition.

(I'd like the third partition to be brought into sync, and kept in sync,
with the other two immediately, so that a fail does not trigger any
flurry of activity.)

Thanks,

- Gordon @ Bitzi
