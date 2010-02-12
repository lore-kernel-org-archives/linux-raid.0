From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Linux mdadm superblock question.
Date: Thu, 11 Feb 2010 17:52:41 -0800
Message-ID: <4877c76c1002111752h23e14f7aibe58a89181e6f493@mail.gmail.com>
References: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Feb 11, 2010 at 3:00 PM, Justin Piszcz <jpiszcz@lucidpixels.com=
> wrote:
> Hi,
>
> I may be converting a host to ext4 and was curious, is 0.90 still the=
 only
> superblock version for mdadm/raid-1 that you can boot from without ha=
ving to
> create an initrd/etc?
>
> Are there any benefits to using a superblock > 0.90 for a raid-1 boot=
 volume
> < 2TB?
>
> Justin.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

You need the superblock at the end of the partition:  If you read the
manual that is clearly either version 0.90 OR 1.0 (NOT 1.1 and also
NOT 1.2; those use the same superblock layout but different
locations).
