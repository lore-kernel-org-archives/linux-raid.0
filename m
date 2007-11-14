From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Proposal: non-striping RAID4
Date: Wed, 14 Nov 2007 18:16:14 -0500
Message-ID: <473B81BE.8070309@tmr.com>
References: <ef2613f30711091657q48e57b63if47a3653a92b28a6@mail.gmail.com>	 <4737AC62.8000308@tmr.com>	 <ef2613f30711131548l2ecacd3p9994fdc6ebb6042a@mail.gmail.com> <ef2613f30711131706g31b7b7adm61add82fef3ff94a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ef2613f30711131706g31b7b7adm61add82fef3ff94a@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: James Lee <james.lee@cantab.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

James Lee wrote:
> >From a quick search through this mailing list, it looks like I can
> answer my own question regarding RAID1 --> RAID5 conversion.  Instead
> of creating a RAID1 array for the partitions on the two biggest
> drives, it should just create a 2-drive RAID5 (which is identical, but
> can be expanded as with any other RAID5 array).
>
> So it looks like this should work I guess.

I believe what you want to create might be a three drive raid-5 with one 
failed drive. That way you can just add a drive when you want.

  mdadm -C -c32 -l5 -n3 -amd /dev/md7 /dev/loop[12] missing

Then you can add another drive:

  mdadm --add /dev/md7 /dev/loop3

The output are at the end of this message.

But in general think it would be really great to be able to have a 
format which would do raid-5 or raid-6 over all the available parts of 
multiple drives, and since there's some similar logic for raid-10 over a 
selection of drives it is clearly possible. But in terms of the benefit 
to be gained, unless it fails out of the code and someone feels the 
desire to do it, I can't see much joy to ever having such a thing.

The feature I would really like to have is raid5e, distributed spare so 
head motion is spread over all drives. Don't have time to look at that 
one, either, but it really helps performance under load with small arrays.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

