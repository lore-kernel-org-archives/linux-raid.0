From: Brendan Conoboy <blc@redhat.com>
Subject: Re: "raid" versions of hard drives for software raid?
Date: Wed, 02 Jul 2008 14:37:52 -0600
Message-ID: <486BE720.3090507@redhat.com>
References: <873amsqbag.fsf@uwo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <873amsqbag.fsf@uwo.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Christensen <jdc@uwo.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dan Christensen wrote:
> I'm looking at either the Western Digital 500G RE2 drives or the cheaper
> 500G SE16 drives.  I have read that for use with a hardware raid card,
> the RE2 drives are more appropriate, and I'm wondering if the same is
> true for software raid.

It's a mechanical property- vibration tolerance and whatnot.  No 
difference between software and hardware raid in this sense.

> I am planning to get two drives, and may use the entire drives as RAID1,
> or I might partition the drives and use most of the partitions in a
> RAID1 configuration, but leave a few of the partitions without RAID.
> 
> Suggestions appreciated (even suggestions for another drive I should
> consider).
> 
> I do like the 5 year warranty on the RE2 drives and the increased MTBF,
> as I do have a long history of drive failures...

I have 5 400GB RE2 drives in a RAID5 array (software raid, naturally). 
That 5 year warranty has come in handy- only 1 of the original drives 
still remains.  5 RMAs in under 3 years.  Maybe the 500GB is better.

-- 
Brendan Conoboy / Red Hat, Inc. / blc@redhat.com
