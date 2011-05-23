From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: disable raid autodetect at boot
Date: Mon, 23 May 2011 17:21:21 +0400
Message-ID: <4DDA5F51.3090501@msgid.tls.msk.ru>
References: <BANLkTim=K8b_3jD5RAdMT6+0TYQXNAHBtg@mail.gmail.com>	<4DDA388C.2020000@msgid.tls.msk.ru> <BANLkTi=zLb7j_MvkTyQa=ifMAS+kDCkbvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=zLb7j_MvkTyQa=ifMAS+kDCkbvg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

23.05.2011 16:50, Alexander Lyakas wrote:
> Michael,
> can you pls explain what do I need to look at to disable this.

> On Mon, May 23, 2011 at 1:35 PM, Michael Tokarev <mjt@tls.msk.ru> wrote:

>> This is not kernel autodetection, this is your initramfs/initrd
>> and mdadm.  Or maybe mdadm in the regular root filesystem.

You need to find out where and how mdadm is called
on your system during bootup, and fix that place.

/mjt
