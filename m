From: Gabor Gombas <gombasg@digikabel.hu>
Subject: Re: Linux mdadm superblock question.
Date: Sun, 14 Feb 2010 22:16:27 +0100
Message-ID: <20100214211627.GA15313@twister.home>
References: <201002140251.59668.volkerarmin@googlemail.com>
 <4877c76c1002132002s20d942c3i7cee5418cdcf369c@mail.gmail.com>
 <201002141940.35716.volkerarmin@googlemail.com>
 <4B7846B2.1030303@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B7846B2.1030303@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Volker Armin Hemmann <volkerarmin@googlemail.com>, Michael Evans <mjevans1983@gmail.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Feb 14, 2010 at 06:53:38PM +0000, John Robinson wrote:

> True, but afaik every distro uses an initrd/initramfs and bundles
> tools making it easy to manage and customise them, so what's the
> problem?

Distro provided initramfs generators have a bad habit assuming you
patch/build your kernel like the distro does. If you want to use a
vanilla kernel with different things built in/built as modules/not built
at all, then you can get nasty surprises, and debugging can be rather
painful.

My current view is if you use a distro kernel, then you should also use
an initramfs (in fact you do not have a choice). But if you want to
build your own kernel, then you should get rid of the initramfs.

Gabor
