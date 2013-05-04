From: Andreas Boman <aboman@midgaard.us>
Subject: Re: Failed during rebuild (raid5)
Date: Sat, 04 May 2013 07:29:15 -0400
Message-ID: <5184F10B.10803@midgaard.us>
References: <51839E4F.7050102@midgaard.us> <CANU9nTneT2CRWJhdN=d87Hb7W9M+apQH+fRE-S+sieZ-W6+hjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANU9nTneT2CRWJhdN=d87Hb7W9M+apQH+fRE-S+sieZ-W6+hjg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ole Tange <tange@binf.ku.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/03/2013 08:26 AM, Ole Tange wrote:
> On Fri, May 3, 2013 at 1:23 PM, Andreas Boman<aboman@midgaard.us>  wrote:
>
>> This morning I came up to see the array degraded with two missing drives,
>> another failed during the rebuild.
> I just started this page for dealing with situations like yours:
> https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID
>
>
> /Ole
Thanks Ole, that is a great resource. Thanks to everybody else who 
offered advise as well. I'll be getting new disks coming in today and 
will try to recover.

I didn't mean to set of a contentious debate about default behavior of 
mdadm. However having an option where mdadm can 'try harder' to complete 
would be a good thing. It should probably remain an option to prevent 
further beating on the disk and thus further data loss for those that 
would prefer to remove the disk and clone it before trying to restore.

/Andreas




