From: "Chris Worley" <worleys@gmail.com>
Subject: Re: Interesting article
Date: Wed, 14 Jan 2009 15:55:33 -0700
Message-ID: <f3177b9e0901141455i460f09cs69e38e24842e9c62@mail.gmail.com>
References: <496E44DE.7090200@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <496E44DE.7090200@harddata.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Maurice Hilarius <maurice@harddata.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jan 14, 2009 at 1:02 PM, Maurice Hilarius <maurice@harddata.com> wrote:
> I read this today:
> http://blogs.zdnet.com/storage/?p=162
>
> Would anyone who knows enough about this care to comment?

We need disks continuously scanned in spare cycles, and offline the
drives (or remap the sectors) as soon as an error is found.

Also, when rebuilding an array, don't stop due to a read failure.
mark the sector as bad and complete the rebuild.

Waiting for a drive to fail has been too late to recover the array, in
my experience.

Chris
>
> Thanks in advance for any thoughts..
>
>
> --
> With our best regards,
>
> //Maurice W. Hilarius         Telephone: 01-780-456-9771/
> /Hard Data Ltd.                FAX:          01-780-456-9772/
> /11060 - 166 Avenue         email:maurice@harddata.com/
> /Edmonton, AB, Canada/
> /     T5X 1Y3/
> /
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
