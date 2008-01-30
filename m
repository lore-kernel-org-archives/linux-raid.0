From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: Help, big error, dd first GB of a raid:-/
Date: Wed, 30 Jan 2008 13:11:23 +0100
Message-ID: <47A0696B.4030301@rabbit.us>
References: <47A054D4.9030308@cgv.tugraz.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47A054D4.9030308@cgv.tugraz.at>
Sender: linux-raid-owner@vger.kernel.org
To: Lars Schimmer <l.schimmer@cgv.tugraz.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Lars Schimmer wrote:
> 
> Hi!
> 
> Due to a very bad idea/error, I zeroed my first GB of /dev/md0.
> Now fdisk doesn't find any disk on /dev/md0.
> Any idea on how to recover?
> 

It largely depends on what is /dev/md0, and what was on /dev/md0. Provide very 
detailed info:

* Was the MD device partitioned?
* What filesystem(s) were residing on the array, what sizes, what order
* What was each filesystem used for (mounted as what)

Someone might be able to help at this point, however if you do not have a 
backup - you are in very very deep trouble already.
