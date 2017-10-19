From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: [PATCH] md: forbid a RAID5 from having both a bitmap and a
 journal.
Date: Fri, 20 Oct 2017 00:21:51 +0100
Message-ID: <59E9338F.9060802@youngman.org.uk>
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
 <23015.27076.469924.191613@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <23015.27076.469924.191613@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>, NeilBrown <neilb@suse.com>
Cc: Shaohua Li <shli@kernel.org>, Song Liu <songliubraving@fb.com>, linux-raid <linux-raid@vger.kernel.org>, "kumba@gentoo.org" <kumba@gentoo.org>, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

On 18/10/17 15:48, John Stoffel wrote:
>>>>>> "NeilBrown" == NeilBrown  <neilb@suse.com> writes:
> 
> NeilBrown> On Tue, Oct 17 2017, John Stoffel wrote:
>>>>>>>> "NeilBrown" == NeilBrown  <neilb@suse.com> writes:
>>>
> NeilBrown> Having both a bitmap and a journal is pointless.
> NeilBrown> Attempting to do so can corrupt the bitmap if the journal
> NeilBrown> replay happens before the bitmap is initialized.
> NeilBrown> Rather than try to avoid this corruption, simply
> NeilBrown> refuse to allow arrays with both a bitmap and a journal.
> NeilBrown> So:
> NeilBrown> - if raid5_run sees both are present, fail.
>>>
>>> So what happens if there's someone out there with an array setup with
>>> both already?  Should the journal or the bitmap be removed at this
>>> time?  
> 
> NeilBrown> If someone has an array like that they can assemble it with
> NeilBrown>   --update=no-bitmap
> 
> NeilBrown> I'd rather not automatically disable things.
> 
> That works for me, assuming there's a useful message in the logs
> explaining what's gone wrong here.  Either mdadm emits the message, or
> the kernel does.
> 
Or are we better off, initially, just adding the code that prevents
adding a bitmap or journal? Allow existing arrays to run, emitting
messages to the console and/or log that this is not a good idea?

Then maybe a few versions down the line actually refuse to start an
array in this state.

I don't know how many arrays are in this state now, but doing this
should reduce the number of people getting a nasty shock when their
system fails to boot ...

Cheers,
Wol
