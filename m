From: Robert Heinzmann <Robert.Heinzmann@gmx.net>
Subject: Re: Migrating from SINGLE DISK to RAID1
Date: Tue, 01 Feb 2005 22:40:56 +0100
Message-ID: <41FFF768.9000706@gmx.net>
References: <41FFD1F8.3010101@gmx.net> <41FFD9C7.2090208@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <41FFD9C7.2090208@h3c.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hardy <mhardy@h3c.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Mike,

Mike Hardy wrote:
> 
> Robert Heinzmann wrote:
> 
>> Hello,
>>
>> can someone verify if the following statements are true ?
>>
>> - It's not possible to simply  convert a existing partition with a 
>> filesystem on it to a raid1 mirror set.
> 
> 
> I believe you're right, but I'm not totally sure on this one. I'd take 
> the second disk, create a new RAID1 with the first drive "missing" on 
> the mdadm --create commandline, copy everything over to it, put grub on 
> it, then test that it boots correctly by pulling the first drive out.
> 
> Only once the RAID1 is working (in degraded mode) add the original first 
> drive back in, but booting off the RAID1, then add it to the RAID set to 
> complete the pair. With that process, the question is somewhat moot, 
> although I'm interested in the real answer too

Thats how I'm going to do it althought the version Paul Celemens is 
mentioning sound very elegant (resizing the fs 128 KB prior to creating 
the array).

Bye,
Robert

