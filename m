From: Phil Turmel <philip@turmel.org>
Subject: Re: Advice requested
Date: Mon, 2 Nov 2015 19:57:52 -0500
Message-ID: <56380690.5030600@turmel.org>
References: <CAPpdf58rFk95KYGc3WkOQGg+ytJ3rcmWtu23ZU3-ss=vx_GfhQ@mail.gmail.com>
 <56367C33.6060703@turmel.org>
 <CAPpdf5_PUpR7GhBHUaQfWb8Q+7FZenxXgFqbaN3f3r0r6NQNDA@mail.gmail.com>
 <5637842D.1070000@turmel.org>
 <CAPpdf59MFX1oVwLC-bmQBaQp9K_9-+h0v64OGMnV1-k=eCzO0w@mail.gmail.com>
 <5637BCE4.8000006@turmel.org>
 <CAPpdf58En1ARr9YiFSgvPN5Ke_t7=EfxiaN9cZtGVtvR4NUdmA@mail.gmail.com>
 <5637FBAC.8000900@turmel.org>
 <CAPpdf59mkRiyNYF1dT6Xp9tcofTU8hOdih+tz+i=wPJfRQrTnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPpdf59mkRiyNYF1dT6Xp9tcofTU8hOdih+tz+i=wPJfRQrTnQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: o1bigtenor <o1bigtenor@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/02/2015 07:44 PM, o1bigtenor wrote:

> root@debianbase:/# dd if=/dev/md0 bs=1M count=16 |hexdump -c |head -n 1000
> 0000000  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0

Please use a capital 'C' as the hexdump option.

Hexdump collapses repeated data as a convenience ... that I was counting on.

Phil

