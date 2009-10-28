From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: md software raid
Date: Wed, 28 Oct 2009 10:08:33 -0500
Message-ID: <4AE85E71.30807@redhat.com>
References: <70ed7c3e0910271747o29e53a69l2b88de8d538284aa@mail.gmail.com> 	<20091028005303577.NTSS9287@cdptpa-omta02.mail.rr.com> <70ed7c3e0910271758r3f10b79fw99375299ed721f1e@mail.gmail.com> <4AE7955B.3020501@sauce.co.nz> <4AE76D98.7000003@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AE76D98.7000003@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Richard Scobie <richard@sauce.co.nz>, "Majed B." <majedb@gmail.com>, Leslie Rhorer <lrhorer@satx.rr.com>, linux-raid@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Eric Sandeen <esandeen@redhat.com>, Dave Chinner <david@fromorbit.com>
List-Id: linux-raid.ids

Ric Wheeler wrote:
> On 10/27/2009 08:50 PM, Richard Scobie wrote:
>> Majed B. wrote:
>>> Indeed xfs_repair doesn't require the abusive amount of memory
>>> xfs_check requires.
>>>
>>> I've been a happy XFS user for a few years now, but the fact the
>>> xfsprogs aren't being maintained properly and xfs_check is still a
>>> failure, I'm considering other alternatives.
>>
>> This should change soon, see the September entry:
>>
>> http://xfs.org/index.php/XFS_Status_Updates
>>
>> "On the userspace side a large patch series to reduce the memory usage 
>> in xfs_repair to acceptable levels was posted, but not yet merged."
>>
>> Regards,
>>
>> Richard
> 
> There are several people still actively working on both XFS & its tools 
> and I am sure that they are interested in hearing about issues :-)
> 
> ric
> 


FWIW, this is merged now, but not yet in a usable release.

Still, existing xfs_repair has much better memory footprint than 
xfs_check, and it is the tool you want to use whether you are just 
checking (with -n) or repairing.

xfs_check is more or less deprecated; it is known to have large memory 
requirements, and xfs_repair is the tool to use.

-Eric
