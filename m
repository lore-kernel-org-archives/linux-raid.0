From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: [BUG] raid1 behind writes alter bio structure illegally
Date: Wed, 29 Jul 2009 16:18:46 -0400
Message-ID: <4A70AEA6.9030209@steeleye.com>
References: <4A707578.3010901@steeleye.com> <4A707F85.5090008@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A707F85.5090008@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>, kernel list <linux-kernel@vger.kernel.org>, ian.campbell@citrix.com
List-Id: linux-raid.ids

Milan Broz wrote:
> Hi Paul,
> 
> Paul Clements wrote:
>> I've run into this bug on a 2.6.18 kernel, but I think the fix is still 
>> applicable to the latest kernels (even though the symptoms would be 
>> slightly different).
>>
>> Perhaps someone who knows the block and/or SCSI layers well can comment 
>> on the legality of attaching new pages to a bio without fixing up the 
>> internal bio counters (details below)?
> 
>> LVM over raid1 over SCSI/nbd
> 
> Please can you try that backporting of this patch helps?
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=5d84070ee0a433620c57e85dac7f82faaec5fbb3
> 
> (If so, see https://bugzilla.redhat.com/show_bug.cgi?id=512387)

Thanks Milan. I tested the patch and it does fix the issue. I replied to 
the bugzilla report with this information.

--
Paul
