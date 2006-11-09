From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [PATCH 001 of 6] md: Send online/offline uevents when an md array
 starts/stops.
Date: Thu, 09 Nov 2006 13:17:54 +0300
Message-ID: <45530052.4010406@tls.msk.ru>
References: <20061031164814.4884.patches@notabene>	<1061031060046.5034@suse.de>	<20061031211615.GC21597@suse.de>	<3ae72650611020413q797cf62co66f76b058a57104b@mail.gmail.com>	<17737.58737.398441.111674@cse.unsw.edu.au>	<1162475516.7210.32.camel@pim.off.vrfy.org>	<17738.59486.140951.821033@cse.unsw.edu.au>	<1162542178.14310.26.camel@pim.off.vrfy.org>	<17742.32612.870346.954568@cse.unsw.edu.au>	<Pine.LNX.4.64.0611060030320.20361@twinlark.arctic.org> <17744.5139.805134.577609@cse.unsw.edu.au> <4552FE94.20400@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4552FE94.20400@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Neil Brown <neilb@suse.de>, dean gaudet <dean@arctic.org>, Kay Sievers <kay.sievers@vrfy.org>, Greg KH <gregkh@suse.de>, Andrew Morton <akpm@osdl.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev wrote:
> Neil Brown wrote:
> [/dev/mdx...]
[]
>> An in any case, we have the semantic that opening an md device-file
>> creates the device, and we cannot get rid of that semantic without a
>> lot of warning and a lot of pain.  And adding a new semantic isn't
>> really going to help.
> 
> I don't think so.  With new semantic in place, we've two options (provided
> current semantics stays, and I don't see a strong reason why it should be
> removed except of the bloat):
> 
>  a) with new mdadm utilizing new semantics, there's nothing to change in udev --
>     it will all Just Work, by mdadm opening /dev/md-control-node (how it's called)
>     and assembling devices using that, and during assemble, udev will receive proper
>     events about new "disks" appearing and will handle that as usual.
> 
>  b) without new mdadm, it will work as before (now).  And in this case, let's not
>     send any udev events, as mdadm already created the nodes etc.

Forgot to add.  This is important point: do NOT change current behavour wrt uevents,
ie, don't add uevents for current semantics at all.  Only send uevents (and in this
case it will be normal "add" and "remove" events) when assembling arrays "the new way",
using (stable!) /dev/mdcontrol misc device, after RUN_ARRAY and STOP_ARRAY actions has
been performed.

/mjt

> So if a user wants neat and nice md/udev integration, the way to go is case "a".
> If it's not required, either case will do.

