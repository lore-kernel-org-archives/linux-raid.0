From: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Subject: Re: recovering a mirrored arry.
Date: Fri, 5 Feb 2010 16:25:02 +0000
Message-ID: <73e903671002050825j2ae06fabjc7ec2b1e8fb85135@mail.gmail.com>
References: <20100203025758.GA12925@light.rap.dk> <20100205011928.GA12630@light.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100205011928.GA12630@light.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Keld Simonsen <keld@keldix.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Feb 5, 2010 at 1:19 AM, Keld Simonsen <keld@keldix.com> wrote:
> On Wed, Feb 03, 2010 at 03:57:58AM +0100, Keld Simonsen wrote:
> Hi
>
>
> can anybody help me with this? I am stuck with recovering my system h=
ere.
> is it a sensible thing ro do?
>
> best regards
> keld
>
>> Hi
>>
>> I got 2 arrays in error of the raid10 type.
>>
>> I think this is because my motherboard died, and then the fs were
>> corrupted.
>>
>> My thoughts were that actually one of the copies could be correct.
>> So I would like to try out the consistency of each part of the raid1=
0
>> (it is 2-partition arrays), and then if I find one that is consisten=
t, then
>> resync the faulty one with the good one.
>>
>> How do I do this?
>>
>> it seems that I cannot just assemble an array with a missing part.
>> If I assemble the full array, is there then a risk of the bad one
>> corrupting the good one? And can I declare one of the disks faulty
>> then test the other one, then declare nbr 2 disk for faulty and
>> declare the first one as good?
>>
>> I dont see anything on the wiki on this.
>>
>> best regards
>> keld
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>


I wish I could help more, but check out this from the mdadm man page:

       To create a "degraded" array in which some devices are missing,
simply give
       the word "missing" in place of a device name.  This  will
cause  mdadm  to
       leave  the  corresponding  slot  in  the array empty.  For a
RAID4 or RAID5
       array at most one slot can be "missing"; for a  RAID6  array
at  most  two
       slots.   For a RAID1 array, only one real device needs to be
given.  All of
       the others can be "missing".

Hope this helps!
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
