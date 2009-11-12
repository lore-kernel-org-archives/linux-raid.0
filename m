From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: mismatch_cnt again
Date: Thu, 12 Nov 2009 17:57:19 -0500
Message-ID: <4AFC92CF.20706@tmr.com>
References: <4AF4C247.6050303@eyal.emu.id.au> <4AF4D323.6020108@panix.com>    <4AF5268D.60900@eyal.emu.id.au>    <4877c76c0911070008m789507f8h799d419287740ca5@mail.gmail.com>    <87tyx6tpcb.fsf@frosties.localdomain> <4AF58B20.3000409@redhat.com>    <87iqdlaujb.fsf@frosties.localdomain> <4AF74B61.6000102@rabbit.us>    <20091109185632.GA2723@lazy.lzy>    <73ebdcee169f46611d411755f9aaca5b.squirrel@neil.brown.name>    <20091109215443.GA4143@lazy.lzy> <d99ca9481d2471073484c5d43d493b4d.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d99ca9481d2471073484c5d43d493b4d.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Peter Rabbitson <rabbit+list@rabbit.us>, Goswin von Brederlow <goswin-v-b@web.de>, Doug Ledford <dledford@redhat.com>, Michael Evans <mjevans1983@gmail.com>, Eyal Lebedinsky <eyal@eyal.emu.id.au>, linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

NeilBrown wrote:
> On Tue, November 10, 2009 8:54 am, Piergiorgio Sartor wrote:
>   
>> Well...
>>
>>     
>>> Is this an offer to submit a patch ?? :-)
>>>       
>> almost, I was looking into RAID-6 for this, but unfortunately
>> it seems I'll need external manpower too... :-)
>>
>>     
>>> I disagree.  You do need a model.  The particular features of the
>>> model would be the weight and wind-resistance of the person so that
>>> you can estimate what extra wind resistance is needed to reduce terminal
>>> velocity such that the impact will be something that the person's
>>> legs can absorb.  So you also need the model to describe the legs
>>> in enough detail so that a suitable target terminal velocity can
>>> be determined.
>>>       
>> Well, sorry, but IMHO this is needed only when you design
>> the parachute, not when you jump out of the plane.
>>
>> It seems that here some people, including me, would have
>> found useful such a feature.
>> For example I've a RAID-10 which shows a mismatch_cnt of
>> 256, but everything seems to work fine.
>> The disks are new, no SMART errors or else.
>> Where the mismatch belong I do not know.
>> What should I do? Try to fill up the MD device and then
>> see if the mismatch is still there?
>> It would be much better to know which file, if any, is
>> affected and then take the proper countermeasures.
>>
>>     
>
>
> It seems we might have been talking at cross-purposes.
>
> When I wrote about the need for a threat model, it was in the
> context of automatically determining which block was most
> likely to be in error (e.g. voting with a 3-drive RAID1 or
> fancy arithmetic with RAID6).  I do not believe there is any
> value in doing that.  At least not automatically in the kernel
> with the aim of just repairing which block was decided to be
> most wrong.
>   

And on this point I continue to believe you are not going going in the 
wrong direction, but riding the wrong horse. What is the value of having 
a 'repair' operation in the kernel if it makes no effort to fix the 
problem, but instead hides the problem, picks one possible value for the 
contents and writes it everywhere, perhaps because at least occasionally 
the data will be correct? I the case of N-way mirror with N>2, and with 
raid-6, a "most likely" data can be identified, and from data already in 
memory! And the tests appear to be possible calling code which is 
already used for either recovery on actual drive error or to generate P 
and Q values.

To suggest doing it in a non-kernel solution is to say it shouldn't be 
done. The problems being discussed with timing, protecting data from 
changing, etc, all become worse when trying to do this by system calls 
instead of diddling the locks and io queues using the existing kernel code.

The argument that such repair would not be guaranteed correct in all 
cases is true, but given that the current code is guaranteed to be wrong 
a significant percentage of the time, how could taking the obvious steps 
not be better?

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

