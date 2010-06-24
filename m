From: Markus Krainz <ldm@gmx.at>
Subject: Re: Building new RAID5 results in removed and failed devices
Date: Fri, 25 Jun 2010 00:23:49 +0200
Message-ID: <4C23DAF5.3010401@gmx.at>
References: <4C23BF79.2070009@gmx.at> <AANLkTil7F2gHUVzBGbqBU4tUDdKBpVThEwnOmm0RdRn4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTil7F2gHUVzBGbqBU4tUDdKBpVThEwnOmm0RdRn4@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/24/2010 11:03 PM, Dan Williams wrote:
> This is expected without the --force option:
>
> --force
>                Insist that mdadm accept the geometry and layout
> specified without question.
>                Normally mdadm will not allow creation of an array with
> only one device, and
>                will  try  to create a RAID5 array with one missing
> drive (as this makes the
>                initial resync work faster).  With --force, mdadm will
> not  try  to  be  so
>                clever.
>
>    

The manpage you quoted says mdadm will not create a raid5 array with 
only one device.
However in my case I have --raid-devices=2 and both /dev/sdd1 and 
/dev/sdb1. So I should be ok with a raid5 and 2 devices?
The reason I am not using raid1 is because a want to add more drives 
later on.

Best regards,
Markus




mdadm --create --verbose /dev/md1 --chunk=64 --level=5 --raid-devices=2 
/dev/sdd1 /dev/sdb1

