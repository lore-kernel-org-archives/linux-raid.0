From: Phil Turmel <philip@turmel.org>
Subject: Re: start dm-multipath before mdadm raid
Date: Fri, 11 Dec 2015 09:04:26 -0500
Message-ID: <566AD7EA.4070903@turmel.org>
References: <CABdHLQ6Lo8WvgSf=MAuYdVoJJMHmLuV5gkE+N4MDMfxvAbG5OA@mail.gmail.com>
 <5669AE9C.7040904@turmel.org>
 <CABdHLQ4rh+Rtu6U+ZX6m0CWXu3sW4boEzHaPdxD03UBf82EJcQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABdHLQ4rh+Rtu6U+ZX6m0CWXu3sW4boEzHaPdxD03UBf82EJcQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "P. Remek" <p.remek1@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/10/2015 05:44 PM, P. Remek wrote:
>>
>> Order of device discovery is not guaranteed, but base devices will
>> almost always show up before multipath devices.  You have to filter out
>> the base devices from mdadm consideration:
>>
>> Add a DEVICES statement to your mdadm.conf that only matches your
>> multipath device names, not the base names.  Then update your initramfs
>> so it applies to early boot as well.
>>
> 
> 
> This is something which I actually already tried. I specified in my
> /etc/mdadm/mdadm.conf following:
> 
> DEVICE /dev/mapper/hgst-ssd*
> 
> In my /etc/multipath.conf I instruct dm-multipath to create
> /dev/mapper/hgst-ssd1 /dev/mapper/hgst-ssd2 /dev/mapper/hgst-ssd3

You haven't said that you've updated your initramfs with this info.

> But the only result is that after this config, the md raid is not
> started at all. My conclusion was that when md raid was starting, the
> multipath devices did not yet exist so it did not start up the array.

That would be an initramfs bug, most likely.  Modern initramfs like
dracut use incremental assembly to start arrays and subsystems as
devices are started, regardless what order they show up.

Phil

