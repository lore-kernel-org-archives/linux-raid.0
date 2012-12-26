From: Phil Turmel <philip@turmel.org>
Subject: Re: Any risk switching mdadm to static?
Date: Wed, 26 Dec 2012 14:53:33 -0500
Message-ID: <50DB55BD.2040208@turmel.org>
References: <CAK2H+ee_u3bc7ZgN9z9CJbuSN+8HVyeTLwRaCn5hCP1fB3w8NQ@mail.gmail.com> <50DB49B3.4070703@turmel.org> <CAK2H+ecQpTtipdPWQmVj2gCZ6FPzeXfx5bj8y4asVdhf1CTkfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+ecQpTtipdPWQmVj2gCZ6FPzeXfx5bj8y4asVdhf1CTkfA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/26/2012 02:28 PM, Mark Knecht wrote:
> On Wed, Dec 26, 2012 at 11:02 AM, Phil Turmel <philip@turmel.org> wrote:

[trim /]

>> I can't answer the question off the top, but I thought I'd point out
>> that you probably don't need static for use with an initramfs.  Because
>> I run stable amd64 on one of my gentoo servers, and don't have 'static'
>> set for mdadm.  I use dracut with mdraid and lvm use flags to build my
>> initramfs images.  Rootfs is in LVM which is on MD raid10.
> 
> OK, that's good to know. I'm not currently using dracut as I'd like to go
> through the process once or twice by hand as I learn, and maybe I'm
> overreacting to what I'm seeing here. It's my understanding that the
> purpose of the static flag is to build into the mdadm binary any libraries
> that would normally be loaded dynamically. Is that correct?

Yes.

> c2stable ~ # ldd /sbin/mdadm
>         linux-vdso.so.1 (0x00007fff735e3000)
>         libc.so.6 => /lib64/libc.so.6 (0x00007f81a31e6000)
>         /lib64/ld-linux-x86-64.so.2 (0x00007f81a3591000)
> c2stable ~ #

Mine is effective identical (slight offset differences, as expected for
custom-compiled systems).  Dracut put these libraries in my initramfs.

> So the above is for NOT static case. My concern is about
> whether I have to put these libraries in my initramfs image
> by hand, or said another way, if I build static then are these
> libraries completely linked in and carried along with the
> mdadm binary?

Yes, as you've since demonstrated.

>> From my understanding of how linking works, I'd say it *can't* hurt.
>>
> 
> That's my general feeling also, but I'm just trying to be both extra
> careful as well as learn something.
> 
> Thanks for the response!

You're welcome.

Phil

