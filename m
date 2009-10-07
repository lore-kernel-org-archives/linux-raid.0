From: Beolach <beolach@gmail.com>
Subject: Re: mdadm segfault when assembling the array
Date: Wed, 7 Oct 2009 03:03:11 -0600
Message-ID: <aebf5d970910070203l63b21cd4v61e5c9a78e09b8ff@mail.gmail.com>
References: <4ACC5265.2020602@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4ACC5265.2020602@wpkg.org>
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Oct 7, 2009 at 02:33, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
> My development machine crashed (a couple of times - X ati driver does not
> seem to like multiple graphics cards), and I lost one of the md RAID-1
> arrays (other arrays work just fine):
>
> # mdadm -V
> mdadm - v3.0.2 - 25th September 2009
>
> # mdadm /dev/md2 -A /dev/sda5 /dev/sdb5
> Segmentation fault
>
> # dmesg
> [ 4736.407237] md: md2 stopped.
> [ 4736.568062] mdadm[10019]: segfault at 0 ip 00007fc7172ed711 sp
> 00007fff9b486af8 error 4 in libc-2.10.1.so[7fc717274000+154000]
>
> The kernel is 2.6.31.1.
>
> Any hints before I try to fix it my way?
>

How did you install mdadm?  I think I remember similar issues w/
segfaults when I
compiled w/ MAKEOPTS=-jN where N>1.  What distro & architecture were you on?


Good luck,
Conway S. Smith
