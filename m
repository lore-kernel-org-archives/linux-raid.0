From: Nicolas Michel <be.nicolas.michel@gmail.com>
Subject: Re: Import data from an array coming from another computer
Date: Thu, 6 Jun 2013 17:00:44 +0200
Message-ID: <CAO5znavkSqxqkSjmYtbTmuW7OkEkHexaX8vfohfaVp0asU+8ig@mail.gmail.com>
References: <CAO5znavAuteVhzarkVEDHPOxs4RFx9j0tB51QXj5LUcREJbn=A@mail.gmail.com>
	<20130606145400.GA15336@sam-solutions.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130606145400.GA15336@sam-solutions.com>
Sender: linux-raid-owner@vger.kernel.org
To: Aleh Suprunovich <a.suprunovich@sam-solutions.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It is better but it still doesn't work:
$ mdadm --assemble /dev/md1 --run /dev/sdc1
mdadm: failed to RUN_ARRAY /dev/md1: Input/output error
mdadm: Not enough devices to start the array.


2013/6/6 Aleh Suprunovich <a.suprunovich@sam-solutions.com>:
> On Thu, Jun 06, 2013 at 05:47:33PM +0300, Nicolas Michel wrote:
>> Hello guys,
>>
>> I need some help to recover some data that resides on a disk that was
>> part of an array in an Iomega device. I connected the disk with a
>> SATA->USB connector to my computer. An mdadm --examine give me theses
>> informations:
>>
>> What I cannot achieve is to create a newly empty array and insert that
>> existing disk inside of it, so I can backup the data elsewhere.
>>
>> I tried with mdadm --assemble /dev/sdc1 but it says:
>>     mdadm: device /dev/sdc1 exists but is not an md array.
>>
>> I someone have an idea? It would be really really great :)
>>
>
> You need to run something like 'mdadm --assemble /dev/md127 --run /dev/sdc1'
> where md127 is a name of md device not used in your system.



-- 
Nicolas MICHEL
