From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: RAID halting
Date: Thu, 30 Apr 2009 13:34:25 +0100
Message-ID: <49F99AD1.9090204@anonymous.org.uk>
References: <20090430005510167.LLPB6143@cdptpa-omta03.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090430005510167.LLPB6143@cdptpa-omta03.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 30/04/2009 01:55, Leslie Rhorer wrote:
>> What I'd be much more inclined to do is create 2 RAID 5 sets, one of 1T
>> discs, and one of 1.5T discs, then combine the two using LVM. It just
>> feels more natural to me that way. In addition, while both setups will
>> tolerate one disc failure, yours will then only tolerate one particular
>> one of the remaining 11 failing (the companion drive in the LVM/linear
>> pair), and mine will tolerate a failure of any drive on the other RAID-5.
> 
> I had thought of this, but then replacing the 1T + 1.5T pairs with 3T
> drives, which I expect to happen eventually, will be more difficult.

Not really. You can just replace the drives in one array with 3T ones 
(one at a time, waiting for the rebuild to complete each time), grow the 
array, resize LVM's PV with `pvresize`, tell LVM to move the data from 
the other array across with `pvmove`, decommission the now-empty 
array/PV, and finally resize the filesystem.

If you can have all the drives online at once, it's easier than that - 
make a new array of 3T drives, add it to the LVM VG, and `pvmove` all 
your data, decommission the now-empty arrays/PVs, and resize the fs.

Or you might choose to keep one of the arrays of smaller drives and have 
a larger backup system, no `pvmove`s required.

Cheers,

John.

