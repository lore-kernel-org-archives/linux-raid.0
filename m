From: Luca Berra <bluca@comedia.it>
Subject: Re: Read errors on raid5 ignored, array still clean .. then
	disaster !!
Date: Sat, 30 Jan 2010 08:54:37 +0100
Message-ID: <20100130075436.GA15471@maude.comedia.it>
References: <4B5F6C73.30707@texsoft.it> <20100127074138.GA9607@maude.comedia.it> <20100129214852.00e565c4@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100129214852.00e565c4@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jan 29, 2010 at 09:48:52PM +1100, Neil Brown wrote:
>On Wed, 27 Jan 2010 08:41:38 +0100
>Luca Berra <bluca@comedia.it> wrote:
>
>> On Tue, Jan 26, 2010 at 11:28:03PM +0100, Giovanni Tessore wrote:
>> > Is this some kind of bug?  
>> No
>
>
>I'm not sure I agree.
>If a device is generating lots of read errors, we really should do something
>proactive about that.
>If there is a hot spare, then building onto that while keeping the original
>active (yes, still on the todo list) would be a good thing to do.
>
>v1.x metadata allows the number of corrected errors to be recorded across
>restarts so a real long-term value can be used as a trigger.
uhm, should we use an absolute value here, or should we consider the
ratio of read errors over time. Or both?
the former would indicate a disk that is degrading slowly over time
the latter migh be a symptom of a disk that will die very soon.
we also need to control the threshold on a per device base via sysfs
(eg mdX/md/dev-FOO/maximum_tolerated_read_errors)

>So there certainly are useful improvements that could be made here.
I don't deny that, but i would not define as bugs features that are not
yet designed/implemented.

L.


-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
