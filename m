From: dean gaudet <dean@arctic.org>
Subject: Re: Still can't get md arrays that were started from an initrd to
 shutdown
Date: Mon, 17 Jul 2006 19:44:16 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0607171942271.2393@twinlark.arctic.org>
References: <bb145bd20607171355x8143b0eofb0017637d749263@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bb145bd20607171355x8143b0eofb0017637d749263@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Christian Pernegger <pernegger@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 17 Jul 2006, Christian Pernegger wrote:

> The problem seems to affect only arrays that are started via an
> initrd, even if they do not have the root filesystem on them.
> That's all arrays if they're either managed by EVMS or the
> ramdisk-creator is initramfs-tools. For yaird-generated initrds only
> the array with root on it is affected.

with lvm you have to stop lvm before you can stop the arrays... i wouldn't 
be surprised if evms has the same issue... of course this *should* happen 
cleanly on shutdown assuming evms is also being shutdown... but maybe that 
gives you something to look for.

-dean
