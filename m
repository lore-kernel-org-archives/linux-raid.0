From: Phil Turmel <philip@turmel.org>
Subject: Re: Odd --examine output
Date: Mon, 15 Apr 2013 10:00:22 -0400
Message-ID: <516C07F6.7040903@turmel.org>
References: <CD917B51.41713%michael.vanhorn@wright.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CD917B51.41713%michael.vanhorn@wright.edu>
Sender: linux-raid-owner@vger.kernel.org
To: "Vanhorn, Mike" <michael.vanhorn@wright.edu>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 04/15/2013 09:46 AM, Vanhorn, Mike wrote:
> On 4/12/13 10:52 AM, "Phil Turmel" <philip@turmel.org> wrote:
> 
>> NOT a guess.  Back up what you can, while you can, and start over.  Use
>> "fdisk -u" so you can ensure partitions start on multiples of eight (8)
>> sectors.  (Modern fdisk uses 1MB alignment by default.  Highly
>> recommended.)
>>
>>
> 
> So, if I start the partition at sector 64 (rather than 63), that's better,
> right (since 64 is a multiple of 8)? Or is there more math to do and I'm
> still not getting it?

No, you're right.  Sector 64 is a reasonable choice for spinning rust
disks.  The more modern default of sector 2048 (1MB) is intended to
cover future advances, including solid state drives' erase blocks.
(Although it seems that the best SSDs handle that factor on their own.)

Phil
