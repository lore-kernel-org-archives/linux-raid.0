From: Kai Stian Olstad <kai.stian.olstad@gmail.com>
Subject: Re: RAID1 question
Date: Fri, 30 Sep 2011 08:15:27 +0200
Message-ID: <4E855E7F.3000800@gmail.com>
References: <20110929183457.GA19871@electro-mechanical.com> <20110929192611.GA23316@cthulhu.home.robinhill.me.uk> <20110929193705.GE19871@electro-mechanical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110929193705.GE19871@electro-mechanical.com>
Sender: linux-raid-owner@vger.kernel.org
To: William Thompson <wt@electro-mechanical.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 29. sep. 2011 21:37, William Thompson wrote:
> On Thu, Sep 29, 2011 at 08:26:11PM +0100, Robin Hill wrote:
>> On Thu Sep 29, 2011 at 02:34:57PM -0400, William Thompson wrote:
>>
>>> Please keep me in the CC.  I am not on the list.
>>>
>>> If I have a RAID1 of 2 disks and I decide to move them to another computer
>>> and recreate the raid, does it really need to do the initial recovery?
>>>
>> You don't need to recreate the raid at all, just reassemble it. You may
>> want to update the homehost though, otherwise it will (IIRC) auto
>> assemble to md_126 (or so) instead of md0.
> 
> The reason I asked this was because a mirrored pair that I currently have is
> 0.90 version and I was going to use 1.0

You'll find information about going from 0.90 to 1.0 in the archive,
take a look at these links:
http://thread.gmane.org/gmane.linux.raid/34014/focus=34029
http://thread.gmane.org/gmane.linux.raid/34424/focus=34441


-- 
Kai Stian Olstad
