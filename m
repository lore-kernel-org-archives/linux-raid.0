From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: migration of raid 5 to raid 6 and disk of 2TB to 4TB
Date: Wed, 27 Jul 2016 14:27:59 +0100
Message-ID: <ba665fd2-29e1-81ec-1909-c2efe14efdee@youngman.org.uk>
References: <CADzS=aqYQEoqxHbp7keeuYqN2dLur1O=RfctfuFsraggxiWTKg@mail.gmail.com>
 <22423.44287.974770.114127@tree.ty.sabi.co.uk>
 <5797C5CE.6020300@youngman.org.uk>
 <CADzS=arvFWy-9_e8L3ngdrYxwGxVNm=zTqoLusvwKmmkUnBfQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADzS=arvFWy-9_e8L3ngdrYxwGxVNm=zTqoLusvwKmmkUnBfQQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: bobzer <bobzer@gmail.com>, Adam Goryachev <mailinglists@websitemanagers.com.au>, Peter Grandi <pg@lxra2.for.sabi.co.uk>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 27/07/16 03:16, bobzer wrote:
> Thank you very much for your help
>
> I realized that there's much better idea than my first idea....
>
> I can plug all my drives the sata plug are not a problem :-)
> I use around 4.5TB on my current raid 5
> I will continue to think on this problem and in the meanwhile try to
> find another disk
>
> i didn't think about :
>>> In general an in-place migration is a very dangerous operation
>>> because it stresses existing hardware a lot plus it uses code
>>> that is rarely used and is quite complex. Given that your
>>> situation is already compromised.
>> But copying everything off will stress it just as much, surely? The
>> alternatives imho are worse ...
> at first i thought about using rsync to do my copy (anyway i don't have a GUI)
> at second i thought that an in-place migration would be a nice and
> safe operation
> now i don't what to think ?
> the 3  4TB disk are new but the 2  2TB are 4 year old and consumer
> grade (the 4TB are seagate NAS HDD)
> so i'm asking myself should I do a copy (with rsync or another tool)
> or an in-place migration ? which one is the safest ?
>
>
Get another 4TB drive?

Firstly, desktop grade is dangerous. You should never have been using 
these disks in a raid5 (is that why you lost the other two drives?). 
Have you still got those drives? If so, try wiping them with "dd 
if=/dev/random of=/dev/dud-drive" (I've said /dev/random rather than 
/dev/zero because I'm worried the drive might try and do something 
clever). This may get those drives back and usable, although I wouldn't 
trust them. IFF that works, you now have your 2 x  2TB array back. 
(It'll hopefully fix any dud sectors by overwriting them.)

You can now create a 3 x 4TB raid-5 and copy your data across. If it 
doesn't work, you can see why you need to get that next 4TB drive :-) 
And once you've got your fourth drive, you have your raid6.

The big problem you have is that your data is over 4TB, and won't fit on 
one drive. So there is no way, whether you do an in-place migration, or 
a copy-to-new-raid, that you can transfer the data without losing raid 
protection somewhere along the line unless you get more disk space.

With that extra 4TB drive, personally I'd migrate in place - as I said 
add in the three new 4TB drives, convert the two 2TB drives to a 4TB 
raid0 so I can free up the 4TB drive with the 2TB image, then use that 
freed drive to replace the raid0.

Cheers,
Wol
