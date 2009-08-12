From: "John Robinson" <john.robinson@anonymous.org.uk>
Subject: Re: max number of devices in raid6 array
Date: Wed, 12 Aug 2009 10:38:40 +0100 (BST)
Message-ID: <55226.78.86.108.203.1250069920.squirrel@www.yuiop.co.uk>
References: <20090812090600.GF21118@nfs-rbx.ovh.net>
Mime-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090812090600.GF21118@nfs-rbx.ovh.net>
Sender: linux-raid-owner@vger.kernel.org
To: David Cure <lnk@cure.nom.fr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 12 August, 2009 10:06 am, David Cure wrote:
> 	I want to create an raid6 array and I see an limit of number of
> devices : with 27 devices the array is created, and with 28 I've got
> this error :
> mdadm: invalid number of raid devices: 28
>
> 	I use kernel 2.6.30 (from backport) and mdadm - v2.6.7.2 - 14th
> November 2008 on Debian Lenny.
>
> 	Is there a way to pass out this limit ?

The limit is only with version 0.90 metadata, which is the default. I'd
recommend you do a bit of reading to pick metadata version 1.0, 1.1 or
1.2, according to any requirements you may have, then tell mdadm what your
choice is with --metadata= while creating your array.

Cheers,

John.

