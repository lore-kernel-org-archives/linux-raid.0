From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Force parity resync on raid5?
Date: Thu, 12 Aug 2004 11:22:07 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408121522.i7CFM7311834@watkins-home.com>
References: <411B6310.9000406@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <411B6310.9000406@dgreaves.com>
To: 'David Greaves' <david@dgreaves.com>
Cc: 'Gordon Henderson' <gordon@drogon.net>, 'Philip Molter' <philip@corp.texas.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You were using skip/seek wrong.
This is just pseudo code?  I use bash or ksh, you can't do "n=n+1".
You don't ever end, again pseudo code I assume.
I would only do this if the filesystem on md0 is not mounted.

Guy

n=0
while
  dd if=/dev/md0 of=/tmp/block count=x_for_efficiency skip=n
  dd of=/dev/md0 if=/tmp/block count=x_for_efficiency seek=n
  n=n+1
loop

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of David Greaves
Sent: Thursday, August 12, 2004 8:31 AM
To: Guy
Cc: 'Gordon Henderson'; 'Philip Molter'; linux-raid@vger.kernel.org
Subject: Re: Force parity resync on raid5?

what about
n=0
while
  dd if=/dev/md0 of=/tmp/block count=x_for_efficiency seek=n
  dd of=/dev/md0 if=/tmp/block count=x_for_efficiency seek=n
  n=n+1
loop

?

This would read the good data and force a rewrite - would you need to 
stop any optimisers?

David

Guy wrote:

>Ouch!  No!!
>
>This would re-build data from parity!!!
>He thinks his parity is bad.
>He wants to re-build the parity from the data!
>I don't know if this can even be done!
>Recovering from a power failure does force a re-build (2.4), but from what
I
>remember the system looks like it is re-building a failed disk, which is
not
>what he wants to do.  If the parity was good, re-building any 1 disk would
>be fine.
>
>Guy
>
>-----Original Message-----
>From: linux-raid-owner@vger.kernel.org
>[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Gordon Henderson
>Sent: Tuesday, August 10, 2004 5:04 AM
>To: Philip Molter
>Cc: linux-raid@vger.kernel.org
>Subject: Re: Force parity resync on raid5?
>
>On Mon, 9 Aug 2004, Philip Molter wrote:
>
>  
>
>>How do I force a parity resync on a raid5 array?  Under 2.4, I would do
>>this by hard cycling the box and when it came back up, it would
>>automatically resync the array.  Under 2.6, this appears to have gone
>>    
>>
>away.
>
>I don't know about 2.6, (still living with 2.4) but can't you simply do:
>
>  raidhotremove /dev/mdX /dev/hdYZ
>
>followed by
>
>  raidhotadd /dev/mdX /dev/hdYZ
>
>or /dev/sdYZ if SCSI disks...
>
>However, picking the right disk to remove might be tricky... And if you
>were at all unsure about data on the disks, maybe rebooting and doing a
>hard fsck of the partition(s) in maintenance mode might be a good thing
>too...
>
>Good luck!
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>  
>

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

