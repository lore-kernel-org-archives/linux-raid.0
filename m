From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: [PATCH] md: new bitmap sysfs interface
Date: Thu, 27 Jul 2006 10:07:06 -0400
Message-ID: <44C8C88A.8080109@steeleye.com>
References: <44C5BA6F.3010404@steeleye.com>	 <170fa0d20607261430n3e9d3962xeef50669ce0d1996@mail.gmail.com>	 <44C8248B.7010501@steeleye.com> <170fa0d20607262036i30ab9f12qf64c0fc7b90b9eca@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <170fa0d20607262036i30ab9f12qf64c0fc7b90b9eca@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@gmail.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Mike Snitzer wrote:
> On 7/26/06, Paul Clements <paul.clements@steeleye.com> wrote:
>> Mike Snitzer wrote:

>> > Also, what is the interface one should use to collect dirty bits from
>> > the primary's bitmap?
>>
>> Whatever you'd like. scp the bitmap file over or collect the ranges into
>> a file and scp that over, or something similar.
> 
> OK, so regardless of whether you are using an external or internal
> bitmap; how does one collect the ranges from an array's bitmap?

Well, with an internal bitmap you don't need this interface. The bitmap 
is located on all the component disks. The reason we don't use internal 
bitmaps in a configuration where one of the disks is located remotely 
(over a LAN or SAN, or possibly a WAN) is that the bitmap updates (which 
are synchronous and occur fairly often) would be too costly.

So reading the bits out of a file is fairly simple. The bitmap file is 
laid out one bit per chunk, with a 256 byte superblock at the front. You 
just need a perl script (for example) that reads the file and keeps 
track of which bits are dirty, and then prints those numbers out.

--
Paul
