From: David Brown <david.brown@hesbynett.no>
Subject: Re: Creating a 3-disk RAID6 array
Date: Fri, 18 May 2012 09:24:23 +0200
Message-ID: <4FB5F927.1030802@hesbynett.no>
References: <4FB4534A.5070608@volatilevoid.net> <20120517113817.7faf9c1e@notabene.brown> <4FB4FAA9.7000100@hesbynett.no> <4FB50573.6020604@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FB50573.6020604@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: NeilBrown <neilb@suse.de>, Oliver Martin <oliver@volatilevoid.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 17/05/2012 16:04, John Robinson wrote:
> On 17/05/2012 14:18, David Brown wrote:
> [...]
>> Theoretically, a 3-disk RAID6 is like a 2-disk RAID5 or a 1-disk RAID1 -
> [...]
>> I can't think of any good reason for it /not/ to support 3-disk
>> RAID6, as there is nothing in the algorithms to hinder it.
>
> I've a vague recollection of Peter Anvin saying the implementation is
> optimised in such a way that it won't work.
>

Okay, optimised implementation is a good reason for not supporting it! 
I only know the theory, I haven't studied the implementation well enough 
yet.  (One day, when I get time... :-)

> Cheers,
>
> John.
>
