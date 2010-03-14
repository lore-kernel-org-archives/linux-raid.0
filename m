From: Keld Simonsen <keld@keldix.com>
Subject: Re: md devices: Suggestion for in place time and checksum within the RAID
Date: Sun, 14 Mar 2010 14:03:48 +0100
Message-ID: <20100314130348.GA14141@light.rap.dk>
References: <4B9C1915.9080009@gmx.net> <4B9C2800.7070802@tmr.com> <4B9C3B12.5070401@gmx.net> <20100314102049.GB13486@light.rap.dk> <4B9CCF7A.4010809@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B9CCF7A.4010809@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Joachim Otahal <Jou@gmx.net>
Cc: Bill Davidsen <davidsen@tmr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Mar 14, 2010 at 12:58:50PM +0100, Joachim Otahal wrote:
> Keld Simonsen schrieb:
> >On Sun, Mar 14, 2010 at 02:25:38AM +0100, Joachim Otahal wrote
> >>>>Question:
> >>>>Will RAID4/5/6 in the future use the parity upon read too? Currently
> >>>>it would not detect wrong data reads from the parity chunk, resulting
> >>>>in a disaster when it is actually needed.
> >>>>
> >>>>Do those plans already exist and my post was completely useless?
> >>>>
> >>>>Sorry that I cannot give patches, my last kernel patch + compile was
> >>>>2.2.26, since then I never compiled a kernel.
> >>>>
> >>>>Joachim Otahal
> >>>>         
> >Hmm, would that not be detected by a check - initiated by cron?
> >   
> Debian schedules a monthly check (first sunday 00:57), IMHO the best 
> possible time and frequency, less is dangerous, more is useless. I added 
> a cronjob to check every 15 minutes for changes from /proc/mdstat and 
> changes from smart info (reallocated sector count and drive internal 
> error list only) and emails me if something changed from the previous check.
> I use the script because /etc/mdadm/mdadm.conf only takes ONE email 
> address and requires a local MTA installed, I allways uninstall the 
> local MTA if the machine is not going to be a mail server.

Interesting! I would like to see your scripts....

> But why not checking parity during normal read operation? Was that a 
> performance decision?

I don't know, but I do think it would hurt performance considerably.


> It is not _that_ bad not doing it during normal 
> operation since the good dists schedule a regular check, but can it be 
> controlled by something like echo "1" > 
> /proc/sys/dev/raid/always_read_parity ?

Well, I think making an optional check would be fine.
I dont know if it could be done in a non-performance hurting way, such
as being deleyed or running at a lower IO priority.

> >Which data to believe could then be determined according to a number
> >of techniques, like for a 3 copy array the best 2 out of 3,
> >investigating the error log of the drives, and relaying the error
> >information to the file system layer for manual inspection and repair.
> >   
> That is a matter of "believe" and "best guess" and not "knowing" which 
> contains the correct data in redundant array levels, hence the 
> suggestion from before to include a timer + ECC (or better) at the raid 
> level, so we actually _know_ which is the newest, and we _know_ which 
> stripe does have consistent data, no guessing needed, we can apply 
> crystal clear rules.
> My ruleset would be:
> first use: newest time and correct ECC
> second use: newest time and correctable ECC
> third use: any time and correct ECC (hint possible filesystem error to 
> the lext layer)
> fourth use: any time and correctable ECC (hint possible filesystem error 
> to the lext layer)
> fifth use: Current implementation, use the data from the active drive 
> ordering according to the list in the superblock + hint possible 
> filesystem error to the lext layer.
> A raid aware filesystem would be perfect (compare with ZFS on Solaris) 
> eliminating the write hole problem, doing the checksum at raid level 
> makes it more flexible.

Interesting ideas

> >I would expect this is not something that occurs frequently, so maybe
> >once a year for the unlucky or systems with many disks.
> >   
> If you get paranoid about corrupting really important data once in 5 
> years too much. Implementing the checksum + timestamp would lift linux 
> software raid to the next level, closer to enterprise where such 
> techniques are actually in use. At it's current level it is very good 
> and solid, so it is time to get to the next level for long time archiving.

I was not trying to say this is not important, but rather that error
correction could be done by manual intervention, given that is not so
frequent. Or at least that manual corrction should be one of the
impelemted ways of adressing it.

best regards
keld
