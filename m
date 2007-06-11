From: Peter Rabbitson <rabbit@rabbit.us>
Subject: Re: LVM on raid10 - severe performance drop
Date: Mon, 11 Jun 2007 14:52:56 +0200
Message-ID: <466D45A8.5060503@rabbit.us>
References: <466B3E24.1020203@rabbit.us> <20070610010644.GA24847@lanczos.q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070610010644.GA24847@lanczos.q-leap.de>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bernd Schubert wrote:
> 
> Try to increase the read-ahead size of your lvm devices:
> 
> blockdev --setra 8192 /dev/raid10/space
> 
> or increase it at least to the same size as of your raid (blockdev
> --getra /dev/mdX).

This did the trick, although I am still lagging behind the raw md device 
by about 3 - 4%. Thanks for pointing this out!
