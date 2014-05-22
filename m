From: Benjamin ESTRABAUD <be@mpstor.com>
Subject: Re: Broken raid 5
Date: Thu, 22 May 2014 12:16:20 +0100
Message-ID: <537DDC84.3010003@mpstor.com>
References: <43607931-ad0a-4dbc-b258-188297cbb951@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43607931-ad0a-4dbc-b258-188297cbb951@email.android.com>
Sender: linux-raid-owner@vger.kernel.org
To: "L. M. J" <linuxmasterjedi@free.fr>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21/05/14 23:05, L. M. J wrote:
> Hi,
>
>   Very short story : I've created an array on top of another one,
I presume that you actually mean that you created an array ontop of the=
=20
disks from another array.

  so I lost my array and my data.
>
>   Is there =C3=A0 way to recover RAID 5 meta data on each disk to be =
able to rebuilt the previous raid 5?
>
Well, if you used the same metadata version (like 1.2 for instance), th=
e=20
"old" metadata would have been overwritten by your new RAID metadata=20
(assuming you built the RAID on the same drives/partitions) so that=20
would be gone as well.

Even if you were able to rebuild the "previous" RAID (also assuming it=20
was a RAID5), if your current RAID build has completed the data would=20
have been thoroughly destroyed by the build process and recovery would=20
be insanely hard.

> Thabks
>

Regards,
Ben.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
