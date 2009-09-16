From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: Re: LVM and Raid5
Date: Wed, 16 Sep 2009 02:42:04 -0700 (PDT)
Message-ID: <531114.41651.qm@web51310.mail.re2.yahoo.com>
References: <f5d1f90a0909160122j32569fb8g9e2a212532ea8604@mail.gmail.com>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f5d1f90a0909160122j32569fb8g9e2a212532ea8604@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linuxraid.study@gmail.com
List-Id: linux-raid.ids




--- On Wed, 16/9/09, Linux Raid Study <linuxraid.study@gmail.com> wrote:

> From: Linux Raid Study <linuxraid.study@gmail.com>
> Subject: LVM and Raid5
> To: linux-raid@vger.kernel.org
> Cc: linuxraid.study@gmail.com
> Date: Wednesday, 16 September, 2009, 9:22 AM
> Hello:
> 
> Has someone experimented with LVM and Raid5 together (on
> say, 2.6.27)?
> Is there any performance drop if LVM/Raid5 are combined vs
> Raid5 alone?
> 
> Thanks for your inputs!
> --

Hi, I cant remember what exact kernel version i am running but I have certainly noticed a difference. I have had the raid array set up for nearly 2 years and have only in the last 6 months become bothered/interested in optimising it.

Someone suggested this: http://mbhtech.blogspot.com/2009/09/software-raid-vs-lvm-quick-speed-test_08.html

My test concur with these results; I feel I would - in hindsight have not bothered with the LVM. BUT it does give me a flexability I would probably miss otherwise.

I have not looked at optimising stripe sizes though - or any other optimisation really. 

-----------------------
N: Jon Hardcastle
E: Jon@eHardcastle.com
'Do not worry about tomorrow, for tomorrow will bring worries of its own.'
-----------------------


      
