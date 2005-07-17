From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Recovery raid5 after sata cable failure.
Date: Mon, 18 Jul 2005 08:10:34 +1000
Message-ID: <17114.55130.211770.531178@cse.unsw.edu.au>
References: <42da427a.2e075618.7fea.2c30@mx.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Francisco Zafra on Sunday July 17
Sender: linux-raid-owner@vger.kernel.org
To: Francisco Zafra <fzafra@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday July 17, fzafra@gmail.com wrote:
> Hi all,
>  
>     I have raid5 array working without problem for some months. A SATA cable
> failed and de raid5 works fine keeping the superblock persistent, but now, I
> can't get the old device inserted into the array.
...
> 
> 	And I try to re-add the old disk in this way:
> 
> root@Torero-2:/mnt/raid5 # mdadm /dev/md0 -a /dev/sdh1   
> mdadm: Cannot open /dev/sdh1: Device or resource busy
> 
> 	What is wrong? What I am doing bad? Sdh1 is absolutely unused, so I
> don't understand the error "resource busy"

Well, it definitely is busy...

Maybe it is still part of md0, but marked as 'faulty'.
If so (cat /proc/mdstat would tell you) you need to remove it first.
  mdadm /dev/md0 -r /dev/sdh1
  mdadm /dev/md0 -a /dev/sdh1

NeilBrown
