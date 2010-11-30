From: Jan Ceuleers <jan.ceuleers@computer.org>
Subject: Re: Problems after reshaping of Raid5 array
Date: Tue, 30 Nov 2010 20:45:41 +0100
Message-ID: <4CF55465.5070804@computer.org>
References: <AANLkTinUU6Mh-cYbyCF_vL2PzGzFKMcqSZmPULxctquh@mail.gmail.com>	 <20101130084501.702e7486@notabene.brown> <1291101780.15141.4.camel@bellatrix.morrisoft.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1291101780.15141.4.camel@bellatrix.morrisoft.local>
Sender: linux-raid-owner@vger.kernel.org
To: Michele Bonera <mbonera@gmail.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 30/11/10 08:23, Michele Bonera wrote:
>> It appears that the partition you created on the new device started at a
>> multiple of 64K.  When this happen, the superblock at the end of the
>> partition also looks valid when seen at the end of the whole device.
>> Somehow mdadm got confused and choose the whole device (sdc) instead of the
>> partition (sdc1).
>
> I did it and it worked! Thanks a lot Neil!!!

Michele,

Does it survive a reboot?

Jan
