From: Tim Moore <linux-raid@nsr500.net>
Subject: Re: Raid5 Construction Question
Date: Thu, 19 Aug 2004 11:32:32 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4124F240.20606@nsr500.net>
References: <4124E24E.7070802@psc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4124E24E.7070802@psc.edu>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My raid tab has 'chunk-size 64' and I get 64k chunks.  Does 'chunk-size 
64k' mean 64M chunks?

Did you set stride correctly when running mke2fs (based on 
chunk_size/fs_block_size)?

Either one of these could trash performance.

rgds,
tim

PAulN wrote:
> Hi,
> So I have a raid 5 which is around ~1TB and the problem I've been having 
> is that
> the resync rate is really bad.  This is understandable given that the 
> raid5 has not
> been initialized.  Does anyone know a way for me to initialize my raid5 
> before I use it so
> that the resync process doesn't run for 3 days?
> thanks
> paul
> 
> 
> Config:
> -------------------------------------------------
> raiddev             /dev/md0
> raid-level                  5
> nr-raid-disks               7
> nr-spare-disks              1
> chunk-size                  64k
> persistent-superblock       1
> parity-algorithm        left-symmetric
>    device          /dev/sda1
>    raid-disk     0
>    device          /dev/sdb1
>    raid-disk     1
>    device          /dev/sdc1
>    raid-disk     2
>    device          /dev/sdd1
>    raid-disk     3
>    device          /dev/sde1
>    raid-disk     4
>    device          /dev/sdg1
>    raid-disk     5
>    device          /dev/sdf1
>    raid-disk    6
>    device          /dev/sdh1
>    spare-disk     0
> ----------------------------------------
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
  | for direct mail add "private_" in front of user name
