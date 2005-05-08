From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm oddity.
Date: Sun, 8 May 2005 17:52:00 +1000
Message-ID: <17021.50464.326546.696833@cse.unsw.edu.au>
References: <cone.1115508816.149032.5308.500@commodore.email-scan.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Sam Varshavchik on Saturday May 7
Sender: linux-raid-owner@vger.kernel.org
To: Sam Varshavchik <mrsam@courier-mta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday May 7, mrsam@courier-mta.com wrote:
> I noticed a slight oddity on one of my servers: when I start "mdadm 
> --monitor --scan" I get only the "NewArray" message.  On the other server I 
> get a "NewArray" then a "SparesMissing" message, for each RAID partition.  
> Neither server has spares.  Both servers have a pair of SCSI drives in a 
> RAID-1 configuration for all of the partitions.
> 
> Well, the real oddity is actually that the other server only reports a 
> NewArray -- because I see in the ChangeLog mdadm is _supposed_ to report 
> both NewArray and SparesMissing.  But until I turned up the second server I 
> only ever got NewArray from mdadm, so that was something new.
> 
> Investigating this I discovered that I get a SparesMissing message if I 
> explicitly enumerate all my RAID partitions in mdadm.conf (mdadm 1.5.0).  If 
> I don't list my partitions in mdadm.conf, mdadm still finds them, but then 
> reports only a NewArray message.  Does that sound right?
> 
> 

You are only meant to get "SparesMissing" if you have a number of
spare disks recorded in your mdadm.conf (e.g. spares=2) and mdadm find
that the array has fewer than that number.  However a quick look at
the code suggests that if it find the array mentioned in mdadm.conf
and the number of spares isn't given, it will always report
"SparesMissing".
I need to be more consistent about using "-1" or "UnSet" to record
that some value isn't set.  I'll try to rustle up a patch in the next
day or so.

NeilBrown
