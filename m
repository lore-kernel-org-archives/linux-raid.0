From: Luca Berra <bluca@comedia.it>
Subject: Re: Linux mdadm superblock question.
Date: Mon, 15 Feb 2010 08:51:41 +0100
Message-ID: <20100215075141.GB5068@maude.comedia.it>
References: <201002140251.59668.volkerarmin@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201002140251.59668.volkerarmin@googlemail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Feb 14, 2010 at 02:51:59AM +0100, Volker Armin Hemmann wrote:
>>0.90 has a very bad problem, which is that it is hard to distinguish
>>between a RAID partition at the end of volume and a full RAID device.
>>This is because 0.90 doesn't actually tell you the start of the device.
>>
>>Then, of course, there are a lot of limitations on size, number of
>>devices, and so on in 0.90.
>
>but it is the only format supporting autodetection. 
>
>So - when will autodetection be introduced with 1.X? And if not, why not?
>
>All I found was 'autodetection might be troublesome' and nothing else.
Well the discussions that lead to deprecation of in-kernel autodetection
date back to 2005 or earlier, so it's not easy to find.
iirc the main problem was that autodetection used the super minor to
name the device and it got very confused if you moved a drive from a
system to another.

mdadm based autodetection is reliable since you can associate uuid with
device name in mdadm.conf

> But dealing with initrds is troublesome too. Pure evil even. 
not really much more complex than getting kernel to do the right thing.
and it is orders of magnitude easier to debug than kernel code.

L.


-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
