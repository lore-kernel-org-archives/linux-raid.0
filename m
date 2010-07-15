From: Neil Brown <neilb@suse.de>
Subject: Re: Need help with recovery
Date: Thu, 15 Jul 2010 23:40:58 +1000
Message-ID: <20100715234058.0f580546@nbeee.brown>
References: <4C3DCB95.9010104@computer.org>
	<20100715073729.06c4f11a@notabene>
	<BCD693DB5C9A3349A6F7694398FA08E21D46103209@FRMRSSXCHMBSD2.dc-m.alcatel-lucent.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BCD693DB5C9A3349A6F7694398FA08E21D46103209@FRMRSSXCHMBSD2.dc-m.alcatel-lucent.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Ceuleers, Jan (Jan)" <jan.ceuleers@alcatel-lucent.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 15 Jul 2010 11:50:56 +0200
"Ceuleers, Jan (Jan)" <jan.ceuleers@alcatel-lucent.com> wrote:

> Neil,
> 
> > mdadm -A /dev/md2 --force /dev/sd[ade]2
> 
> Many thanks for your feedback. I will try this when I get home.
> 
> So if I boil this down to the principles, your advice is to assemble
> the array in degraded mode using the components that have the most
> recent update timestamps. Degraded, because this prevents
> resynchronisation.
>
It is more a case of "degraded because that uses fewer devices, and
so fewer old devices which could introduce errors."  though avoiding
resync is a good thing too.

The key bit is "--force" which tell mdadm to assemble it anyway
even if something looks out of data.  mdadm will only include just
enough devices to make the array work.
You don't really need to be selective about the devices you
choose. If you give "mdadm -Af" all of the devices, it will just
pick the ones that are best.  I just listed them for you to
make it more clear what was happening.

NeilBrown
