From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: proactive disk replacement
Date: Tue, 21 Mar 2017 01:59:05 +1100
Message-ID: <11c21a22-4bbf-7b16-5e64-8932be768c68@websitemanagers.com.au>
References: <3FA2E00F-B107-4F3C-A9D3-A10CA5F81EC0@allygray.2y.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3FA2E00F-B107-4F3C-A9D3-A10CA5F81EC0@allygray.2y.net>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Allison <jeff.allison@allygray.2y.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 20/3/17 23:47, Jeff Allison wrote:
> Hi all I’ve had a poke around but am yet to find something definitive.
>
> I have a raid 5 array of 4 disks amounting to approx 5.5tb. Now this disks are getting a bit long in the tooth so before I get into problems I’ve bought 4 new disks to replace them.
>
> I have a backup so if it all goes west I’m covered. So I’m looking for suggestions.
>
> My current plan is just to replace the 2tb drives with the new 3tb drives and move on, I’d like to do it on line with out having to trash the array and start again, so does anyone have a game plan for doing that.
Yes, do not fail a disk and then replace it, use the newer replace 
method (it keeps redundancy in the array).
Even better would be to add a disk, and convert to RAID6, then add a 
second disk (using replace), and so on, then remove the last disk, grow 
the array to fill the 3TB, and then reduce the number of disks in the raid.
This way, you end up with RAID6...
> Or is a 9tb raid 5 array the wrong thing to be doing and should I be doing something else 6tb raid 10 or something I’m open to suggestions.
I'd feel safer with RAID6, but it depends on your requirements. RAID10 
is also a nice option, but, it depends...

Regards,
Adam

