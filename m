From: Luca Berra <bluca@comedia.it>
Subject: Re: Can uuid of raid array be changed?
Date: Tue, 19 Apr 2005 08:56:08 +0200
Message-ID: <20050419065608.GA29247@percy.comedia.it>
References: <4262DD5D.40805@advocap.org> <20050418071351.GB30849@percy.comedia.it> <42645952.1050504@advocap.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <42645952.1050504@advocap.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 18, 2005 at 08:05:22PM -0500, John McMonagle wrote:
>Luca Berra wrote:
>
>>On Sun, Apr 17, 2005 at 05:04:13PM -0500, John McMonagle wrote:
>>
>>>Need to duplicate some computers that are using raid 1.
>>>
>>>I was thinking of just adding adding an extra drive and then moving 
>>>it to the new system. The only problem is the clones will all have 
>>>the same uuids.  If at some later date the drives got mixed up I 
>>>could see a possibilities for disaster.  Not exactly likely as the 
>>>computers will be in different cities.
>>>
>>>Is there a way to change the uuid if a raid array?
>>>Is it really worth worrying about?
>>>
>>you can recreate the array, this will not damage existing data.
>>
>>L.
>>
>Thanks
>
>I'll try it.
>I suspect I'll find out real quick but do you need to a 
>--zero-superblock  on all  devices making the raid arrays?
NO
>Will this damage the lvm2 superblock info?
>Probably a good idea to do a vgcfgback just to be safe..
NO

the idea is after you cloned the drive, create a new array with the
force flag and using as components the cloned disk and the magic word
"missing", this will create a new degraded array and won't touch any
data.
you can then hotadd a new drive to this array, it will fill the slot
used by the "missing" keyword.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
