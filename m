From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: mdadm and kernel versions - what is safe and what is desirable?
Date: Sun, 02 May 2010 19:22:31 -0400
Message-ID: <4BDE0937.5040105@tmr.com>
References: <4BDDB7B1.2070505@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BDDB7B1.2070505@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Maurice Hilarius <mhilarius@gmail.com>
Cc: vger majordomo for lists <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Maurice Hilarius wrote:
> I wonder which kernel version number is "needed" to prepare and run a 
> well behaved mdadm RAID?
>
> Reason I ask:
> I am setting up a pair of Intel SS4200-EHW NAS boxes  with OpenFiler 2.3
> I am planning to set up RAID5 on one and RAID10 on the other one.
> Openfiler installs kernel 2.6.26-8
>
>
> I see from reading here that apparently a number of bugs and issues 
> have been resolved with later kernels
>
>
>
> What would YOU do?

Raid-5 should be stable, 2.6.27 runs raid-10 fine (this VM runs on a 
2.6.27 host). I think that kernel should work as long as you use it as 
intended.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

