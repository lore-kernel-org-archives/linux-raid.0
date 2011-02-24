From: David Brown <david@westcontrol.com>
Subject: Re: high throughput storage server?
Date: Thu, 24 Feb 2011 12:24:54 +0100
Message-ID: <ik5f7j$kuk$1@dough.gmane.org>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com> <Pine.GSO.4.64.1102181429201.7398@montezuma.acc.umu.se> <4D5EFDD6.1020504@hardwarefreak.com> <Pine.GSO.4.64.1102211116030.7398@montezuma.acc.umu.se> <4D62DE55.8040705@hardwarefreak.com> <ijvtqg$pke$1@dough.gmane.org> <4D63BC6D.8010209@hardwarefreak.com> <ik0gkm$nn$1@dough.gmane.org> <4D64A082.9000601@hardwarefreak.com> <ik33nt$fd8$1@dough.gmane.org> <4D6577E4.2080305@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D6577E4.2080305@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23/02/2011 22:11, Stan Hoeppner wrote:
> David Brown put forth on 2/23/2011 7:56 AM:
>
>> However, as disks get bigger, the chance of errors on any given disk is
>> increasing.  And the fact remains that if you have a failure on a RAID10
>> system, you then have a single point of failure during the rebuild
>> period - while with RAID6 you still have redundancy (obviously RAID5 is
>> far worse here).
>
> The problem isn't a 2nd whole drive failure during the rebuild, but a
> URE during rebuild:
>
> http://www.zdnet.com/blog/storage/why-raid-5-stops-working-in-2009/162
>

Yes, I've read that article - it's one of the reasons for always 
preferring RAID6 to RAID5.

My understanding of RAID controllers (software or hardware) is that they 
consider a drive to be either "good" or "bad".  So if you get an URE, 
the controller considers the drive "bad" and ejects it from the array. 
It doesn't matter if it is an URE or a total disk death.

Maybe hardware RAID controllers do something else here - you know far 
more about them than I do.

The idea of the md raid "bad block list" is that there is a medium 
ground - you can have disks that are "mostly good".

Supposing you have a RAID6 array, and one disk has died completely.  It 
gets replaced by a hot spare, and rebuild begins.  As the rebuild 
progresses, disk 1 gets an URE.  Traditional handling would mean disk 1 
is ejected, and now you have a double-degraded RAID6 to rebuilt.  When 
you later get an URE on disk 2, you have lost data for that stripe - and 
the whole raid is gone.

But with bad block lists, the URE on disk 1 leads to a bad block entry 
on disk 1, and the rebuild continues.  When you later get an URE on disk 
2, it's no problem - you use data from disk 1 and the other disks. 
URE's are no longer a killer unless your set has no redundancy.


URE's are also what I worry about with RAID1 (including RAID10) 
rebuilds.  If a disk has failed, you are right in saying that the 
chances of the second disk in the pair failing completely are tiny.  But 
the chances of getting an URE on the second disk during the rebuild are 
not negligible - they are small, but growing with each new jump in disk 
size.

With md raid's future bad block lists and hot replace features, then an 
URE on the second disk during rebuilds is only a problem if the first 
disk has died completely - if it only had a small problem, then the "hot 
replace" rebuild will be able to use both disks to find the data.

>> I don't know if you've followed the recent "md road-map: 2011" thread (I
>> can't see any replies from you in the thread), but that is my reference
>> point here.
>
> Actually I haven't.  Is Neil's motivation with this RAID5/6 "mirror
> rebuild" to avoid the URE problem?
>

I know you are more interested in hardware raid than software raid, but 
I'm sure you'll find some interesting points in Neil's writings.  If you 
don't want to read through the thread, at least read his blog post.

<http://neil.brown.name/blog/20110216044002>

>> Incidentally, what's your opinion on a RAID1+5 or RAID1+6 setup, where
>> you have a RAID5 or RAID6 build from RAID1 pairs?  You get all the
>> rebuild benefits of RAID1 or RAID10, such as simple and fast direct
>> copies for rebuilds, and little performance degradation.  But you also
>> get multiple failure redundancy from the RAID5 or RAID6.  It could be
>> that it is excessive - that the extra redundancy is not worth the
>> performance cost (you still have poor small write performance).
>
> I don't care for and don't use parity RAID levels.  Simple mirroring and
> RAID10 have served me well for a very long time.  They have many
> advantages over parity RAID and few, if any, disadvantages.  I've
> mentioned all of these in previous posts.
>


