From: Miles Fidelman <mfidelman@meetinghouse.net>
Subject: Re: 3TB drives failure rate
Date: Sun, 28 Oct 2012 17:07:40 -0400
Message-ID: <508D9E9C.70004@meetinghouse.net>
References: <11510711257.20121028131527@oudeis.org> <DB91871A-731F-44B4-9381-8FBF7D9CC3BF@colorremedies.com> <20121029015910.018efb17@natsu> <F548750F-8D0E-4D05-813B-58D85D652226@colorremedies.com> <20121029021643.1c9e3195@natsu> <46B8932A-58A5-4C1A-9C8C-DCCD5D3A1CD9@colorremedies.com> <20121029024956.30edb309@natsu> <A27BF034-F5B6-45A4-9381-3C0958457C57@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A27BF034-F5B6-45A4-9381-3C0958457C57@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Chris Murphy wrote:
> On Oct 28, 2012, at 2:49 PM, Roman Mamedov <rm@romanrm.ru> wrote:
>
>> On Sun, 28 Oct 2012 14:34:49 -0600
>> Chris Murphy <lists@colorremedies.com> wrote:
>>
>>> A drive that can sit there like a bump on the log for 2 minutes before it issues an actual read failure on sector(s) means mdadm is likewise waiting, and everything above it is waiting. That's a long hang. I'd not be surprised to see users go for hard reset with such a system hang after 45 seconds let alone 2 minutes.
>> Which is not different from what you would get (the same hang) in a non-RAID
>> environment on the same drive, so I don't see how this would be specifically a
>> RAID-related problem.
> The difference is what you depend on running on that RAID. If it's someone playing movies or games, who cares. If you're a small business running a database or web site off this hardware and everything crawls for two minutes, or implodes because of that delay, now it's just bad design.

Exactly.  The whole point of RAID is to keep things going despite a 
drive failure, kind of problematic if the RAID hardware/software doesn't 
get the message to drop a failing drive from the array.



-- 
In theory, there is no difference between theory and practice.
In practice, there is.   .... Yogi Berra

