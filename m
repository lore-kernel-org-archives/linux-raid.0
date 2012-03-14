From: David Brown <david@westcontrol.com>
Subject: Re: [md PATCH 15/23] md/raid10 - support resizing some RAID10 arrays.
Date: Wed, 14 Mar 2012 08:51:44 +0100
Message-ID: <4F604E10.20605@westcontrol.com>
References: <20120314043555.7978.75486.stgit@notabene.brown> <20120314044040.7978.69754.stgit@notabene.brown> <20120314061746.GA28196@www5.open-std.org> <20120314172712.3aa9310a@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120314172712.3aa9310a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: keld@keldix.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 14/03/2012 07:27, NeilBrown wrote:
> On Wed, 14 Mar 2012 07:17:46 +0100 keld@keldix.com wrote:
>
>> Hi Neil
>>
>> What is the problem with adding space to the 'far' layout?
>>
>> I would think you could just create the new array part 1 from the
>> old array part 2, and then sync the new array part 2 with the new
>> array part 1. (in the case of a far=2 array, for n>2 similar
>> constructs would apply).
>
> If I understand your proposal correctly, you would lose redundancy
> during the process, which is not acceptable.
>

That's how I understood the suggestion too.  And in some cases, that 
might be a good choice for the user - if they have good backups, they 
might be happy to risk such a re-shape.  Of course, they would have to 
use the "--yes-I-really-understand-the-risks" flag to mdadm, but other 
than that it should be pretty simple to implement.

For a safe re-shape of raid10, you would need to move the "far" copy 
backwards to the right spot on the growing disk (or forwards if you are 
shrinking the array).  It could certainly be done safely, and would be 
very useful for users, but it is not quite as simple as an unsafe re-size.

mvh.,

David


> If I don't understand properly - please explain in a bit more
> detail.
>
> Thanks, NeilBrown
>

