From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: mdadm: Patch to restrict --size when shrinking unless forced
Date: Sat, 7 Oct 2017 23:37:18 +0100
Message-ID: <59D9571E.8060208@youngman.org.uk>
References: <22997.8664.67459.119616@quad.stoffel.home>
 <87a81637lq.fsf@notabene.neil.brown.name>
 <F48A217B-C892-4EA7-8451-6056BE92AD02@stoffel.org>
 <59D94FFD.9060404@youngman.org.uk>
 <23001.21117.685622.668977@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <23001.21117.685622.668977@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: NeilBrown <neilb@suse.com>, Eli Ben-Shoshan <eli@benshoshan.com>, Jes.Sorensen@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/10/17 23:17, John Stoffel wrote:
>>>>>> "Wols" == Wols Lists <antlists@youngman.org.uk> writes:
> 
> Wols> On 05/10/17 02:26, John Stoffel wrote:
>>> It's trivial to revert if you know the starting size!  And I would argue that the --size option is misnamed, since is is a per-component resize.  
>>>
>>> In any case, would it be better to print a message which said something like: array md## devices resized from <orig> to <new size>
>>>
> 
> Wols> I think a message like "You are setting array space available to
> Wols> less than array space used. Use --force if you really want to do
> Wols> this".
> 
> I think changing the message to say: "Resizing array component size
> from X to Y." would address a bunch of comments on this thread.  And
> would give people a way to get back to where they were more easily. 

Except it does NOT tell the user WHY they are being stupid ...
> 
>>> When the user does this?  But again, I think the --force option is good to have when reducing the size of component devices, sine I would hope the message gives people a pause and hopefully makes them think.
>>>
> 
> Wols> I'm with Neil in that you should never have to use force if
> Wols> you're doing something sensible. As soon as mdadm says "you need
> Wols> to use --force" it should be a warning that something is
> Wols> amiss. So only require it if the array needs the space that
> Wols> you're reducing away. If you're using 6TB with 3 x 3TB drives,
> Wols> then reducing component size to 2.1TB shouldn't trigger a
> Wols> warning ...
> 
> You're taking both sides of the arguement here!  The question in my
> mind is really if it's *ever* a good idea to reduce the size of
> components of an array without an explicit command.  For growing,
> sure, that's not a problem.  But since we can shrink component (not
> just the array size!) sizes without warning and destroy people's data,
> it's upon the tool to at least make some effort to notify them.

But it's also possible to reduce the size of an array WITHOUT destroying
peoples' data, and making them use --force here is a bad idea. (See
below - I've just realised I don't think this is possible.)
> 
>>> So I really don't think we're holding people back, we're educating them with this warning.  
>>>
> 
> Wols> Good idea - I just think that the message as you've phrased it
> Wols> isn't that educative, sorry.
> 
> That's okay, the message needs to be tweaked for sure.  I was just
> getting out a proof of concept patch.
> 
> Wols> Looking at your current message, it sounds like you're comparing
> Wols> current array usage with future array size so that's right - you
> Wols> just need a warning that sends a clear "you are about to shoot
> Wols> yourself in the foot" message, not just a "use --force to
> Wols> suppress this warning".
> 
> I agree that both A) the message needs to be improved, and B) the --force
> option needs to be there when you are shrinking.  Neil didn't like B
> as much, but I still think that when shrinkinking, we need to be very
> hesitant to do something without explicit statement from the user,
> because it's too easy without the new message (to be done still!) to
> mess up and break things horribly.
> 
Let me give a worked explanation of what I'm getting at. A bit
contrived, and I've suddenly realised I may be muddling my layers of the
stack, but ...

What I was thinking was let's say the user created an array with 3 x 2TB
drives. He then replaces the drives with 3TB drives. So the array is
only using some of the space available.

So he increases the component size from 2TB to 3TB - and then changes
his mind! To me, it makes sense that he should be able to revert that
change *without* getting a warning. However, as I've just said above,
I've just realised that might not be possible :-( as mdadm has no way of
knowing - inbetween the increase and decrease of size - whether the user
has used other commands to use the new space available.

So if mdadm can tell that the user is only using 2TB, it shouldn't warn
when size is reduced. I just don't think it can tell :-(

So yes, your approach of requiring --force to reduce the component size
does seem a sensible approach - we just need a clear message. Going on
about component devices muddies the water imho. Maybe something like
"WARNING: this command will shrink your array. Have you shrunk the
contents accordingly? Use --force to apply the change." Bear in mind Eli
thought he was growing the array (which is what most people will
expect), a warning that the array is going to shrink should trigger a
"what the!?" response.

Cheers,
Wol

