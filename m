From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: /sys/block/md126 still exists even after stopping the array
Date: Fri, 10 Oct 2014 21:34:18 +0200
Message-ID: <543834BA.3040400@gmail.com>
References: <53A99B76.3020603@gmail.com>	<20140625110348.48ab2d7a@notabene.brown>	<54243ED7.6090904@gmail.com>	<20140926103348.5f5ea568@notabene.brown>	<54253E9F.4070505@gmail.com>	<20140926204445.1ec830b9@notabene.brown>	<54255A30.9010406@gmail.com>	<20140929143735.5fa54253@notabene.brown>	<54291C1D.7010005@gmail.com>	<20140930075643.34e864fa@notabene.brown>	<542A5F15.7030100@gmail.com>	<543390C7.2080104@gmail.com>	<20141008105425.64cd0fed@notabene.brown>	<54365809.90406@gmail.com> <20141009205509.1da5dbd9@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141009205509.1da5dbd9@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello Neil,

On 10/09/2014 11:55 AM, NeilBrown wrote:
> On Thu, 09 Oct 2014 11:40:25 +0200 Francis Moreau <francis.moro@gmail.com>
> wrote:
> 
[...]

>>
>> Yes, but reading sysfs is also racy. I was thinking that the advantage
>> of using udev is that it gives me a *consistent* (perhaps outdated)
>> snapshot of the device state.
>>
> 
> In what sense do you think sysfs is racy?  What exactly do you want to do
> with the udev event?
> 
> The event from the kernel to udev only contains the identity of the device
> and the type of event (add,change,remove).
> 
> Some drivers add extra 'environment' information.
>  - 'dm' adds a 'cookie'.
>  - bcache add a 'CACHED_UUID' and 'CACHED_LABEL'
>  - libata-acpi adds a 'BAY_EVENT'
> 
> but in general there is nothing extra.
> 
> If udev adds stuff (which is probably does), it is just as racy as anything
> that you might determine and add yourself.
> 

I was wrongly assuming that if I queried the udev DB through its library
it would have returned a consistent image of the state of the device
meaning that each property of the device would be coherent with the others.

But even if that was possible, it would be pointless since all accesses
to the device could still fail.

Thanks for enlighting me :)
