From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RAID6 algo in md
Date: Wed, 30 Jul 2008 22:54:20 -0700
Message-ID: <4891538C.5010708@zytor.com>
References: <fdf7ae820807242341h58036800s42c0c3577b09ed42@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fdf7ae820807242341h58036800s42c0c3577b09ed42@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adhiraj Joshi <adhiraj@linsyssoft.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Adhiraj Joshi wrote:
> Hi,
> 
> I am trying to understand overall raid6 setup. I learnt the
> Vandermonde Matrix method to implement RAID6, but I could not map it
> with RAID6 implementation in md. Is there any documentation available
> specifically for RAID6 in md? I didnt find any inside the kernel.
> 

http://www.kernel.org/pub/linux/kernel/people/hpa/raid6.pdf

	-hpa

