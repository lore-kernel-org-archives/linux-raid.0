From: Tommy Apel <tommyapeldk@gmail.com>
Subject: Re: recommending RAID6 over RAID5 when doing mdadm --create
Date: Mon, 11 Nov 2013 09:24:42 +0100
Message-ID: <CAGA4a+GFjNj118NaXRLOV-JNWrpD6CC_VMJDeHw89RmOErUT2Q@mail.gmail.com>
References: <alpine.DEB.2.02.1311110841340.26054@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1311110841340.26054@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid Raid <linux-raid@vger.kernel.org>, Tommy Apel <tommyapeldk@gmail.com>
List-Id: linux-raid.ids

2013/11/11 Mikael Abrahamsson <swmike@swm.pp.se>:
>
> Hi,
>
> I believe this has been discussed before, but I would like to bring it up
> again.
>
> I would like to see mdadm recommend RAID6 over RAID6 when using component
> drives that are 500GB or larger and ask if the user is really sure about
> using RAID5, plus a pointer to a webpage on the wiki informing the user
> about the trouble with RAID5 on large volumes with consumer or prosumer
> drives.
>
> I am willing to contribute text to the webpage being pointed to.
>
> --
> Mikael Abrahamsson    email: swmike@swm.pp.se
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hello,

May I suggest that aswell for arrays with more than 5 drives aswell ?

-- 

/Tommy
