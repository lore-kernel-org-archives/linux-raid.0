From: TomK <tk@mdevsys.com>
Subject: Re: [ LR] Kernel 4.8.4: INFO: task kworker/u16:8:289 blocked for more
 than 120 seconds.
Date: Mon, 31 Oct 2016 22:40:58 -0400
Message-ID: <bf8964fa-9279-6c69-9425-9e1bea89abbf@mdevsys.com>
References: <20161030021614.asws67j34ji64qle@merlins.org>
 <20161030093337.GA3627@metamorpher.de> <20161030153857.GB28648@merlins.org>
 <20161030161929.GA5582@metamorpher.de>
 <f6b83548-cb8b-be21-ee4f-cae9f7fa2950@turmel.org>
 <73e35e17-80aa-c7e6-535c-3665d9789e16@mdevsys.com>
 <58179B9F.8090809@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <58179B9F.8090809@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/31/2016 3:29 PM, Wols Lists wrote:
> On 30/10/16 18:56, TomK wrote:
>>
>> We did not do a thorough R/W test to see how the error and bad disk
>> affected the data stored on the array but did notice pauses and
>> slowdowns on the CIFS share presented from it with pauses and generally
>> difficulty in reading data, however no data errors that we could see.
>> Since then we replaced the 2TB Seagate with a new 2TB WD and everything
>> is fine even if the array is degraded.  But as soon as we put in this
>> bad disk, it degraded to it's previous behaviour.  Yet the array didn't
>> catch it as a failed disk until the disk was nearly completely
>> inaccessible.
>
> What is this 2TB Seagate? A Barracuda? There's your problem, quite
> possibly. Sounds like you've got your timeouts correctly matched, so
> this drive is responding, but taking ages to do so. And that's why it
> doesn't get kicked, but it knackers system response times - the kernel
> is correctly configured to wait for the geriatric to respond.
>
> Cheers,
> Wol
>

Hey Wols,

It's about a 2-3 year old Seagate but not a Barracuda.  They did not 
come with high ratings back then.  I also do adjust other recommended 
settings like write caches etc.

With the previous answer provided by Andreas, I got a very good picture 
what scope of issues RAID should cover and what is not.

So rightly so there is a gap where RAID will not cover all disk failures 
while the disk may impact the applications sitting on top of the array.

Where I was going with this as well is to help me identify what other 
tools I may need in solutions that use RAID.  In this case the answer 
Andreas provided tells me I have to have specific software for disk 
monitoring to the array that would tell me potential issues ahead of 
time alongside the RAID.

On a side note, I like to see the RAID mailing lists so busy.  If I were 
to read the various blog posts, I would believe RAID died 5 years ago.  :)

-- 
Cheers,
Tom K.
-------------------------------------------------------------------------------------

Living on earth is expensive, but it includes a free trip around the sun.

