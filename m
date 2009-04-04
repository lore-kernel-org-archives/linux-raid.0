From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: RAID halting
Date: Sat, 04 Apr 2009 07:38:28 -0500
Message-ID: <49D754C4.4010702@gmail.com>
References: <20090404071250.NYQP28081.cdptpa-omta04.mail.rr.com@Leslie>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090404071250.NYQP28081.cdptpa-omta04.mail.rr.com@Leslie>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Lelsie Rhorer wrote:
>> This sounds like a filesys problem rather than a RAID problem.
> 
> I considered that.  It may well be.
> 
>> One thing that can cause this sort of behaviour is if the filesystem is in
>> the middle of a sync and has to complete it before the create can
>> complete, and the sync is writing out many megabytes of data.
> 
> For between 40 seconds and 2 minutes?  The drive subsystem can easily gulp
> down 200 megabytes to 6000 megabytes in that period of time.  What synch
> would be that large?  Secondly, the problem occurs also when there is
> relatively little or no data being written to the array.  Finally, unless I
> am misunderstanding at what layers iostat and atop are reporting the
> traffic, the fact all drive writes invariably fall to dead zero during an
> event and reads on precisely half the drives (and always the same drives)
> drop to dead zero suggests to me this is not the case.
> 
> 

If you have things setup such that you have lights on the disks, and 
can check the lights when the event is happening, often if a single 
drive is being slow it will be the only one with its lights on when 
things are going bad.
