From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: 3-disk fail on raid-6, examining my options...
Date: Wed, 19 Jul 2017 12:51:43 +0100
Message-ID: <596F47CF.6020007@youngman.org.uk>
References: <07b77b80-4bee-3820-6a0d-3323ef06a3f3@ultratux.net>
 <596E6D72.8050108@youngman.org.uk> <20170718202550.GA2533@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170718202550.GA2533@animx.eu.org>
Sender: linux-raid-owner@vger.kernel.org
To: Wakko Warner <wakko@animx.eu.org>
Cc: Maarten <maarten@ultratux.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 18/07/17 21:25, Wakko Warner wrote:
> Wols Lists wrote:
>> On 18/07/17 18:20, Maarten wrote:
>>> Now from what I've gathered over the years and from earlier incidents, I
>>> have now 1 (one) chance left to rescue data off this array; by hopefully
>>> cloning the bad 3rd-failed drive with the aid of dd_rescue and
>>> re-assembling --force the fully-degraded array. (Only IF that drive is
>>> still responsive and can be cloned)
>>
>> If it clones successfully, great. If it clones, but with badblocks, I
>> keep on asking - is there any way we can work together to turn
>> dd-rescue's log into a utility that will flag failed blocks as "unreadable"?
> 
> I wrote a shell script that will output a device mapper table to do this. 
> It will do either zero or error targets for failed blocks.  It's not
> automatic and does require a block device (loop for files).  I've used this
> several times at work and works for me.
> 
> I'm not sure if this is what you're talking about or not, but if you want
> the script, I'll post it.
> 
I'm not sure I understand what you're saying, but I'm certainly
interested. It'll probably end up on the wiki if that's okay with you?

I'll aim to understand and document it so others will be able hopefully
to use it as a "fire and forget" tool (inasmuch as you can
fire-and-forget any recovery task :-)

What I'm thinking of is a utility that uses "hdparm --make-bad-sector".
The idea being that if you have multiple disk failures, you can at least
clone everything worth having off the broken disks, and then you can run
a "tar . > /dev/null" or do a sync or whatever, and know that if it
reads successfully off the array it isn't corrupt. Unless you're unlucky
enough to have multiple drives fail in the same stripe, you should then
recover your array no problem.

Cheers,
Wol
