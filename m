From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Raid and badblocks
Date: Sat, 30 May 2009 14:29:59 +0100
Message-ID: <4A2134D7.9020909@anonymous.org.uk>
References: <gv5q3p$vof$1@ger.gmane.org> <gv5qnk$1pe$1@ger.gmane.org>	 <77f027ed892f0a37b3df63d574ae7955.squirrel@neil.brown.name>	 <gvgp32$9se$1@ger.gmane.org> <1243351643.11073.29.camel@cichlid.com> <389deec70905300313v70766bcfmc10bef87ab11c9a8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <389deec70905300313v70766bcfmc10bef87ab11c9a8@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: hank peng <pengxihan@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 30/05/2009 11:13, hank peng wrote:
> 2009/5/26 Andrew Burgess <aab@cichlid.com>:
>> On Tue, 2009-05-26 at 13:59 +0100, Jeremy Sanders wrote:
>>
>>> Strangely, the Reallocated_Sector_Ct is still zero on the drive even though
>>> Current_Pending_Sector is now zero. This is a Samsung HD103UJ by the way.
>> That can be ok. It probably tried writing and then rereading and when
>> that worked it decided the sector didn't really have a 'hard' error
>> (like a physical defect on the platter) and thus didn't need to be
>> reallocated to a spare sector. You could generate an unreadable sector
>> during a write by the power failing or with excessive vibration.
>>
> I have a question, in this situation, if I do as Jeremy did, write
> zero to bad block to make drive think it is not bad any more, then
> what about old data? Isn't it lost?

In Jeremy's case, the bad block was past the end of the data in the 
array, so no, data wasn't lost. If the bad block had been within the 
array data, the repair operation he ran earlier would have found it, 
reconstructed the correct data from the other drives, and rewritten it, 
again avoiding any data loss.

Cheers,

John.

