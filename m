From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Superblock limits / conversion
Date: Fri, 14 Nov 2008 07:17:23 +1300
Message-ID: <491C6F33.1040904@sauce.co.nz>
References: <7d86ddb90811130646k440676aakecc62defc8d42b7a@mail.gmail.com> <20081113151206.GB25751@cthulhu.home.robinhill.me.uk> <alpine.DEB.1.10.0811131019350.7992@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0811131019350.7992@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Robin Hill <robin@robinhill.me.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz wrote:
> 
> 
> On Thu, 13 Nov 2008, Robin Hill wrote:
> 
>> On Thu Nov 13, 2008 at 09:46:23AM -0500, Ryan Wagoner wrote:
>>
>>> I have a RAID 5 array with 3 TB drives. When reading through the list
>>> I realized that the v0.90 superblock doesn't support arrays over 2TB.
>>> This means I can never grow this array to 4 drives?
>>>
>> That's my understanding, yes.
> 
> I grew 400GiB drives in a raid5 configuration  from 1.8TiB to 3.3TiB one 
> at a time with the 0.90 superblock (I believe), is that limit correct?

My understanding is that the 2TB limit on 0.90 superblocks, is for md 
component size, not md device size.

Regards,

Richard
