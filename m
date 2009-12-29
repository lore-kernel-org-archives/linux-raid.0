From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Raid 5 to 6 is it do-able/safe?
Date: Tue, 29 Dec 2009 13:31:47 +0000
Message-ID: <4B3A04C3.5070804@anonymous.org.uk>
References: <305721.15040.qm@web51302.mail.re2.yahoo.com> <alpine.DEB.1.10.0912291308010.27231@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0912291308010.27231@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Jon@eHardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 29/12/2009 12:08, Mikael Abrahamsson wrote:
> On Tue, 29 Dec 2009, Jon Hardcastle wrote:
> 
>> I run gentoo with kernel 2.6.22-gentoo-r8
>>
>> to convert my 6 drive +1 spare raid 5 to a 7 drive raid 6?
> 
> No, you need at least kernel 2.6.32 to migrate from raid5 to raid6.

But if you don't want to run 2.6.32 permanently/on your live system, 
iirc you can just run it to do the migration, and once the migration and 
reshape have completed, you can go back to your production kernel.

Having said that, 2.6.22's a bit old and I don't see it listed on 
Gentoo's package web site, so you might think of updating to something 
more recent anyway.

Cheers,

John.

