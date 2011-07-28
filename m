From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Using the new bad-block-log in md for Linux 3.1
Date: Thu, 28 Jul 2011 10:55:19 +0100
Message-ID: <4E313207.1060600@anonymous.org.uk>
References: <20110727141652.7511fc51@notabene.brown> <j0p0d6$aj6$1@dough.gmane.org> <4E300828.3000601@anonymous.org.uk> <j0p2g2$nmp$1@dough.gmane.org> <20110728065541.3e2d5cac@notabene.brown> <j0r9tp$p96$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <j0r9tp$p96$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Lutz Vieweg <lvml@5t9.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 28/07/2011 10:25, Lutz Vieweg wrote:
> On 07/27/2011 10:55 PM, NeilBrown wrote:
[...]
>> On failure it decides not to write to and more bad blocks on that
>> device.
>
> This sentence may just miss one verb, but that might be an important
> one. Did you mean to say "on failure (of writing to a block that had
> been marked as bad, after a re-assembly) that one block will not be
> written to (until after the next re-assembly)"?

I think the typo was that he meant "any" where he wrote "and": "On 
failure it decides not to write to any more bad blocks on that device".

So after a re-assembly (e.g. when you boot up after fixing your power, 
cable, controller issues) md will try writing to bad blocks again, until 
any such writes fail, after which it will stop trying to write to bad 
blocks on that device. By this method, md can automatically recover from 
spurious write failures caused by temporary issues.

Sorry I got it wrong in the first place, by the way - I'd seen the 
writeable sysfs entries for manipulating the bad block list, so that's 
why I thought there was an administrative interface for clearing it, but 
if that's only there for md/mdadm's internal use and testing, we 
ordinary users had better leave it alone :-)

Cheers,

John.

