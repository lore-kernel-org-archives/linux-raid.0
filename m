From: berk walker <berk@panix.com>
Subject: Re: Fwd: Linux MD raid5 and reiser4... Any experience ?
Date: Thu, 05 Jan 2006 06:26:36 -0500
Message-ID: <43BD026C.4050705@panix.com>
References: <fd8d0180601050104x15079396h@mail.gmail.com>	<fd8d0180601050106s5f5b4306o@mail.gmail.com> <87oe2r2d93.fsf@rimspace.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87oe2r2d93.fsf@rimspace.net>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Pittman <daniel@rimspace.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Daniel Pittman wrote:

>Francois Barre <francois.barre@gmail.com> writes:
>
>G'day Francois.
>
>  
>
>>Well, I think everything is in the subject... I am looking at this
>>solution for a 6*250GB raid5 data server, evolving in a 12*250 rai5 in
>>the months to come... Performance is absolutely not a big issue for
>>me, but I would not appreciate any data loss.
>>    
>>
>
>If your key interest is data integrity, and you don't care a fig about
>performance, you would be much better off using ext3 on that filesystem.
>
>Depending on the test, ext3 may not do better than other filesystems,
>but it is really quite hard to go past the long history of reliability
>and stability that it has.
>
>It also has extremely good tools for recovering if something /does/ go
>wrong, and is very resilient to damage on the disk.  Reiserfs has,
>historically, had some issues in those areas, especially in recovery
>from corruption.
>
>  
>
>>Furthermore, I would prefer not to use LVM nor any middle layer
>>between MD and the fs... Is this middle layer *very* usefull when I'm
>>sure my partitions layout will not evolve (e.g. only one enormous fs)
>>    
>>
>
>Nope, pretty much no advantage at all, if you are just planning on using
>this to store volume data.
>
>      Daniel
>  
>
Ext3 does have a fine record.  Might I also suggest an added expense of 
18 1/2% and do RAID6 for better protection against data loss?
b-

