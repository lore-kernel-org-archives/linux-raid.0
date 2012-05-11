From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: and again: broken RAID5
Date: Fri, 11 May 2012 11:28:57 +0100
Message-ID: <4FACE9E9.2060902@anonymous.org.uk>
References: <4FAB7739.9000907@cgv.tugraz.at> <20120510192016.49cb9003@notabene.brown> <4FAB9632.5010206@anonymous.org.uk> <20120510204516.16571810@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120510204516.16571810@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/05/2012 11:45, NeilBrown wrote:
> On Thu, 10 May 2012 11:19:30 +0100 John Robinson
> <john.robinson@anonymous.org.uk>  wrote:
>
>> On 10/05/2012 10:20, NeilBrown wrote:
[...]
>>> Just add --force the to --assemble command.
>>
>> I think I'd assemble from only 3 drives, sdh, sdf and sdj, because sdi's
>> event count is so much lower it must be the one that was knocked out
>> first and you probably want to resync onto it (or a fresh drive if it's
>> actually faulty).
>
> correct.  And that is exactly what "mdadm --assemble --force" will decide
> too. :-)
> It will assemble from h, f, j and exclude i.

Ah - I didn't know it was clever enough to do that, I had assumed that 
if you forced all the drives they'd all be marked up-to-date.

What should I do if I had 3 different event counts (like this case) all 
fairly close to each other (unlike this case) and I really did want to 
force them all, avoiding a resync?

Cheers,

John.
