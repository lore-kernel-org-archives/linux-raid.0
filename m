From: Heinz Mauelshagen <mauelshagen@redhat.com>
Subject: Re: 3ware and erroneous multipathing - duplicate serial numbers
	(was: 3ware and dmraid)
Date: Mon, 11 Feb 2008 12:31:59 +0100
Message-ID: <20080211113159.GA6353@redhat.com>
References: <A2C96114-A87C-493B-A94D-4DCC80A17F95@develooper.com> <34DD6926-09BB-40FE-995E-C0C6796FE89C@develooper.com> <20080118123358.GA6311@redhat.com> <EAA76A37-245F-4C22-9AB3-3CFC6F32061F@develooper.com>
Reply-To: mauelshagen@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <EAA76A37-245F-4C22-9AB3-3CFC6F32061F@develooper.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ask =?iso-8859-1?Q?Bj=F8rn?= Hansen <ask@develooper.com>
Cc: mauelshagen@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jan 18, 2008 at 11:54:29AM -0800, Ask Bj=F8rn Hansen wrote:
>
> On Jan 18, 2008, at 4:33 AM, Heinz Mauelshagen wrote:
>
>>> Much later I figured out that "dmraid -b" reported two of the disks=
 as
>>> being the same:
>>
>> Looks like the md sync duplicated the metadata and dmraid just spots
>> that duplication. You gotta remove one of the duplicates to clean th=
is up
>> but check first which to pick in case the sync was partial only.
>
>
> The "event" counter is the same on both; is that what I should look f=
or?
>
> Is there a way to reset the dmraid metadata?   I'm not actually using=
=20
> dmraid, I use "regular software raid" so I think I just need to reset=
 the=20
> dmraid data...

dmraid -rD ...

Heinz

>
>
>  - ask
>
> --=20
> http://develooper.com/ - http://askask.com/
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-

Heinz Mauelshagen                                 Red Hat GmbH
Consulting Development Engineer                   Am Sonnenhang 11
Storage Development                               56242 Marienrachdorf
                                                  Germany
Mauelshagen@RedHat.com                            PHONE +49  171 780339=
2
                                                  FAX   +49 2626 924446
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
