From: Martin Wilck <mwilck@arcor.de>
Subject: Re: mdadm 3.3 fails to kick out non fresh disk
Date: Tue, 24 Sep 2013 19:38:47 +0200
Message-ID: <5241CE27.30203@arcor.de>
References: <CAC9WiBgGgKGHqcwrVo7J_peS8YiH-KBF8T1uGbwJrve_7aa3cw@mail.gmail.com>	<20130914064305.0baadc69@notabene.brown>	<CAC9WiBhbyV6Xpu=7HvKUK1hXNw1uC+QZcDOM0R9zUCMrR7WNtQ@mail.gmail.com>	<20130914203800.385466b2@notabene.brown>	<CAC9WiBh9EOFKx99fTH2yYN62A5CAg4_mqpNtxj6jZOZE+_Raww@mail.gmail.com>	<CAC9WiBja2N_Q8h6MSci+fgRWWpvvRpcMZp8FOZX3V_FK8pjhpA@mail.gmail.com>	<5234CA6A.3070305@arcor.de>	<CAC9WiBi8XyWS8AgjAE0cxiaa4uRbNS69=vfC+TKnoG_iFp2+Vg@mail.gmail.com>	<52373A19.7000105@arcor.de>	<CAC9WiBjnM5nwKf4f7UN6hQgsbYhVLLPnfAD6RATbF3C-NHRrXg@mail.gmail.com>	<523C8EF9.60809@arcor.de>	<CAC9WiBgnWHupc59z+ym2me3RcL4F6YqdE_3aXTvRN2zZZQ4jzQ@mail.gmail.com> <CAC9WiBgzfvQkLZXT+9WYuxBUCRJqWZAvbyVmK9-9EsiwNeRxhw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBgzfvQkLZXT+9WYuxBUCRJqWZAvbyVmK9-9EsiwNeRxhw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Francis,

> Could you show me the mdadm command I should use to insert sdb into the array ?

I tried your scenario on HW with LSI fake RAID and encountered the same
problem you had. I have come up with a patch that I've just posted ("Fix
mdadm --add for LSI fake RAID" and follow-ups).

Please try if this patch fixes your problem. To be precise, with this
patch applied, mdadm /dev/md127 --add /dev/sdX should work again. You
should be able to run this on your currently broken system if you
somehow manage to transfer the updated mdadm and mdmon executables to
that system, run mdmon --takeover /dev/md127, and then remove/add sdX again.

The reason for the problem was a difference in the interpretation of the
workspace_lba field in the DDF header between my code and LSI's.

This has nothing to do with my previous patch "compare_super_ddf: fix
sequence number check".

Regards
Martin

