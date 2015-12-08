From: Phil Turmel <philip@turmel.org>
Subject: Re: Help Reassembling a raid5 array
Date: Mon, 7 Dec 2015 22:40:25 -0500
Message-ID: <56665129.6050404@turmel.org>
References: <CAJGWEk93QAmCdik4_rxGPcq7dm=2tXX1U19Zkn5OwcAog0Z-RA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJGWEk93QAmCdik4_rxGPcq7dm=2tXX1U19Zkn5OwcAog0Z-RA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Wilkins <andrew.m.wilkins@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Andrew,

On 12/07/2015 08:26 PM, Andrew Wilkins wrote:
> Hi, please can someone help me with a raid array which as gone wrong
> On Friday a backup server was rebooted, but failed to boot, possibly
> with an unrelated issue
> 
> 
> On Monday someone booted from a usb disk to try and recover it
> they were originally able to assemble the array but now they are not,
> 2 out of the 5 drives are showing out of date.
> Device 1 is showing
>   Bad Block Log : 512 entries available at offset 72 sectors
>   Array State : AAAAA
> and is showing 256 less a events
> last updated 2 hours before the others
> 
> Device 4 is showing
>  Array State : A.AAA
> and 2 less events
> last update 1 hour before the others
> 
> The rest all show
>  Array State : A.AA.
> 
> I've tried manually assembling without device 1, but even with --force
> it refused to assemble, force seems to do nothing at all, i am
> assuming this maybe because the array state has been updated to say
> missing for 2 devices.

> The example here
> https://raid.wiki.kernel.org/index.php/RAID_Recovery
> seems to suggest that in my situation recreating might be my only option

Possibly. Let's try all other options first.

> Are there any better options before i go ahead and do this?

At least one anomaly below.

> /dev/sdb1:

>      Array UUID : 7847e506:deaf87e5:7c6cd502:abb20cf1

> /dev/sdc1:

>      Array UUID : xxxxxxxx:xxxxxxxx:xxxxxxxx:abb20cf1

How did this happen ? ^^^^^^^^^^^^^^^^^^^^^^

> /dev/sdd1:

>      Array UUID : 7847e506:deaf87e5:7c6cd502:abb20cf1

> /dev/sde1:

>      Array UUID : 7847e506:deaf87e5:7c6cd502:abb20cf1

> /dev/sdf1:

>      Array UUID : 7847e506:deaf87e5:7c6cd502:abb20cf1

Try forcing re-assembly with sdb1, sdd1, sde1, and sdf1.

If that doesn't work with your current environment, try again with new
kernel and mdadm from booting a rescue environment.  I usually recommend
the LiveCD from sysrescuecd.org.

If that succeeds (in either case), add sdc1 and let it rebuild before
doing anything else.

Phil
