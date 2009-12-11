From: Joe Landman <landman@scalableinformatics.com>
Subject: Re: RAID 5 build time optimization question and experiments.
Date: Fri, 11 Dec 2009 10:44:36 -0500
Message-ID: <4B2268E4.80905@scalableinformatics.com>
References: <ad15b8920912110655k62c8b6ber8b366731cf1e85f3@mail.gmail.com> <20091211152938.GA5857@cthulhu.home.robinhill.me.uk>
Reply-To: landman@scalableinformatics.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091211152938.GA5857@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Gsacapital!

Robin Hill wrote:
> On Fri Dec 11, 2009 at 02:55:31PM +0000, Cat'Killer wrote:
> 
>> I found a way using Doug Gilbert's great sg3utils to zero all these
>> disks in a very efficient manner, using sgp_dd, at near drive
>> bandwidth, and proceeded to zero all the disks fully in about 4 hours!
>>
>> Once done, I then created a RAID 5 on 10 disks, waited for the rebuild
>> to complete, stopped the array using mdadm, and dumped each of the
>> RAID's components superblocks to files.
>>
> <-snip->
>> The create worked fine and I waited for the rebuild to be complete
>> before stopping the array and dumping the SBs.
>>
>> I then proceeded to write these same superblocks to 10 new similar
>> disks in a different system.
>>
> You could just do the create with --assume-clean, which should take very
> little time at all.  If the drives were zeroed initially then this will
> give you valid parity data.
> 
> Cheers,
>     Robin
> 


-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/jackrabbit
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615
