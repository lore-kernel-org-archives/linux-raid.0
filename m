From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Recover array after I panicked
Date: Sun, 23 Apr 2017 22:06:15 +0800
Message-ID: <807de641-043c-41a0-cffe-e28710503aba@fnarfbargle.com>
References: <3957da08-6ff4-3c15-e499-157244a767aa@powerlamerz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3957da08-6ff4-3c15-e499-157244a767aa@powerlamerz.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Patrik_Dahlstr=c3=b6m?= <risca@powerlamerz.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23/04/17 17:47, Patrik Dahlström wrote:
> Hello,
>
> Here's the story:
>
> I started with a 5x6 TB raid5 array. I added another 6 TB drive and
> started to grow the array. However, one of my SATA cables were bad and
> the reshape gave me lots of I/O errors.
>
> Instead of fixing the SATA cable issue directly, I shutdown the server
> and swapped places of 2 drives. My reasoning was that putting the new
> drive in a good slot would reduce the I/O errors. Bad move, I know. I
> tried a few commands but was not able to continue the reshape.
>

Nobody seems to have mentioned the reshape issue. What sort of reshape 
were you running? How far into the reshape did it get? Do you have any 
logs of the errors (which might at least indicate whereabouts in the 
array things were before you pushed it over the edge)?


What you'll have is one part of the array in one configuration, the 
remaining part in another and no record of where that split begins.

Regards,
Brad
-- 
Dolphins are so intelligent that within a few weeks they can
train Americans to stand at the edge of the pool and throw them
fish.
