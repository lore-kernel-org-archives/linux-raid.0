From: Martin Wilck <mwilck@arcor.de>
Subject: Re: mdadm 3.3 fails to kick out non fresh disk
Date: Mon, 16 Sep 2013 19:04:25 +0200
Message-ID: <52373A19.7000105@arcor.de>
References: <CAC9WiBgGgKGHqcwrVo7J_peS8YiH-KBF8T1uGbwJrve_7aa3cw@mail.gmail.com>	<20130914064305.0baadc69@notabene.brown>	<CAC9WiBhbyV6Xpu=7HvKUK1hXNw1uC+QZcDOM0R9zUCMrR7WNtQ@mail.gmail.com>	<20130914203800.385466b2@notabene.brown>	<CAC9WiBh9EOFKx99fTH2yYN62A5CAg4_mqpNtxj6jZOZE+_Raww@mail.gmail.com>	<CAC9WiBja2N_Q8h6MSci+fgRWWpvvRpcMZp8FOZX3V_FK8pjhpA@mail.gmail.com>	<5234CA6A.3070305@arcor.de> <CAC9WiBi8XyWS8AgjAE0cxiaa4uRbNS69=vfC+TKnoG_iFp2+Vg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBi8XyWS8AgjAE0cxiaa4uRbNS69=vfC+TKnoG_iFp2+Vg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/16/2013 03:56 PM, Francis Moreau wrote:

> I did give your patch "DDF: compare_super_ddf: fix sequence number
> check" a try and now mdadm is able to detect a difference between the
> 2 disks. Therefore it refuses to insert the second disk which is
> better.
> 
> However it's still not able to detect which version is the "fresher"
> like mdadm does with soft RAID1 (metadata 1.2). Therefore mdadm is not
> able to kick out the first disk if it's the outdated one.
> 
> Is that expected ?

At the moment, yes. This needs work.

Martin
