From: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
Subject: Re: raid array with 3T disks and GPT partition
Date: Thu, 01 Sep 2011 17:53:02 +0200
Message-ID: <4E5FAA5E.80007@macroscoop.nl>
References: <20110901154759.GA32649@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110901154759.GA32649@apartia.fr>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/01/2011 05:47 PM, Louis-David Mitterrand wrote:
>
> Now how do I make sure that these partitions have the correct "raid
> autodetect" (fd) id? Is it even still needed? I didn't find any way to
> set that flag in (g)parted.
>
I used gdisk and entered FD00

