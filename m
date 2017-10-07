From: "John Stoffel" <john@stoffel.org>
Subject: Re: mdadm: Patch to restrict --size when shrinking unless forced
Date: Sat, 7 Oct 2017 18:46:02 -0400
Message-ID: <23001.22826.412907.998141@quad.stoffel.home>
References: <22997.8664.67459.119616@quad.stoffel.home>
        <87a81637lq.fsf@notabene.neil.brown.name>
        <F48A217B-C892-4EA7-8451-6056BE92AD02@stoffel.org>
        <59D94FFD.9060404@youngman.org.uk>
        <23001.21117.685622.668977@quad.stoffel.home>
        <59D9571E.8060208@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59D9571E.8060208@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: John Stoffel <john@stoffel.org>, NeilBrown <neilb@suse.com>, Eli Ben-Shoshan <eli@benshoshan.com>, Jes.Sorensen@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Wols" == Wols Lists <antlists@youngman.org.uk> writes:

Wols> On 07/10/17 23:17, John Stoffel wrote:
>>>>>>> "Wols" == Wols Lists <antlists@youngman.org.uk> writes:
>> 
Wols> On 05/10/17 02:26, John Stoffel wrote:
>>>> It's trivial to revert if you know the starting size!  And I would argue that the --size option is misnamed, since is is a per-component resize.  
>>>> 
>>>> In any case, would it be better to print a message which said something like: array md## devices resized from <orig> to <new size>
>>>> 
>> 
Wols> I think a message like "You are setting array space available to
Wols> less than array space used. Use --force if you really want to do
Wols> this".
>> 
>> I think changing the message to say: "Resizing array component size
>> from X to Y." would address a bunch of comments on this thread.  And
>> would give people a way to get back to where they were more easily. 

Wols> Except it does NOT tell the user WHY they are being stupid ...

Ok.  But how much hand holding can we do here?  I see where Neil is
coming from in terms of not stopping people from being stupid.  I just
want to give them help in not making stupid mistakes.

>>>> When the user does this?  But again, I think the --force option is good to have when reducing the size of component devices, sine I would hope the message gives people a pause and hopefully makes them think.
>>>> 
>> 
Wols> I'm with Neil in that you should never have to use force if
Wols> you're doing something sensible. As soon as mdadm says "you need
Wols> to use --force" it should be a warning that something is
Wols> amiss. So only require it if the array needs the space that
Wols> you're reducing away. If you're using 6TB with 3 x 3TB drives,
Wols> then reducing component size to 2.1TB shouldn't trigger a
Wols> warning ...
>> 
>> You're taking both sides of the arguement here!  The question in my
>> mind is really if it's *ever* a good idea to reduce the size of
>> components of an array without an explicit command.  For growing,
>> sure, that's not a problem.  But since we can shrink component (not
>> just the array size!) sizes without warning and destroy people's data,
>> it's upon the tool to at least make some effort to notify them.

Wols> But it's also possible to reduce the size of an array WITHOUT destroying
Wols> peoples' data, and making them use --force here is a bad idea. (See
Wols> below - I've just realised I don't think this is possible.)

But how does mdadm *know* that people won't be destroying their data?
Yes, if they resize the filesystem(s), the logical volumes, the volume
groups, or any upper layers to be smaller, then you can reduce the
component sizes.  But that's a *really* unusual step to take with
RAID1,5 or 6, don't you think?

>>>> So I really don't think we're holding people back, we're educating them with this warning.  
>>>> 
>> 
Wols> Good idea - I just think that the message as you've phrased it
Wols> isn't that educative, sorry.
>> 
>> That's okay, the message needs to be tweaked for sure.  I was just
>> getting out a proof of concept patch.
>> 
Wols> Looking at your current message, it sounds like you're comparing
Wols> current array usage with future array size so that's right - you
Wols> just need a warning that sends a clear "you are about to shoot
Wols> yourself in the foot" message, not just a "use --force to
Wols> suppress this warning".
>> 
>> I agree that both A) the message needs to be improved, and B) the --force
>> option needs to be there when you are shrinking.  Neil didn't like B
>> as much, but I still think that when shrinkinking, we need to be very
>> hesitant to do something without explicit statement from the user,
>> because it's too easy without the new message (to be done still!) to
>> mess up and break things horribly.
>> 
Wols> Let me give a worked explanation of what I'm getting at. A bit
Wols> contrived, and I've suddenly realised I may be muddling my layers of the
Wols> stack, but ...

Wols> What I was thinking was let's say the user created an array with 3 x 2TB
Wols> drives. He then replaces the drives with 3TB drives. So the array is
Wols> only using some of the space available.

Wols> So he increases the component size from 2TB to 3TB - and then changes
Wols> his mind! To me, it makes sense that he should be able to revert that
Wols> change *without* getting a warning. However, as I've just said above,
Wols> I've just realised that might not be possible :-( as mdadm has no way of
Wols> knowing - inbetween the increase and decrease of size - whether the user
Wols> has used other commands to use the new space available.

Exactly!!!!

Wols> So if mdadm can tell that the user is only using 2TB, it shouldn't warn
Wols> when size is reduced. I just don't think it can tell :-(

Correct, it can't know.  So that's why the --force is good in that case.

Wols> So yes, your approach of requiring --force to reduce the component size
Wols> does seem a sensible approach - we just need a clear message. Going on
Wols> about component devices muddies the water imho. Maybe something like
Wols> "WARNING: this command will shrink your array. Have you shrunk the
Wols> contents accordingly? Use --force to apply the change." Bear in mind Eli
Wols> thought he was growing the array (which is what most people will
Wols> expect), a warning that the array is going to shrink should trigger a
Wols> "what the!?" response.

Yes, the message needs to be improved, I agree 100%.  I'll try to whip
up something and send it out for comments.

John

