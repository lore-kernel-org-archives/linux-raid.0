From: Ryan Wagoner <rswagoner@gmail.com>
Subject: Re: rescue an alien md raid5
Date: Sat, 14 Mar 2009 09:12:23 -0500
Message-ID: <7d86ddb90903140712v358c170bq554e9fd963099a1@mail.gmail.com>
References: <200902231013.46082.harry.mangalam@uci.edu>
	 <49A345BC.1010206@gluesys.com>
	 <200902241311.33442.harry.mangalam@uci.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200902241311.33442.harry.mangalam@uci.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Harry Mangalam <harry.mangalam@uci.edu>
Cc: hgichon <kpkim@gluesys.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

No LVM has no correlation with mdadm. LVM stands for logical volume
manager and lets you dynamically partition space on top of a real
partition. Try running the commands below. If LVM is not used it won't
affect the data on the disk. If it is used then your problem is
resolved.

On Tue, Feb 24, 2009 at 4:11 PM, Harry Mangalam <harry.mangalam@uci.edu=
> wrote:
> Hi kpkim,
>
> You mean that the system needs an lvm/lvm2 layer to properly interpre=
t
> the underlying filesystem?
>
> Possible, but the USR OSS list:
> <http://www.usr.com/support/gpl/8700-OpenSourcesList-0.63_USR.xls>
> doesn't list lvm as part of their implementation. =A0Would mdadm have
> been able to detect this?
>
> Harry
>
>
> On Monday 23 February 2009, hgichon wrote:
>> I read USRobotics 8700 feature.
>>
>> # Supports linear storage use (all drives as one logical drive) or
>> use multiple drives as primary and back-up storage
>> # Dynamic logical drive sizing - Add an additional drive, when
>> needed, and it will be integrated into the logical drive with no
>> effect on data
>>
>> maybe... there is no lvm layer?
>> try vgscan / vgchange -ay
>>
>> best regards.
>
>
>
> --
> Harry Mangalam - Research Computing, NACS, E2148, Engineering Gateway=
,
> UC Irvine 92697 =A0949 824-0084(o), 949 285-4487(c)
> ---
> Good judgment comes from experience;
> Experience comes from bad judgment. [F. Brooks.]
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
