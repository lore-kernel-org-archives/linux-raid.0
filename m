From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 2/3 v4]raid1: read balance chooses idlest disk for SSD
Date: Fri, 6 Jul 2012 08:27:09 +0800
Message-ID: <CANejiEUMg_WFh-G+EpSbkGHnDgBAVF605T+ttv4aj3EEXu3yWg@mail.gmail.com>
References: <20120705092057.GB27956@kernel.org>
	<CABYL=TqgOmuL4JLT1-pmUWgeVHH+veuNB4K5BSW5=zW0iL6C_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABYL=TqgOmuL4JLT1-pmUWgeVHH+veuNB4K5BSW5=zW0iL6C_Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

2012/7/5 Roberto Spadim <roberto@spadim.com.br>:
> nice, just another question...
>  since this use mixed raid disks (different types) could we improve
> the algorithm to diferent hard disk speed, for example a raid1 with
> 7200 and 15000 rpm?
> the distance continue the same but it will include a 'speed' factor
> speed=3D1/rpm
> (distance*speed)
> or something to select fastest disk in the array
> i don=B4t want to use write-mostly since it can reduce my total numbe=
r
> of read disks, but with this we could use the fastest disk with more
> frequency without lose array 'speed'

Legitimate optimization, however detecting hard disk speed is hard.
Or maybe you want to add an option to tell kernel the disk speed?

Thanks,
Shaohua
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
