From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: proactive disk replacement
Date: Mon, 20 Mar 2017 14:25:48 +0100
Message-ID: <56d66bd3-60c9-7e5c-d0b0-44f6b7f7fb7c@thelounge.net>
References: <3FA2E00F-B107-4F3C-A9D3-A10CA5F81EC0@allygray.2y.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3FA2E00F-B107-4F3C-A9D3-A10CA5F81EC0@allygray.2y.net>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Allison <jeff.allison@allygray.2y.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 20.03.2017 um 13:47 schrieb Jeff Allison:
> Hi all I’ve had a poke around but am yet to find something definitive.
>
> I have a raid 5 array of 4 disks amounting to approx 5.5tb. Now this disks are getting a bit long in the tooth so before I get into problems I’ve bought 4 new disks to replace them.
>
> I have a backup so if it all goes west I’m covered. So I’m looking for suggestions.
>
> My current plan is just to replace the 2tb drives with the new 3tb drives and move on, I’d like to do it on line with out having to trash the array and start again, so does anyone have a game plan for doing that.
>
> Or is a 9tb raid 5 array the wrong thing to be doing and should I be doing something else 6tb raid 10 or something I’m open to suggestions.

you just manually fail them and replace them the same way as if they 
would have died unexpected - done that multiple times

on machines without bayes i just poweroff, replace a disk and then clone 
the mbr and add the partitions also the same way as i do when one dies 
(partitions in case you didn't use the whole drives for the array)

http://bencane.com/2011/07/06/mdadm-manually-fail-a-drive/

