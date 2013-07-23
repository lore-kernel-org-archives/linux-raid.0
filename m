From: Christian Iversen <chrivers@iversen-net.dk>
Subject: Re: Should "mdadm --add" complain if the new device appears to have
 a filesystem on it?
Date: Tue, 23 Jul 2013 12:18:35 +0200
Message-ID: <51EE587B.8060209@iversen-net.dk>
References: <20130723113902.62368e3e@notabene.brown> <alpine.LRH.2.02.1307230734590.12531@praktifix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1307230734590.12531@praktifix.dwd.de>
Sender: linux-raid-owner@vger.kernel.org
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: NeilBrown <neilb@suse.de>, linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2013-07-23 09:41, Holger Kiehl wrote:
> Hello Neil,
>
> first, many many thanks for all your good work on MD and always helping
> us here on this list!
>
> On Tue, 23 Jul 2013, NeilBrown wrote:
>
>>
>> As you probably know, when you use "mdadm -C" to create an array, it will
>> check if the devices appear to contain a filesystem or similar already
>> and
>> will complain if they do - requiring you do say "yes" or use "--run"
>> to avoid
>> the warning.
>>
>> However if you use "--add" to add a device to an existing array no such
>> checks are done.  So it isn't too hard to destroy all those cat photos
>> you
>> have saved on a USB drive (because device names change every time you
>> boot
>> and you got confused).
>>
>>
>> I could easily change "--add" to be more cautious, but that might break
>> existing scripts, which I would rather not do.
>>
>> Or I could add a "policy" line to mdadm.conf which would indicate the
>> policy
>> for "--add" - either "spare" or "force-spare".  But then I would need to
>> decide on a default.  The default should probably be safe otherwise
>> people
>> probably won't change it until they get burned.  So people with
>> scripts would
>> still experience breakage, but could now fix it easily with a "policy"
>> line.
>>
>> Or maybe "--add" should be deprecated so people have to choose between
>> "--re-add" or a new "--spare" with --spare requiring "--force" to destroy
>> data.
>> Then "--add" would generate a deprecation message which scripts could
>> ignore
>> but people might learn from.
>>
>>
>> I don't think there is an obviously-correct answer here so I'm open to
>> suggestions.  What do people think?
>>
> I first thought of a --initialize, but I do not think it is any better.
> So I would vote for the second solution, depreciating --add and using
> --spare plus --force.

If we have to change the options anyway, then I'm more in the mood for 
--add --force for new volumes, and --add for existing ones. It would be 
more in line with what we have now, IMHO.

(please CC, not on the list)

-- 
Med venlig hilsen
Christian Iversen
