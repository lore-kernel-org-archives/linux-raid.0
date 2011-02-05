From: NeilBrown <neilb@suse.de>
Subject: Re: compile (newbie)
Date: Sat, 5 Feb 2011 17:02:26 +1100
Message-ID: <20110205170226.675850ae@notabene.brown>
References: <AANLkTinHswHzC5cE5cH3YtS1XMcL2FRY-Jt_Nvvq04wd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinHswHzC5cE5cH3YtS1XMcL2FRY-Jt_Nvvq04wd@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, 5 Feb 2011 02:12:37 -0200 Roberto Spadim <roberto@spadim.com.br>
wrote:

> hi, how could i compile raid1.c?
> 
> i have kernel headers, kernel source, kernel binary
> all my md (raid1,raid5,raid0,all md options on make menuconfig) are modules
> 
> could i just goto md directory and
> gcc raid1.c
> ?
> 

 From the top level in the kernel tree run

  make drivers/md/raid1.o
 
 or
  make drivers/md/raid1.ko

 to get a kernel module that you can load (if you are running a compatible
 kernel).

NeilBrown
