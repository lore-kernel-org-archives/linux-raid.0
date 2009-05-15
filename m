From: SandeepKsinha <sandeepksinha@gmail.com>
Subject: Re: RAID4 and RAID5 Code
Date: Fri, 15 May 2009 21:44:37 +0530
Message-ID: <37d33d830905150914v5d780e44s6cc2174944530ddb@mail.gmail.com>
References: <37d33d830905140957q6e180d89v4cd4a21d23471481@mail.gmail.com>
	 <4A0D9384.1020805@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A0D9384.1020805@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, May 15, 2009 at 9:38 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> SandeepKsinha wrote:
>> Hi all,
>>
>> Looks like we have the same code for RAID 4 and RAID 5, I could see
>> the same make_request for both.
>>
>> Can someone point me in the code, where exactly we differentiate
>> between these two. i.e updating checksum block, etc.
>>
>
> RAID 4 is really nothing but a block layout algorithm for RAID 5 (whi=
ch
> has four more block layout algorithms.) =A0RAID 6 contains all five u=
nder
> one "level".
>
RAID 4 vs RAID 5
Actually debatable. They have their own pros and cons and especially
where you don't consider the physical properties of disk.
Addition of new disk, differences in speed of disks, etc.. create
bottlenecks especially in case of RAID5.

Except hot spot issue with RAID 4, I find it better than all others.
Also, most of the proprietary solutions from IBM, Adaptec and NetApp
suggest RAID4 as compared to others.

No offenses please, this is just an opinion.


> =A0 =A0 =A0 =A0-hpa
>
> --
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel. =A0I don't speak on their behalf.
>
>



--=20
Regards,
Sandeep.





 =09
=93To learn is to change. Education is a process that changes the learn=
er.=94
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
