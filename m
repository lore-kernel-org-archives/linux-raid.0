From: Giovanni Tessore <giotex@texsoft.it>
Subject: Re: recommending RAID6 over RAID5 when doing mdadm --create
Date: Tue, 12 Nov 2013 08:12:37 +0100
Message-ID: <5281D4E5.6080304@texsoft.it>
References: <alpine.DEB.2.02.1311110841340.26054@uplift.swm.pp.se>	<52809BC5.2010605@hardwarefreak.com> <20131112135243.285834fa@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131112135243.285834fa@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/12/2013 03:52 AM, NeilBrown wrote:
> On Mon, 11 Nov 2013 02:56:37 -0600 Stan Hoeppner <stan@hardwarefreak.com>
> wrote:
>
>> On 11/11/2013 1:44 AM, Mikael Abrahamsson wrote:
>>
>>> I believe this has been discussed before, but I would like to bring it
>>> up again.
>>>
>>> I would like to see mdadm recommend RAID6 over RAID6 when using
>>> component drives that are 500GB or larger and ask if the user is really
>>> sure about using RAID5, plus a pointer to a webpage on the wiki
>>> informing the user about the trouble with RAID5 on large volumes with
>>> consumer or prosumer drives.
>>>
>>> I am willing to contribute text to the webpage being pointed to.
>> Wikis change to regularly, too easily.  Networks can be down at times,
>> often the worst times.  See Murphy's Law.
>>
>> It would be better to put this information in mdadm(8) and refer the
>> user there.
>>
> .. or in md(4) maybe.
>
> If anyone wants to run with this and send me a patch (for code and
> documentation) I would be very likely to apply it.
>
> NeilBrown

That issue (RAID5 going fully down during resync of degraded array if 
read errors occur) hasn't been addressed by the badblocks log feature 
available in later kernels and mdadm ?
Yet, it is not clear to me if the fetaure is fully implemented and 
operational.

Regards
Giovanni

