From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Linux mdadm superblock question.
Date: Sat, 13 Feb 2010 13:29:37 -0800
Message-ID: <4B7719C1.1060400@zytor.com>
References: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan> <4877c76c1002111752h23e14f7aibe58a89181e6f493@mail.gmail.com> <4B77044B.1020609@zytor.com> <alpine.DEB.2.00.1002131507260.31103@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1002131507260.31103@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Michael Evans <mjevans1983@gmail.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On 02/13/2010 12:07 PM, Justin Piszcz wrote:
> 
> My original question was does the newer superblock do anything special
> or offer new features *BESIDES* the quicker resync?
> 

0.90 has a very bad problem, which is that it is hard to distinguish
between a RAID partition at the end of volume and a full RAID device.
This is because 0.90 doesn't actually tell you the start of the device.

Then, of course, there are a lot of limitations on size, number of
devices, and so on in 0.90.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
