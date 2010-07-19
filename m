From: Konstantin Svist <fry.kun@gmail.com>
Subject: Re: messed up changing chunk size
Date: Sun, 18 Jul 2010 17:51:15 -0700
Message-ID: <4C43A183.4070403@gmail.com>
References: <4C439D19.4070906@gmail.com> <003b01cb26db$2860d8c0$79228a40$@crc.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <003b01cb26db$2860d8c0$79228a40$@crc.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Steven Haigh <netwiz@crc.id.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  On 07/18/2010 05:41 PM, Steven Haigh wrote:
> It seems that when you shrank the array a little bit that you chopped off the end of the ext4 filesystem...
>
> The raid array is now smaller than the filesystem says it is - hence your error.

That's what I thought, too.
But, again, the question is whether or not I can recover the data...
