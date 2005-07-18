From: Tyler <pml@dtbb.net>
Subject: Re: Raid5 Failure
Date: Sun, 17 Jul 2005 17:05:41 -0700
Message-ID: <42DAF255.3020508@dtbb.net>
References: <009401c58ae6$65b57870$c200a8c0@NCNF5131FTH> <17114.54800.132155.142544@cse.unsw.edu.au> <00e101c58b25$6f5c06c0$c200a8c0@NCNF5131FTH>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <00e101c58b25$6f5c06c0$c200a8c0@NCNF5131FTH>
Sender: linux-raid-owner@vger.kernel.org
To: "David M. Strang" <dstrang@shellpower.net>
Cc: Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Try it with -a or --add, not -add, also, you don't need the --manage bit.

Regards,
Tyler.

David M. Strang wrote:

> Neil -
>
> -(root@abyss)-(/)- # mdadm --manage -add /dev/md0 /dev/sdaa
> mdadm: hot add failed for /dev/sdaa: Invalid argument
> -(root@abyss)-(/)- # mdadm --version
> mdadm - v2.0-devel-2 - DEVELOPMENT VERSION NOT FOR REGULAR USE - 7 
> July 2005
> -(root@abyss)-(/)- #
>
> Jul 17 19:13:57 abyss kernel: md0: HOT_ADD may only be used with 
> version-0 superblocks.
>
> I'm using the devel-2 version, with the patch you posted previously.
>
> -- David M. Strang
>
> ----- Original Message ----- From: Neil Brown
> To: David M. Strang
> Cc: linux-raid@vger.kernel.org
> Sent: Sunday, July 17, 2005 6:05 PM
> Subject: Re: Raid5 Failure
>
>
> On Sunday July 17, dstrang@shellpower.net wrote:
>
>> -(root@abyss)-(/)- # mdadm --manage --add /dev/md0 /dev/sdaa
>> mdadm: hot add failed for /dev/sdaa: Invalid argument
>>
>> Jul 17 11:42:38 abyss kernel: md0: HOT_ADD may only be used with 
>> version-0
>> superblocks.
>>
>> What, if anything, can I do since I'm using a version 1.0
>> superblock?
>
>
> Use a newer mdadm.  This works with v2.0-devel-2 (I just checked).
>
> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
