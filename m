From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Linux mdadm superblock question.
Date: Tue, 16 Feb 2010 14:28:29 +0000
Message-ID: <4B7AAB8D.9030009@anonymous.org.uk>
References: <201002140251.59668.volkerarmin@googlemail.com> <201002141940.35716.volkerarmin@googlemail.com> <4B7846B2.1030303@anonymous.org.uk> <201002142013.24922.volkerarmin@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201002142013.24922.volkerarmin@googlemail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Volker Armin Hemmann <volkerarmin@googlemail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 14/02/2010 19:13, Volker Armin Hemmann wrote:
> On Sonntag 14 Februar 2010, you wrote:
>> On 14/02/2010 18:40, Volker Armin Hemmann wrote:
>>> On Sonntag 14 Februar 2010, you wrote:
>>>> In other words, 'auto-detection' for 1.x format devices is using an
>>>> initrd/initramfs.
>>> which makes 1.x format useless for everybody who does not want to deal
>>> with initrd/initramfs.
>> True, but afaik every distro uses an initrd/initramfs and bundles tools
>> making it easy to manage and customise them, so what's the problem?
> 
> and distros do it because of all the drivers they have to ship. But for 
> example I am not bound by such limitations. Why should I deal with that?
> It is hard enough not to forget 'make modules_install'. And now add initrd. 
> Autodetecting just works - but if you use an initrd an it doesn't. Where do 
> you start?
> 
> Initrd's maybe great for distro packagers, but are they really usefull for 
> anybody else?

Not just for distro packagers, they're useful for distro users, which 
are presumably 99% of Linux users these days, including the vast 
majority of enterprise users who like tested, supported systems.

But even for people building their own kernels, initrd/initramfs are 
useful if you're using LVM, or indeed trying to boot off anything that's 
not a simple device.

Cheers,

John.
