From: Joshua Kinard <kumba@gentoo.org>
Subject: Re: [PATCH] md: forbid a RAID5 from having both a bitmap and a
 journal.
Date: Tue, 17 Oct 2017 21:51:28 -0400
Message-ID: <3c9139e8-8035-d592-7875-f9dab5ab9568@gentoo.org>
References: <a9a406f5f751d39620d5e4907992ccb1bdbfb5a7.1507670143.git.shli@fb.com>
 <87bmldnjtq.fsf@notabene.neil.brown.name>
 <20171012173019.c2bbfyz3hgudjbhz@kernel.org>
 <ED3BAA5A-9A7B-4FA1-BC4E-299F1A69D9E7@fb.com>
 <87wp3zlj9q.fsf@notabene.neil.brown.name>
 <20171013195122.mi7gr4xxm77odx7t@kernel.org>
 <608CE47A-1C46-4087-B7D3-6FA5936C1DAF@fb.com>
 <877evulrpm.fsf@notabene.neil.brown.name>
 <20171016235609.mmo3vbqiekr4li5c@kernel.org>
 <87sheijw2u.fsf@notabene.neil.brown.name>
 <23014.27372.306872.143938@quad.stoffel.home>
 <8760bdjxl0.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8760bdjxl0.fsf@notabene.neil.brown.name>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, John Stoffel <john@stoffel.org>
Cc: Shaohua Li <shli@kernel.org>, Song Liu <songliubraving@fb.com>, linux-raid <linux-raid@vger.kernel.org>, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

On 10/17/2017 17:03, NeilBrown wrote:
> On Tue, Oct 17 2017, John Stoffel wrote:
> 
>>>>>>> "NeilBrown" == NeilBrown  <neilb@suse.com> writes:
>>
>> NeilBrown> Having both a bitmap and a journal is pointless.
>> NeilBrown> Attempting to do so can corrupt the bitmap if the journal
>> NeilBrown> replay happens before the bitmap is initialized.
>> NeilBrown> Rather than try to avoid this corruption, simply
>> NeilBrown> refuse to allow arrays with both a bitmap and a journal.
>> NeilBrown> So:
>> NeilBrown>  - if raid5_run sees both are present, fail.
>>
>> So what happens if there's someone out there with an array setup with
>> both already?  Should the journal or the bitmap be removed at this
>> time?  
> 
> If someone has an array like that they can assemble it with
>   --update=no-bitmap

IMHO, this should probably get documented in the Linux RAID Wiki once it goes
through.


> I'd rather not automatically disable things.
> 
> Thanks,
> NeilBrown

-- 
Joshua Kinard
Gentoo/MIPS
kumba@gentoo.org
6144R/F5C6C943 2015-04-27
177C 1972 1FB8 F254 BAD0 3E72 5C63 F4E3 F5C6 C943

"The past tempts us, the present confuses us, the future frightens us.  And our
lives slip away, moment by moment, lost in that vast, terrible in-between."

--Emperor Turhan, Centauri Republic
