From: Anders Fugmann <afu@fugmann.dhs.org>
Subject: Re: Upgrading Raid1 array to have 2. disks.
Date: Thu, 08 May 2003 21:11:21 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EBAABD9.3080802@fugmann.dhs.org>
References: <3EB8441F.8070606@fugmann.dhs.org> <16056.19633.400369.451156@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16056.19633.400369.451156@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> You cannot add a new data drive to a raid1 array.
> If you shut down the array and re-create it you should not loose data.
> The correct command to use would be something like:
>   mdadm --create /dev/md0 --level=1 -n 2 /dev/ide/host0/bus0/target0/lun0/part1 missing
> 
> Note the word "missing" at the end.  This tells mdadm to create a
> 2-drive array with one missing drive (and so only one active drive).
> This will have the same data as the old md0.
> Now "mdadm --add" should do what you want.

Thanks for the replies.
The method above worked like a charm. The data on the array even surived 
the operation.

> 
> NeilBrown

Regards
Anders Fugmann

