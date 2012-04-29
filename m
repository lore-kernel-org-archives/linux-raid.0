From: Shaya Potter <spotter@gmail.com>
Subject: Re: recovering from raid5 corruption
Date: Sun, 29 Apr 2012 19:51:04 -0400
Message-ID: <4F9DD3E8.7050701@gmail.com>
References: <4F9DC2E5.1090509@gmail.com> <20120430085257.65d19c20@notabene.brown> <4F9DCEC6.1050109@gmail.com> <20120430094546.4702be0a@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120430094546.4702be0a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/29/2012 07:45 PM, NeilBrown wrote:
> On Sun, 29 Apr 2012 19:29:10 -0400 Shaya Potter<spotter@gmail.com>  wrote:
>
>> On 04/29/2012 06:52 PM, NeilBrown wrote:
>>>
>>> You've written a new superblock 4K in to each device, where previously here
>>> was something.   So you have probably corrupted something though we cannot
>>> easily tell what.
>>>
>>> Retry your experiment with --metadata=0.90.  Hopefully one of those
>>> combinations will work better.  If it does, make a backup of the data you
>>> want to keep, then I would suggest rebuilding the array from scratch.
>>
>> ok, thanks, that was a huge help.
>>
>> I have it setup correctly now (obvious due to the fact that I can read
>> the lvm configuration without any gibberish when ordered correctly).
>
> I should add that this only proves that you have the first device correct,
> the rest may be wrong.
> You need to activate the LVM, then look at the filesystem and see if it is
> consistent before you can be sure that all devices are in the correct
> position.

true, but that also brings my permutations down to 2 (based on my 
assumption that disks in slot 2 (missing), 3 (uncorrupted), are correct. 
  so hopefully restoring lvm doesn't mess up any other data (though 
probably have to make sure that ext3 doesn't do any journal 
reading/writing in an attempt to mount to see if setup correctly as well).
