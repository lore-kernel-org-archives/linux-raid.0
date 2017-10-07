From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: mdadm: Patch to restrict --size when shrinking unless forced
Date: Sat, 7 Oct 2017 23:06:53 +0100
Message-ID: <59D94FFD.9060404@youngman.org.uk>
References: <22997.8664.67459.119616@quad.stoffel.home>
 <87a81637lq.fsf@notabene.neil.brown.name>
 <F48A217B-C892-4EA7-8451-6056BE92AD02@stoffel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F48A217B-C892-4EA7-8451-6056BE92AD02@stoffel.org>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>, NeilBrown <neilb@suse.com>
Cc: Eli Ben-Shoshan <eli@benshoshan.com>, Jes.Sorensen@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/10/17 02:26, John Stoffel wrote:
> It's trivial to revert if you know the starting size!  And I would argue that the --size option is misnamed, since is is a per-component resize.  
> 
> In any case, would it be better to print a message which said something like: array md## devices resized from <orig> to <new size>
> 
I think a message like "You are setting array space available to less
than array space used. Use --force if you really want to do this".

> When the user does this?  But again, I think the --force option is good to have when reducing the size of component devices, sine I would hope the message gives people a pause and hopefully makes them think.
> 
I'm with Neil in that you should never have to use force if you're doing
something sensible. As soon as mdadm says "you need to use --force" it
should be a warning that something is amiss. So only require it if the
array needs the space that you're reducing away. If you're using 6TB
with 3 x 3TB drives, then reducing component size to 2.1TB shouldn't
trigger a warning ...

> So I really don't think we're holding people back, we're educating them with this warning.  
> 
Good idea - I just think that the message as you've phrased it isn't
that educative, sorry.

Looking at your current message, it sounds like you're comparing current
array usage with future array size so that's right - you just need a
warning that sends a clear "you are about to shoot yourself in the foot"
message, not just a "use --force to suppress this warning".

Cheers,
Wol

> Sent from my iPhone
> 
>> On Oct 4, 2017, at 5:50 PM, NeilBrown <neilb@suse.com> wrote:
>>
>>> On Wed, Oct 04 2017, John Stoffel wrote:
>>>
>>> Since Eli had such a horrible experience where he shrunk the
>>> individual component raid device size, instead of growing the overall
>>> raid by adding a device, I came up with this hacky patch to warn you
>>> when you are about to shoot yourself in the foot.
>>>

