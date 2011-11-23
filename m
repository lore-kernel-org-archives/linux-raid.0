From: Phil Turmel <philip@turmel.org>
Subject: Re: md metadata nightmare
Date: Tue, 22 Nov 2011 22:50:52 -0500
Message-ID: <4ECC6D9C.8050009@turmel.org>
References: <CADzwnhXWvkVC13ZEJj8L0O6PLXLS6uhoBXqoLp67YwmeU60sQQ@mail.gmail.com> <20111123114743.1085889e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111123114743.1085889e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Kenneth Emerson <kenneth.emerson@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Ken,

On 11/22/2011 07:47 PM, NeilBrown wrote:
> On Tue, 22 Nov 2011 18:05:21 -0600 Kenneth Emerson
[...]
> Assuming nothing has changed since the "--detail" output you provided, you
> should:
> 
>  mdadm -S /dev/md3
>  mdadm -C /dev/md3 --metadata=1.0 --chunk=64k --level=6 --raid-devices=5 \
>       missing /dev/sdb4 /dev/sdc4 /dev/sda4 /dev/sdd4 \
>       --assume-clean
> 
> The order of the disks is import.  You should compare it with the output
> of "mdadm --detail" before you start to ensure that it is correct and I have
> made any typos.  You should of course check the rest as well.
> After doing this (and possibly before) you should 'fsck' to ensure the
> transition was successful.  If anything goes wrong, ask before risking
> further breakage.

A word of warning...  the shell notation /dev/sd[bcad]4, which you might be
tempted to type in the above command line, *will* *not* *work*.  Bash reorders
the [bcad] to [abcd], dropping nonexistent names.  You might know this, and
not be burned, but others on the list have been.  Use {b,c,a,d} to stay safe.

HTH,

Phil
