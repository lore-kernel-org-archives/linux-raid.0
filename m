From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: One more question about the linux md driver
Date: Thu, 10 Apr 2003 12:04:08 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E9595F8.AC72CC1F@SteelEye.com>
References: <200304101446.h3AEklj30240@oboe.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: ptb@it.uc3m.es
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Peter,


"Peter T. Breuer" wrote:

> Can someone tell me about the difference between (when they are called)
> 
>     bind_rdev_to_array
>     unbind_rdev_from_array
> 
> and
> 
>    import_rdev
     ^^^^^^^^^^^

md_import_device (I take it?)


>    export_rdev
> 
> ?? I want to detect when a device is first inducted into an (any) array
> and when it is expelled (from the last array in which it figures). I am
> currently using the first two functions, and counting. I suspect I
> should be using the second two?

Well, I guess it depends what you're trying to do... :)

The import/export occurs earlier (and later, respectively) than the
bind/unbind, so I'm guessing that you want to use the import/export.

It also depends on what level of granularity you need. The rdevs, being
array components, could be partitions or whole devices. I'm guessing you
want to reference count whole devices, since a given partition cannot
belong to more than one md device (although several partitions on the
same device could belong to an md device, or several md devices)? To
figure out the mapping between partitions and devices, I think you want
to use dev_unit() (which basically masks out the minor number from a
kdev_t, leaving the major number).


--
Paul
