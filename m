From: Neil Brown <neilb@suse.de>
Subject: Re: raid5.h documentation
Date: Thu, 20 Jul 2006 10:22:05 +1000
Message-ID: <17598.52397.290196.966427@cse.unsw.edu.au>
References: <5d96567b0607190208y2ad6f71fvb92eb5ac66ff9af9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Raz Ben-Jehuda(caro) on Wednesday July 19
Sender: linux-raid-owner@vger.kernel.org
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday July 19, raziebe@gmail.com wrote:
> Neil hello.
> 
> you say raid5.h:
> ...
>  * Whenever the delayed queue is empty and the device is not plugged, we
>  * move any strips from delayed to handle and clear the DELAYED flag
> and set   PREREAD_ACTIVE.
>  ...
> 
> i do not understand how can one move from delayed if delayed is empty .

It should say
  Whenever the 'handle' queue is empty.....

NeilBrown
