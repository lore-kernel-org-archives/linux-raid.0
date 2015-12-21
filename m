From: Tejas Rao <raot@bnl.gov>
Subject: Re: clustered MD - beyond RAID1
Date: Mon, 21 Dec 2015 14:19:32 -0500
Message-ID: <567850C4.30108@bnl.gov>
References: <56742652.5040304@nasa.gov>
 <87si2w66tm.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87si2w66tm.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, Scott Sinno <scott.sinno@nasa.gov>, linux-raid@vger.kernel.org
Cc: "Knister, Aaron S. (GSFC-606.2)[COMPUTER SCIENCE CORP]" <aaron.s.knister@nasa.gov>
List-Id: linux-raid.ids

What if the application is doing the locking and making sure that only 1 
node writes to a md device at a time? Will this work? How are rebuilds 
handled? This would be helpful with distributed filesystems like 
GPFS/lustre etc.

Tejas.

On 12/20/2015 18:25, NeilBrown wrote:
> On Sat, Dec 19 2015, Scott Sinno wrote:
>
>> Neil(or anyone well informed in mdadm development roadmaps),
>> 	
>> 	Aaron and myself are engineers at NASA Goddard with strong interest in
>> MDADM.  We currently host 6PB(raw) of live JBOD storage leveraging MDADM
>> exclusively for RAID functionality.
>>
>> 	We're very interested in Clustered MDADM to improve data-availability
>> in the environment, but note that only RAID1 is currently supported.
>> Are there plans in the nearish-term(say over the next year) to expound
>> clustered bitmap functionality to RAID5/6, or anything else you can
>> divulge on that front?  Thanks in advance for any guidance.
> We don't talk about plans that are not backed by code - you can't trust
> them.
>
> However I cannot imagine how you could make RAID5 work efficiently in a
> cluster.
> RAID1 works because we assume that the file system will have its own
> locking to ensure that only one node writes to a given block at a given
> time.  So while node-A is writing to a block, RAID1 knows that no other
> node is writing there so it can update all copies and be sure no race
> will result in the copies being inconsistent.
>
> For this to work with RAID5 we would need to assume the filesystem will
> ensure only one node is writing to a given stripe at a time, and that is
> not realistic.
>
> So to make it work we would need the md layer to lock each stripe during
> an update.  I have trouble imagining that running with much speed.  Hard
> to know without testing of course.
> I know of no-one with plans to do that testing.
>
> NeilBrown

