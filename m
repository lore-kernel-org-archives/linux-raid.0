From: David Brown <david.brown@hesbynett.no>
Subject: Re: Recommended sw raid setup
Date: Sun, 03 Jul 2011 22:05:52 +0200
Message-ID: <iuqi30$61d$1@dough.gmane.org>
References: <BANLkTinbBu6zX-6s2NYH5BQvnaJZJYt_BA@mail.gmail.com>	<BANLkTinghqiT4QbBb--X7Eh_RRWnRg_0RQ@mail.gmail.com>	<CACJz6Qv=u0-66hwOEg5AeZ2rWuw2OE10ozUKEQGTbuGn0_fgGg@mail.gmail.com>	<BANLkTing8Ei+najZAFXN_ib0LRmQfS8e9Q@mail.gmail.com>	<iuq8re$kag$1@dough.gmane.org> <CAOscVdKw3UM_dDzac06AE0dwuyUb4GpL29XTWS_HKa1_o9seZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOscVdKw3UM_dDzac06AE0dwuyUb4GpL29XTWS_HKa1_o9seZQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/07/11 21:14, John Obaterspok wrote:
> Hi all,
>
> Thanks for all good answers!
>
> Today I got all my family data spread in hux-flux between medicenter,
> laptops, external disks - no redundancy what so ever.
> I would really like to have a backup solution too, but how do I backup
> 6 TB in a fasion that makes me do it more than the first 5 times?
>
> First I thought about using btrfs with snapshots on the RAID5 as a
> substitute for backups, but that might not be worth it in the sense
> that it doesn't give me much more safety?
>

It's vital that backups are to a different machine or offline disks (for 
protection from software or hardware problems, or user problems), and 
preferably stored in a different place if that's practical (for 
protection from fire and theft).

You can do a lot with a single 2 or 3 TB external disk.  If you find 
you're needing several disks, it's cheaper to get a hot-swap external 
disk holder and a few bare drives (go for a eSATA connection if you can).

For transferring data, use rsync - it will only copy the changes.  If 
you want snapshots of your data, rsync can do that too (or you can use 
rsnapshot or dirvish to automate this if you don't want to learn the 
rsync command line switches).

The ideal arrangement, at least in countries with fast internet access, 
is to have a backup server in a different place and rsync over the internet.

