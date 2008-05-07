From: "Dan Williams" <dan.j.williams@gmail.com>
Subject: Re: Multiple siI SATA cards and data corruption
Date: Tue, 6 May 2008 22:12:19 -0700
Message-ID: <e9c3a7c20805062212x73a837d7l37905042d835e0a7@mail.gmail.com>
References: <1f0f1a960805061741t16bb165fp342ceb8f97f4347d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1f0f1a960805061741t16bb165fp342ceb8f97f4347d@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Twigathy <twigathy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, May 6, 2008 at 5:41 PM, Twigathy <twigathy@gmail.com> wrote:
> Hi all,
>
>  This is somewhat offtopic; bear with me, someone may be able to help!
>  I posted a short while back that I'd suffered quite a large data loss
>  with mdadm and a handful of SATA disks, it looks like it was caused by
>  a bug in the sata_sil driver as there is stuff posted here:
>  http://www.ussg.iu.edu/hypermail/linux/kernel/0707.1/0024.html as well
>  as a bug on Ubuntu's launchpad site:
>  https://bugs.launchpad.net/ubuntu/+bug/208551
>
>  I'm no kernel hacker, and I have not found much more evidence to
>  support the fact it's a bug other than I can reproduce the failure
>  pretty consistently (6 hard disks over 3 PCI sil 3512 based SATA
>  cards). I've just ordered a new motherboard, CPU etc. for the
>  fileserver in question and can test things a bit more thoroughly once
>  they appear and I have time to swap out the guts of my current
>  machine. Does anyone know how I'd go about even starting to help fix
>  this sata_sil maybe-bug, or indeed if a fix has already been committed
>  to the kernel, or at least how to help track it down?
>

What kernel version are you able to reproduce the problem?

--
Dan
