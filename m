From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Superblock limits / conversion
Date: Thu, 13 Nov 2008 10:20:25 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0811131019350.7992@p34.internal.lan>
References: <7d86ddb90811130646k440676aakecc62defc8d42b7a@mail.gmail.com> <20081113151206.GB25751@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081113151206.GB25751@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Hill <robin@robinhill.me.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Thu, 13 Nov 2008, Robin Hill wrote:

> On Thu Nov 13, 2008 at 09:46:23AM -0500, Ryan Wagoner wrote:
>
>> I have a RAID 5 array with 3 TB drives. When reading through the list
>> I realized that the v0.90 superblock doesn't support arrays over 2TB.
>> This means I can never grow this array to 4 drives?
>>
> That's my understanding, yes.

I grew 400GiB drives in a raid5 configuration  from 1.8TiB to 3.3TiB 
one at a time with the 0.90 superblock (I believe), is that limit correct?

It was awhile ago but FYI.

Justin.

