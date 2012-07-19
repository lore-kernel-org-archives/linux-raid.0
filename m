From: Asdo <asdo@shiftmail.org>
Subject: Re: RAID5 speed goes down
Date: Thu, 19 Jul 2012 18:32:52 +0200
Message-ID: <500836B4.1020400@shiftmail.org>
References: <CA+=meHWy3Uejy+At8kB0u4AyRPqR1B_iZoD1LOfFDw5GsmUqkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <CA+=meHWy3Uejy+At8kB0u4AyRPqR1B_iZoD1LOfFDw5GsmUqkg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Schleifer <alexander.schleifer@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/16/12 22:10, Alexander Schleifer wrote:
>   What can I do to get more
> information what is going on there?
>

iostat -x 1

cat /sys/block/mdX/md/stripe_cache_active

also tell your kernel version

