From: David Greaves <david@dgreaves.com>
Subject: Re: Resize on dirty array?
Date: Wed, 09 Aug 2006 22:17:29 +0100
Message-ID: <44DA50E9.5040309@dgreaves.com>
References: <44D7DC93.2070905@net1plus.com> <17623.57067.835826.446152@cse.unsw.edu.au>  <44D8E535.9080208@net1plus.com> <17625.24594.568139.430440@cse.unsw.edu.au>  <44D9C6F5.7070501@net1plus.com> <68c491a60608090437l7e3b583el2214cbe6f01009ab@mail.gmail.com> <Pine.LNX.4.64.0608090846160.16324@coffee.psychology.mcmaster.ca> <44D9E41C.4050608@net1plus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44D9E41C.4050608@net1plus.com>
Sender: linux-raid-owner@vger.kernel.org
To: James Peverill <jamespev@net1plus.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

No, it wasn't *less* reliable than a single drive; you benefited as soon as a
James Peverill wrote:
> 
> In this case the raid WAS the backup... however it seems it turned out
> to be less reliable than the single disks it was supporting.  In the
> future I think I'll make sure my disks have varying ages so they don't
> fail all at once.
> 
be at the moment. With RAID you then stressed the remaining drives to the point
of a second failure (not that you had much choice - you *could* have spent money

> James
> 
>>> RAID is no excuse for backups.
on enough media to mirror your data whilst you played with your only remaining

I can't see where you mention the kernel version you're running? md can perform
validation sync's on a periodic basis in later kernels - Debian's mdadm enables
this in cron.

copy - that's a cost/risk tradeoff you chose not to make. I've made the same
choice in the past - I've been lucky - you were not - sorry.)

> PS: <ctrl><pgup>
> -
David

> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
drive failed. At that point you would have been just as toasted as you may well


PS
Reorganise lines from distributed reply as you like :)

-- 
