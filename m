From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: ANNOUNCE: mdadm 1.6.0 - A tool for managing Soft RAID under      Linux
Date: Fri, 4 Jun 2004 10:21:01 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200406041421.i54EL7319045@watkins-home.com>
References: <00da01c44a38$81e37cd0$6705a8c0@a30>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <00da01c44a38$81e37cd0$6705a8c0@a30>
To: me@heyjay.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You must finish reading what Neil said!

< Then
<    cfdisk /dev/md/XX
< will allow you to partition the array.

He has more info you somehow skipped!
Re-read the email from Neil.


-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of me@heyjay.com
Sent: Friday, June 04, 2004 9:31 AM
To: Neil Brown; linux-raid@vger.kernel.org
Subject: Re: ANNOUNCE: mdadm 1.6.0 - A tool for managing Soft RAID under
Linux

> The simplest way to access this functionality is with
> 
>     mdadm --create /dev/md/XX --auto=partition --level= ....
> 

How does in know how big to build the partitions?
How does it know how many partitions?

Can you do it with out building the partitions automatically
and instead it will just build /dev/mdXX and then I can use
fdisk, sdisk, cfdisk... to build my partitions?

Thanks
Jay
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


