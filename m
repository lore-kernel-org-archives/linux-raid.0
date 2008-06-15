From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: Rebuilding an array with a corrupt disk.
Date: Sun, 15 Jun 2008 17:09:28 +0200
Message-ID: <485530A8.3050601@rabbit.us>
References: <fa037c550806131922y475de7ew8c3a66aa06d081b1@mail.gmail.com>	 <4853634C.90508@dgreaves.com>	 <fa037c550806140354k7bcab83fs39738e165f3aba8d@mail.gmail.com>	 <4853AFCF.5050209@dgreaves.com> <fa037c550806150454v68089bcbg50203b454ae593e0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fa037c550806150454v68089bcbg50203b454ae593e0@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sean Hildebrand <silverwraithii@gmail.com>
Cc: David Greaves <david@dgreaves.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sean Hildebrand wrote:
> 
> <snip>
> 

> 
> To answer that: The drive was brand new. The thing I find odd about
> this failure is that it was integrated into the array without issue,
> meaning the disk has no issues writing to the bad sectors, just
> reading. Never had that before.
> 
> In any case, I'm very glad to have got my data with minimal loss. And
> to think, all this could have been avoided if I'd just made my array a
> RAID6 when it was first built. Certainly when I have a new fifth disk
> the array will be rebuilt as such.
> 

When you get your new disk (or any disk for that matter) run badblocks -svw on 
it. It takes about 8 hours on average drive sizes today, but guards precisely 
against the problem you faced. Additionally the drive will receive a hefty 
does of "break in", so you know it performed well under stress at least for 
several hours.
