From: Tyler <pml@dtbb.net>
Subject: Re: mdadm oddity.
Date: Sat, 07 May 2005 23:43:53 -0700
Message-ID: <427DB529.6040307@dtbb.net>
References: <cone.1115508816.149032.5308.500@commodore.email-scan.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cone.1115508816.149032.5308.500@commodore.email-scan.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sam Varshavchik <mrsam@courier-mta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You're email isn't entirely clear .. not for me anyways.. First you 
mentioned that it announces the SparesMissing on one server, but not the 
other, then go into saying it does announce it if you explicitly 
enumerate (not sure exactly what you're referring to here) the raid 
partitions in the configuration file, as if it were happening on both?

Regards,
Tyler.

Sam Varshavchik wrote:

> I noticed a slight oddity on one of my servers: when I start "mdadm 
> --monitor --scan" I get only the "NewArray" message.  On the other 
> server I get a "NewArray" then a "SparesMissing" message, for each 
> RAID partition.  Neither server has spares.  Both servers have a pair 
> of SCSI drives in a RAID-1 configuration for all of the partitions.
>
> Well, the real oddity is actually that the other server only reports a 
> NewArray -- because I see in the ChangeLog mdadm is _supposed_ to 
> report both NewArray and SparesMissing.  But until I turned up the 
> second server I only ever got NewArray from mdadm, so that was 
> something new.
>
> Investigating this I discovered that I get a SparesMissing message if 
> I explicitly enumerate all my RAID partitions in mdadm.conf (mdadm 
> 1.5.0).  If I don't list my partitions in mdadm.conf, mdadm still 
> finds them, but then reports only a NewArray message.  Does that sound 
> right?
>
>

