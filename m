From: "Justin Stephenson" <justin@evensteveninc.com>
Subject: Re[2]: Issue removing failed drive and re adding on raid 6
Date: Fri, 03 Jul 2015 22:20:09 +0000
Message-ID: <emedabf90f-c9d1-46af-80f9-b33e9d25677d@littlez>
References: <alpine.DEB.2.02.1507032246050.11810@uplift.swm.pp.se>
Reply-To: "Justin Stephenson" <justin@evensteveninc.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1507032246050.11810@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



>On Fri, 3 Jul 2015, Justin Stephenson wrote:
>
>>          State : active, degraded, Not Started
>
>What does "cat /proc/mdstat" say? It looks like the array isn't up and 
>running, in that case you have to assemble it and get it up and running 
>before you can --add the new drive.
>
>-- Mikael Abrahamsson email: swmike@swm.pp.se

mdstat says the array is inactive. after a reboot, it also reports sdf1 
as sdf1[8](S).

I have tried assembling with --scan --force and by naming the drives 
sd{b,c,d,e,f,g,h}1 Neither method has worked.

- Justin


