From: Alex <mysqlstudent@gmail.com>
Subject: Re: Impending failure?
Date: Mon, 7 Nov 2011 16:17:54 -0500
Message-ID: <CAB1R3sgM6aMTpR3=VN3u1C5hFHnvxFi6C69kGEtuEx2nxcGnMA@mail.gmail.com>
References: <CADNH=7G0jxirzj+T-YcqJ+AaF6LFEvJMBv+RfFYT4fxD8VpYww@mail.gmail.com>
	<de98e391-ec94-41eb-b83d-4535f51ac6e4@large-turd>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <de98e391-ec94-41eb-b83d-4535f51ac6e4@large-turd>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Zieba <pzieba@networkmayhem.com>
Cc: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi guys,

> So, in my personal experience with pending sectors, it's worth mentio=
ning the following:
>
> If you do a "check", and you have any pending sectors that are within=
 the partition that is used for the md device, they should be read and =
rewritten as needed, causing the count to go down. However, I've notice=
d that sometimes I have pending sector counts on drives that don't go a=
way after a "check". These would go away, however, if I failed and then=
 removed the drive with mdadm, and then subsequently zero filled the /e=
ntire/ drive (as opposed to just the partition on that disk that is use=
d by the array). The reason for this is that there's a small chunk of u=
nused space that never gets read or written to right after the partitio=
n (even though I technically partition the entire drive as one large pa=
rtition (fd =A0Linux raid auto).
>
> I think what actually happens in this case is that when the system re=
ads data from near the end of the array, the drive itself will do read-=
ahead and cache it. So, even though the computer never requested those =
abandoned sectors, the drive eventually notices that it can't read them=
, and makes a note of the fact. So, this is harmless.
>
> You could probably avoid the potential for false-positive on pending =
sectors if you used the entire disk for the array (no partitions), but =
I'm pretty sure that breaks the raid auto-detection.
>
> Currently, my main array has 8 2TB hitachi disks, in a raid 6. It is =
scrubbed once a week, and one disk consistently has 8 pending sectors o=
n it. I'm certain I could make those go away if I wanted, but, frankly,=
 it's purely aesthetic as far as I'm concerned. Some of my drives also =
have non-zero "196 Reallocated_Event_Count" and "5 Reallocated_Sector_C=
t", however, I have no drives with non-zero "Offline_Uncorrectable". I =
haven't had any problems with the disks or array (other than a temperat=
ure induced failure ... but that's another story, and I still run the s=
ame disks after that event). I used to have lots of issues before I sta=
rted scrubbing consistently.

I think I understand your explanation. You are basically saying that
if I recheck the drive, there's a possibility the pending defective
sectors may resolve themselves?

Given that I have an existing system, how do I check the integrity of
the partitions? What is the contents of the "check" script to which
you refer?

Is this safe to do remotely?

Is it necessary to set a disk faulty before removing it?

Thanks,
Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
