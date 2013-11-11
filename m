From: Tommy Apel <tommyapeldk@gmail.com>
Subject: Re: recommending RAID6 over RAID5 when doing mdadm --create
Date: Mon, 11 Nov 2013 10:37:14 +0100
Message-ID: <CAGA4a+E-QXnsubz+TysnqjoHU1813FQcZhRSL8qfiB0=FySAHQ@mail.gmail.com>
References: <alpine.DEB.2.02.1311110841340.26054@uplift.swm.pp.se>
	<52809BC5.2010605@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52809BC5.2010605@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid Raid <linux-raid@vger.kernel.org>, Tommy Apel <tommyapeldk@gmail.com>
List-Id: linux-raid.ids

2013/11/11 Stan Hoeppner <stan@hardwarefreak.com>:
> On 11/11/2013 1:44 AM, Mikael Abrahamsson wrote:
>
>> I believe this has been discussed before, but I would like to bring it
>> up again.
>>
>> I would like to see mdadm recommend RAID6 over RAID6 when using
>> component drives that are 500GB or larger and ask if the user is really
>> sure about using RAID5, plus a pointer to a webpage on the wiki
>> informing the user about the trouble with RAID5 on large volumes with
>> consumer or prosumer drives.
>>
>> I am willing to contribute text to the webpage being pointed to.
>
> Wikis change to regularly, too easily.  Networks can be down at times,
> often the worst times.  See Murphy's Law.
>
> It would be better to put this information in mdadm(8) and refer the
> user there.
>
> --
> Stan
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Good point Stan,
maybe even "are you sure you really want to do this? (see mdadm(8) for
further information)" when creating the array

-- 

/Tommy
