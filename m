From: Thomas Backlund <tmb@mandriva.org>
Subject: Re: md raid10 regression in 2.6.27.4 (possibly earlier)
Date: Mon, 03 Nov 2008 01:51:21 +0200
Message-ID: <490E3CF9.20208@mandriva.org>
References: <490D8EBF.8050400@rabbit.us> <490DE55F.6080600@mandriva.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <490DE55F.6080600@mandriva.org>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thomas Backlund skrev:
> Peter Rabbitson skrev:
>> Hi,
>>
>> Some weeks ago I upgraded from 2.6.23 to 2.6.27.4. After a failed hard
>> drive I realized that re-adding drives to a degraded raid10 no longer
>> works (it adds the drive as a spare and never starts a resync). Booting
>> back into the old .23 kernel allowed me to complete and resync the array
>> as usual. Attached find a test case reliably failing on vanilla 2.6.27.4
>> with no patches.
>>
> 
> I've just been hit with the same problem...
> 
> I have a brand new server setup with 2.6.27.4 x86_64 kernel and a mix of
> raid0, raid1, raid5 & raid10 partitions like this:

And an extra datapoint.

Booting into 2.6.26.5 triggers an instant resync of the spare disks, so 
it means we have a regression between 2.6.26.5 and 2.6.27.4

If no-one have a good suggestion to try, I'll start bisecting tomorrow...
--
Thomas
