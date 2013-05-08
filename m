From: Roberto Nunnari <roberto.nunnari@supsi.ch>
Subject: Re: replacing drives
Date: Wed, 08 May 2013 19:20:26 +0200
Message-ID: <518A895A.1030007@supsi.ch>
References: <517A8EB5.8080100@supsi.ch> <20130426155347.GA9928@cthulhu.home.robinhill.me.uk> <5183E592.6020409@supsi.ch> <20130507075340.GA25772@cthulhu.home.robinhill.me.uk> <518A5EF5.5090808@supsi.ch> <20130508151019.GA20347@cthulhu.home.robinhill.me.uk> <518A77CC.2040001@supsi.ch> <20130508170141.GA22065@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130508170141.GA22065@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Nunnari <roberto.nunnari@supsi.ch>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Robin Hill wrote:
> On Wed May 08, 2013 at 06:05:32 +0200, Roberto Nunnari wrote:
>> I'd rather stay on the safe side.. how do I assemble the array if I boot 
>> from a cd?
>>
>> something like:
>>
>> mdadm --scan --assemble --uuid=a26bf396:31389f83:0df1722d:f404fe4c
>>
>> would to the job and let me with a /dev/mdX I will be able to work with 
>> (fsck and resize2fs)?
>>
> That should do it, yes. If not, you can always do it explicitly with:
>     mdadm -A /dev/md0 /dev/sd[abcd]1
> 
> You'd need to double-check what the device names end up as though.
> 
> Cheers,
>     Robin

Thank you. :-)
Robi
