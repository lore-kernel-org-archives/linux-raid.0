From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Performance of a software raid 5
Date: Tue, 21 Apr 2009 01:52:54 +0100
Message-ID: <49ED18E6.1090301@anonymous.org.uk>
References: <a5cd9eed0904201012o67503049laa50f4cb5b8d88de@mail.gmail.com>	 <49ED096E.1000002@anonymous.org.uk> <a5cd9eed0904201710j5b05d9cam8a61b50f34eda2c0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a5cd9eed0904201710j5b05d9cam8a61b50f34eda2c0@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Johannes Segitz <johannes.segitz@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21/04/2009 01:10, Johannes Segitz wrote:
> On Tue, Apr 21, 2009 at 1:46 AM, John Robinson
> <john.robinson@anonymous.org.uk> wrote:
>> I would have thought it's because you're running in degraded mode and one in
>> 3 sectors is having to be regenerated from the parity. It still seems a bit
>> slow, though.
> 
> i don't think that that is a problem. The data is there without
> redundancy so i can't see
> how there would be the need to calculate anything

There's no redundancy but it's still the RAID-5 4-disc layout with 3 
data and 1 parity, the parity on a different disc in each stripe. In 
your case with a missing disc, for 3 stripes in 4 you have 2 data and 1 
parity. Of course the parity is having to be calculated when you're 
writing, and whatever would be written to your missing disc is being 
discarded.

On the other hand if you were using RAID-0 over 3 discs there would be 
no need to calculate anything.

Cheers,

John.
