From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Raid6 write performance
Date: Fri, 27 Feb 2009 17:04:52 -0800
Message-ID: <49A88DB4.40008@zytor.com>
References: <49742E74.9090502@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49742E74.9090502@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter Rabbitson wrote:
> Hi,
> 
> I am experimenting with raid6 on 4 drives on 2.6.27.11. The problem I am
> having is that no matter what chunk size I use, the write benchmark
> always comes out at single drive speed, although I should be seeing
> double drive speed (read speed is at near 4x as expected).

I have no idea why you "should" be seeing double drive speed.  All
drives have to be written, so you'd logically see single drive speed.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

