From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Joys of spare disks!
Date: Wed, 2 Mar 2005 00:52:08 -0500
Message-ID: <200503020552.j225qD513637@www.watkins-home.com>
References: <62b0912f050301195062c3afbe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <62b0912f050301195062c3afbe@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Molle Bestefich' <molle.bestefich@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I think the overhead related to fixing the bad blocks would be insignificant
compared to the overhead of degraded mode.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Molle Bestefich
Sent: Tuesday, March 01, 2005 10:51 PM
To: linux-raid@vger.kernel.org
Subject: Re: Joys of spare disks!

Robin Bowes wrote:
> I envisage something like:
> 
> md attempts read
> one disk/partition fails with a bad block
> md re-calculates correct data from other disks
> md writes correct data to "bad" disk
>   - disk will re-locate the bad block

Probably not that simple, since some times multiple blocks will go
bad, and you wouldn't want the entire system to come to a screeching
halt whenever that happens.

A more consistent and risk-free way of doing it would probably be to
do the above partial resync in a background thread or so?..
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

