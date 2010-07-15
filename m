From: "Ceuleers, Jan (Jan)" <jan.ceuleers@alcatel-lucent.com>
Subject: RE: Need help with recovery
Date: Thu, 15 Jul 2010 11:50:56 +0200
Message-ID: <BCD693DB5C9A3349A6F7694398FA08E21D46103209@FRMRSSXCHMBSD2.dc-m.alcatel-lucent.com>
References: <4C3DCB95.9010104@computer.org>
 <20100715073729.06c4f11a@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100715073729.06c4f11a@notabene>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil,

> mdadm -A /dev/md2 --force /dev/sd[ade]2

Many thanks for your feedback. I will try this when I get home.

So if I boil this down to the principles, your advice is to assemble the array in degraded mode using the components that have the most recent update timestamps. Degraded, because this prevents resynchronisation.

Thanks, Jan

