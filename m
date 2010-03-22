From: Neil Brown <neilb@suse.de>
Subject: Re: Problem converting from raid5 to raid6
Date: Mon, 22 Mar 2010 17:20:06 +1100
Message-ID: <20100322172006.7c737091@notabene.brown>
References: <20100321030107.GA18586@csy.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100321030107.GA18586@csy.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Shane W <shane-kernel@csy.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 20 Mar 2010 20:01:07 -0700
Shane W <shane-kernel@csy.ca> wrote:

> Hello all,
> 
> I am trying to convert a 5 disk raid5 array to a 6 disk
> raid6 but am having no luck. I first added the 6th disk as
> a spare then
> mdadm --grow /dev/md3 --level 6
> mdadm level of /dev/md3 changed to raid6
> mdadm: /dev/md3: Something wrong - reshape aborted
> mdadm: aborting level change
> 
> dmesg doesn't show an error and neither does mdadm beyond
> "something wrong". Is this supported?
> 
> mdadm 3.1.1 Linux 2.6.32.8 x86_64.
>


That shouldn't happen.... How big is your array?  How many devices?
Chunksize? etc.

Maybe just the output of
  mdadm -D /dev/md3

would do.

NeilBrown
