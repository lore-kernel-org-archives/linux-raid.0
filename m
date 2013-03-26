From: Maurice Hilarius <maurice@harddata.com>
Subject: Re: Creating a RAID10 (near) for use in a CentOS 6 system
Date: Mon, 25 Mar 2013 18:47:10 -0600
Message-ID: <5150F00E.4060506@harddata.com>
References: <515089B1.9010607@gmail.com> <51509025.2060402@gmail.com> <CC7A8866-EC41-48C7-9E92-25AE51E61D67@colorremedies.com> <5150DC08.8000702@gmail.com> <4C0D23B0-8ABA-4086-BF42-774EF7F0C817@colorremedies.com> <5150E665.2090902@gmail.com> <843EA420-6F4A-41DF-BDED-7F35D6263A87@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <843EA420-6F4A-41DF-BDED-7F35D6263A87@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 3/25/2013 6:40 PM, Chris Murphy wrote:
> On Mar 25, 2013, at 6:05 PM, maurice <mhilarius@gmail.com> wrote:
>> What about partitioning the drives first, installing a smallish partition for boot, then a second much larger partition on each for the RAID10?
> What's the advantage of this compared to a separate drive? In your proposed scenario, if the /boot drive dies, you have an unbootable system anyway.
Firstly, there would be 4 redundant copies of the boot. Easy enough to 
accomplish. If any one goes down, easy to pick one of the others.
Secondly, there is only room for 4 drives in this chassis
Thirdly, cost

Now, back to my original question:
Making the RAID10, near.
In reading the man pages, it seems near 2 is the default option for create?

Is there any reason to be wary of the stock CentOS 6 2.6.32 kernel?


-- 
Cheers,
Maurice Hilarius
eMail: /mhilarius@gmail.com/
