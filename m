From: Mike Hardy <mhardy@h3c.com>
Subject: Re: Raid5 with 2 bad drives
Date: Tue, 22 Feb 2005 22:23:39 -0800
Message-ID: <421C216B.8050209@h3c.com>
References: <u650k4kbd.fsf@julius-net.net> <Pine.LNX.4.56.0502221656160.4157@lion.drogon.net> <87fyzoaz31.fsf@julius-net.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <87fyzoaz31.fsf@julius-net.net>
Sender: linux-raid-owner@vger.kernel.org
To: Matthias Julius <jnews@julius-net.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I posted a raid5 parity calculator implemented in perl a while back (a 
couple weeks?) that is capable of taking your disk geometry, the RAID 
LBA you're interested in, and finding the disk sector it belongs to.

I honestly don't remember if it can go the other way, but I'm not sure 
why it couldn't? Its possible that bad blocks may simply be in the 
parity chunk of the stripe too. Once you've got the RAID LBA you can use 
the methods in the BadBlockHowto to find the file

Either way, the math isn't too hard, and the script isn't very 
complicated, but doing that math is the only way I know of to relate the 
bits of data you've got to the file.

-Mike

Matthias Julius wrote:
> Gordon Henderson <gordon@drogon.net> writes:
> 
> 
>>Try something like:
>>
>>  mdadm --assemble /dev/mdY /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 \
>>	--run --force
> 
> 
> --force did the trick.  I could have thought of that one myself.
> Thanks.
> 
> As for not hitting the bad blocks again: Is there a way to find out to
> which file they belong with ext3/xfs on LVM on RAID5?  That would be
> helpfull.
> 
> Matthias
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
