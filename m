From: Phil Turmel <philip@turmel.org>
Subject: Re: start dm-multipath before mdadm raid
Date: Fri, 11 Dec 2015 11:08:08 -0500
Message-ID: <566AF4E8.5030801@turmel.org>
References: <CABdHLQ6Lo8WvgSf=MAuYdVoJJMHmLuV5gkE+N4MDMfxvAbG5OA@mail.gmail.com>
 <5669AE9C.7040904@turmel.org>
 <CABdHLQ4rh+Rtu6U+ZX6m0CWXu3sW4boEzHaPdxD03UBf82EJcQ@mail.gmail.com>
 <566AD7EA.4070903@turmel.org>
 <CABdHLQ7Wdg1sUdC-Ryamdy+et6SNJRJnfdnRXSPOrWJYX9sT_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABdHLQ7Wdg1sUdC-Ryamdy+et6SNJRJnfdnRXSPOrWJYX9sT_g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "P. Remek" <p.remek1@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

{Convention on kernel.org is to trim and either interleave the reply or
bottom post.  Please do.}

On 12/11/2015 11:01 AM, P. Remek wrote:
> Here is my config:

> root@os-node1:~# cat /etc/mdadm/mdadm.conf
> 
> DEVICE /dev/mapper/hgst-ssd*
> CREATE owner=root group=disk mode=0660 auto=yes
> HOMEHOST <system>
> MAILADDR root
> ARRAY /dev/md0 metadata=0.90 UUID=4472a74f:ca206897:3b82bcad:daeae9f9

It's likely that the udev rules that drive incremental assembly don't
have the mapper aliases at the moment they run.  Try:

DEVICE /dev/dm*

Phil

