From: Ram Ramesh <rramesh2400@gmail.com>
Subject: Re: How to delay mdadm assembly until all component drives are
 recognized/ready?
Date: Mon, 15 May 2017 23:15:54 -0500
Message-ID: <70e1010d-111b-7d61-0df8-6a4b1b5c8ec6@gmail.com>
References: <243ef080-c32f-f423-3a98-af70194f994b@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <243ef080-c32f-f423-3a98-af70194f994b@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/09/2017 10:13 PM, Ram Ramesh wrote:
> Today, I noticed that my RAID6 md0 was assembled in degraded state 
> with two drives in failed state after a pm-suspend and restart. Both 
> of these drives were attached toSAS9211-8I controller. The other 
> drives are attached to motherboard. I have not had this on a normal 
> boot/reboot. Also, in this particular case, mythtv recording was going 
> on when suspended and therefore as soon as resumed that used this md0.
>
> Upon inspection, it appears (I am not sure here) that mdadm assembled 
> the array even before the drives were ready to be used. All I had to 
> do was to remove and re-add them to bring the array back to "good" 
> state. I am wondering if there is a way to tell mdadm to wait for all 
> drives to be ready before assembling. Also, if there is something that 
> I can add to resume scripts that will help, please let me know.
>
> Kernel: Linux zym 3.13.0-106-generic #153-Ubuntu SMP
> mdadm - v3.2.5 - 18th May 2012
>
> Failed drives are HGST NAS and WD Gold with less than a year of usage. 
> So I doubt they are bad drives by any means.
>
> Ramesh
>
>
This happened again. I think no damage is done until I write to the 
device. Once the write fails, it marks the component disk "failed" If I 
can make it wait a shortwhile before writing happens, I think I should 
be ok. Is there something possible with any of the thaw scripts that 
will delay start of resume operation.

Ramesh

