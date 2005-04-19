From: John McMonagle <johnm@advocap.org>
Subject: Re: Can uuid of raid array be changed?
Date: Mon, 18 Apr 2005 20:05:22 -0500
Message-ID: <42645952.1050504@advocap.org>
References: <4262DD5D.40805@advocap.org> <20050418071351.GB30849@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050418071351.GB30849@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Luca Berra wrote:

> On Sun, Apr 17, 2005 at 05:04:13PM -0500, John McMonagle wrote:
>
>> Need to duplicate some computers that are using raid 1.
>>
>> I was thinking of just adding adding an extra drive and then moving 
>> it to the new system. The only problem is the clones will all have 
>> the same uuids.  If at some later date the drives got mixed up I 
>> could see a possibilities for disaster.  Not exactly likely as the 
>> computers will be in different cities.
>>
>> Is there a way to change the uuid if a raid array?
>> Is it really worth worrying about?
>>
> you can recreate the array, this will not damage existing data.
>
> L.
>
Thanks

I'll try it.
I suspect I'll find out real quick but do you need to a 
--zero-superblock  on all  devices making the raid arrays?

Will this damage the lvm2 superblock info?
Probably a good idea to do a vgcfgback just to be safe..

John
