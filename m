From: CoolCold <coolthecold@gmail.com>
Subject: Re: Network-based RAID6
Date: Wed, 30 Mar 2011 11:20:41 +0400
Message-ID: <AANLkTimGK49-XtV9CsfL90bKpb=e9tRRos7fJ50WzNHd@mail.gmail.com>
References: <20110330131157.49fd2521@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110330131157.49fd2521@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Mar 30, 2011 at 11:11 AM, Roman Mamedov <rm@romanrm.ru> wrote:
> Hello,
>
> Let's say I have 10 machines, each having 1TB of free disk space. They
> communicate over a gigabit network.
>
> I would like to create a fault-tolerant array from these machines and their
> storage, that would match RAID6 in overhead and fault resilience.
> That is, it should provide 8 TB of usable space and tolerate a 2-member
> failure without data loss.
>
> Does anyone know if any of the current distributed filesystems will meet these
> requirements? Working/stable/non-experimental level code is preferred.
>
> The simple and obvious solution is mdadm over AoE/iSCSI, but maybe there is
> something else built with network awareness from ground up, that would be a
> better choice?
Looking on your host I think you speak russian, so may be this will be
somehow helpful for you
http://community.livejournal.com/ru_root/2216389.html

>
> --
> With respect,
> Roman
>



-- 
Best regards,
[COOLCOLD-RIPN]
