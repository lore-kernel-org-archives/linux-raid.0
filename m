From: Sarah Newman <srn@prgmr.com>
Subject: Re: Bogus entry in mdadm bad blocks list and question about
 particular commit
Date: Tue, 2 Feb 2016 13:09:55 -0800
Message-ID: <56B11B23.4030707@prgmr.com>
References: <56B112F3.9010609@prgmr.com> <wrfjtwlqq1rq.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjtwlqq1rq.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/02/2016 12:46 PM, Jes Sorensen wrote:
> Sarah Newman <srn@prgmr.com> writes:
>> I added some more drives to a raid 1 last night where some devices had existing bad block entries. There was nothing of particular interest in
>> /var/log/messages. Afterwards there is:
>>
>> $ sudo /sbin/mdadm --examine-badblocks /dev/sdl1
>> Bad-blocks on /dev/sdl1:
>>    11986270392325491 for 51 sectors
>>
>> The total number of sectors on the drive is 3907029168.
>>
>> The start sector in the bad blocks list is 2a95730cea9573 in hex, I don't know if that string has any special significance or not.

>> I looked for differences in between 3.18.21 and stable 3.18.y and the
>> only interesting thing looked like e9206476ace "md/raid1:
>> submit_bio_wait() returns 0 on success". I don't think that's a
>> smoking gun for the bogus bad blocks entry. But without that commit,
>> mdadm with bad blocks enabled is completely broken if there are write
>> errors such that successful writes are reported as errors and vice
>> versa, is that correct?
> 
> Sarah,
> 
> If I remember correctly, yes then badblocks handling was pretty wedged
> without that patch since it broke the narrowing down of the problem. If
> you have to run such an old kernel, you really ought to backport
> 681ab4696062f5aa939c9e04d058732306a97176 and
> 203d27b0226a05202438ddb39ef0ef1acb14a759 if you have raid1 and/or raid10
> arrays.

Noted.

What about the bad blocks entry with the completely bogus sector, is there a plausible explanation for that?

Thanks, Sarah
