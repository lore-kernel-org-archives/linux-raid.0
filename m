From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: md/raid1: Improve another size determination in setup_conf()
Date: Tue, 11 Oct 2016 00:23:36 +1100
Message-ID: <34ed01ab-4cb4-0ae6-0cf4-af847c61a36d@websitemanagers.com.au>
References: <566ABCD9.1060404@users.sourceforge.net>
 <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
 <9831fce9-d689-89e4-dec8-50cadcd13fdd@users.sourceforge.net>
 <CAFLxGvx0Fr-WNvKYACdvNiZwYzHW4ocna9HPH8J_WPSXWc+ngg@mail.gmail.com>
 <20161010110050.GA5687@mwanda>
 <526621dc-ce01-77eb-035d-fd884bf31d2c@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <526621dc-ce01-77eb-035d-fd884bf31d2c@users.sourceforge.net>
Sender: linux-raid-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Markus,

I'm mostly a lurker on this, sometimes trying to help out other users 
when I can. Either way, I'm not a kernel coder, so take my comments with 
a grain of salt...

On 10/10/2016 23:28, SF Markus Elfring wrote:
>> I am ignoring Markus patches
> It's a pity that you chose such a reaction.
Different people will have different priorities, and that's OK.
>> and have told him that he should focus on bug fixes.
> I find that I suggest to improve something. Could you admit a few times
> that I found a "bug" you care also about at other source code places?
Different people will describe a bug differently. Has *any* of your 
patches been accepted on this list yet? Has *any* of them fixed a 
problem that a user encountered?
>> These patches don't add any value
> Can it be that you express a lower value for the Linux coding style here
> than desired as there might be other concerns behind such negative feedback?
Desired by who? Everyone is different. Sure, the coding style is there, 
and if you see a proposed patch which doesn't comply with the coding 
style, then advise everyone involved, and let's fix it before the patch 
goes in.
After the code is already in, most people are more concerned with other 
things (different priorities and all)...
>> and regularly introduce bugs.
> How do you think about to discuss corresponding facts further?
You haven't proposed any facts.... These are just different priorities 
from different people...

>> That said, "sizeof(*ptr)" is sort of official style.
> When this implementation detail is so official, I wonder then why some
> software developers can become "special" about the proposed update step
> like for this module.
It's not special, like I said above, if there is a new patch proposed by 
someone which doesn't meet the coding guidelines, then speak up.....

The problem here is that you don't have a history of providing "useful" 
patches (ie, where other kernel developers can see that you have fixed 
something that was broken/not working). Currently, all they see is that 
you have run some tool over the code, and then thrown together 50 
patches to change a bunch of code that doesn't really make any 
difference....

So, in short, I would guess you are beating a dead horse.Trying to 
create arguments over what is or is not right, better, or whatever is 
also nothing short of divisive and plain rude (whether intended or not). 
I would guess that if you had found one small style issue, and brought 
it up, explained that you were just starting out and found this code 
which doesn't meet the guidelines, you were confused about how it works, 
you think you understand now, but could it be changed to this which is 
easier to understand and matches the guidelines. Then it would probably 
have been accepted.
You would probably then be tempted to go and find the other 200 similar 
patches, and we would be back at this spot, but hopefully, you might 
move onto finding and fixing "harder" problems rather than another 100 
easy ones, and progressively your skills would improve, and everyone on 
the list would be delighted to receive your patches, and discuss them in 
detail.
Leave the other 100 easy patches to the next 100 people who come after 
you and need to start with an easy patch, before they progress toward 
the harder code/logic issues.

Like I said, I don't speak for anyone, and I myself don't like to see 
code with spelling/grammar mistakes, but with open source, while we can 
all help by submitting patches, "someone" needs to verify those patches, 
and so they must meet a certain usefulness criteria for them to "waste" 
their time on them.

PPS, deleted a bunch of CC's that didn't seem relevant, both lists and 
individuals....

Regards,
Adam
