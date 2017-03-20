From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: proactive disk replacement
Date: Mon, 20 Mar 2017 16:04:56 +0100
Message-ID: <c20d279a-62b1-2c3d-cdaf-39a838034afb@thelounge.net>
References: <3FA2E00F-B107-4F3C-A9D3-A10CA5F81EC0@allygray.2y.net>
 <11c21a22-4bbf-7b16-5e64-8932be768c68@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <11c21a22-4bbf-7b16-5e64-8932be768c68@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>, Jeff Allison <jeff.allison@allygray.2y.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 20.03.2017 um 15:59 schrieb Adam Goryachev:
> On 20/3/17 23:47, Jeff Allison wrote:
>> Hi all I’ve had a poke around but am yet to find something definitive.
>>
>> I have a raid 5 array of 4 disks amounting to approx 5.5tb. Now this
>> disks are getting a bit long in the tooth so before I get into
>> problems I’ve bought 4 new disks to replace them.
>>
>> I have a backup so if it all goes west I’m covered. So I’m looking for
>> suggestions.
>>
>> My current plan is just to replace the 2tb drives with the new 3tb
>> drives and move on, I’d like to do it on line with out having to trash
>> the array and start again, so does anyone have a game plan for doing
>> that.
> Yes, do not fail a disk and then replace it, use the newer replace
> method (it keeps redundancy in the array)

how should it keep redundancy when you have to remove a disk anyways 
except you have enough slots to at least temporary add a additional one?
