From: Andre Tomt <andre@tomt.net>
Subject: Re: md - cache
Date: Wed, 16 Feb 2011 17:41:25 +0100
Message-ID: <4D5BFE35.7090408@tomt.net>
References: <AANLkTi=qav77Q8pjU8_xhmuvYSkZk7_Hwd3Xe89BWtBK@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=qav77Q8pjU8_xhmuvYSkZk7_Hwd3Xe89BWtBK@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/16/2011 05:01 PM, Roberto Spadim wrote:
> hi guys, i was thinking about cache insues
> since md = multiple devices
> could we implement a new device used for caches? (port bcache to md,
> or flashcache (facebook))
> something like:
> mdadm --create /dev/md1 --level=cache --cache-device=/dev/XXX
> --data-device=/dev/ZZZZ
>

Wny would you want to port when it works fine across different types of 
block devices already, including md? At least bcache is supposed to - 
and I think flashcache too.
