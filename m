From: Luca Berra <bluca@comedia.it>
Subject: Re: SuSE Linux cluster using MC/ServiceGuard --- shared storage
Date: Mon, 20 Sep 2004 15:55:51 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040920135549.GA8201@percy.comedia.it>
References: <20040920132846.29970.qmail@web61108.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040920132846.29970.qmail@web61108.mail.yahoo.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Sep 20, 2004 at 06:28:46AM -0700, Biju A wrote:
>Hi,
>
>In a Linux cluster setup, I have some issues.
>
>I am trying to use 'md' driver in Linux for multipath
>to shared storage with Enterprise Virtual Array 3000
>(EVA 3000)

i believe someone from HP already stated in this list that md driver
(multipath) does not work with EVA, i guess do to issues with
preferred path.

>Do I still need to use the Driver Patch for EVA
>Controller Failover? 
i believe using the qlogic driver failover is a viable solutio, another
is purchasing securepath from HP. but i believe there were issues using
securepath and lvm together.

>The MC/SG spec says that 'md' driver should not be
>active at the same time on both the cluster nodes. So,
>I am not using the 'fd' type of partition which starts
>the arrays at boot time. I just use the default 83
>type.
>
>Is there any specific need to update to 2.6 kernel in
>order to support LVM 2?

i don't know if that is supported by either hp or suse.

>The kernel version of the O/S in the cluster nodes is
>2.4.19 which contains lvm 1.0.5-51. It does not
>support 'pvremove' and probably the tool 'mkraid' does
>have some bugs. No idea if there are fixes for the
>same. Is it better to use 'mdadm'? 

i do personallu prefer mdadm to mkraid.

>Any hints/suggestions would be appreciated.
also try asking in the hp itrc forums.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
