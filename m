From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Performance of a software raid 5
Date: Tue, 21 Apr 2009 02:12:14 +0100
Message-ID: <49ED1D6E.4070104@anonymous.org.uk>
References: <a5cd9eed0904201012o67503049laa50f4cb5b8d88de@mail.gmail.com>	 <49ED096E.1000002@anonymous.org.uk>	 <a5cd9eed0904201710j5b05d9cam8a61b50f34eda2c0@mail.gmail.com>	 <49ED18E6.1090301@anonymous.org.uk> <a5cd9eed0904201805n1b52aafm206bda5a1afc0b5c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a5cd9eed0904201805n1b52aafm206bda5a1afc0b5c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Johannes Segitz <johannes.segitz@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21/04/2009 02:05, Johannes Segitz wrote:
> On Tue, Apr 21, 2009 at 2:52 AM, John Robinson
> <john.robinson@anonymous.org.uk> wrote:
>> There's no redundancy but it's still the RAID-5 4-disc layout with 3 data
>> and 1 parity, the parity on a different disc in each stripe. In your case
>> with a missing disc, for 3 stripes in 4 you have 2 data and 1 parity. Of
>> course the parity is having to be calculated when you're writing, and
>> whatever would be written to your missing disc is being discarded.
> 
> you're right, i didn't think of that. But calculating an xor isn't really
> a big deal (especially with the aes on top of it) so i still can't see why
> it's so slow

No nor can I, especially since your `time` output shows a very modest 
amount of system time; it may be worth trying fewer layers (i.e. no 
encryption and/or no filesystem) to eliminate them, or monitoring with 
other tools like iostat to see if you can get to the bottom of it.

Cheers,

John.

