From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm command to trigger Raid Recovery?
Date: Tue, 22 Mar 2005 09:42:28 +1100
Message-ID: <16959.19924.527141.231264@cse.unsw.edu.au>
References: <Pine.GSO.4.44.0503191805340.792-100000@elaine24.Stanford.EDU>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
In-Reply-To: message from Junfeng Yang on Saturday March 19
Sender: linux-raid-owner@vger.kernel.org
To: Junfeng Yang <yjf@stanford.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday March 19, yjf@stanford.edu wrote:
> Hi,
> 
> What exactly is the command to recover a raid array after system crash? I
> created a raid5 array with 3 disks.  After system crash, one disk is out
> of sync, so I tried the command
> 
> mdadm --assemble --run --force --update=resync /dev/md2 /dev/sbd3  /dev/sbd4 /dev/sbd5
> 
> However, I still saw that raid array was started with 2 disks:
> mdadm: /dev/md/2 has been started with 2 drives (out of 3).
> 
> cat /proc/mdstat still shows that /dev/sbd5 is inactive.
> Personalities : [raid5]
> md2 : active raid5 sbd3[0] sbd4[1]
>       3968 blocks level 5, 64k chunk, algorithm 2 [3/2] [UU_]
> 
> If --update=resync isn't the right option to sync a raid array, what
> command am I supposed to use?

I think all you have to do at this point is add sbd5 back into the
array:
   mdadm /dev/md2 --add /dev/sbd5

NeilBrown
