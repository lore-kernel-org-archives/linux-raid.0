From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Spares and partitioning huge disks
Date: Fri, 7 Jan 2005 16:57:35 -0500
Message-ID: <200501072157.j07Lvg906301@www.watkins-home.com>
References: <crmt7e$8d6$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <crmt7e$8d6$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: 'Mario Holbe' <Mario.Holbe@TU-Ilmenau.DE>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

His plan is to split the disks into 6 partitions.
Each of his six RAID5 arrays will only use 1 partition of each physical
disk.
If he were to lose a disk, all 6 RAID5 arrays would only see 1 failed disk.
If he gets 2 read errors, on different disks, at the same time, he has a 1/6
chance they would be in the same array (which would be bad).

Everything SHOULD work just fine.  :)

His plan is to combine the 6 arrays with LVM or a linear array.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Mario Holbe
Sent: Friday, January 07, 2005 3:59 PM
To: linux-raid@vger.kernel.org
Subject: Re: Spares and partitioning huge disks

maarten <maarten@ultratux.net> wrote:
> I just got my 4 new 250GB disks.  I have read someone on this list
advocating 
> that it is better to build arrays with smaller volumes, as that decreases
the 
> chance of failure, especially failures of two disks in a raid5
configuration. 

This might be true for read-errors.
However, if a whole disk dies (perhaps because the IDE controller fails,
I assume you're having IDE disks or because of a temperature failure or
something like that) with a couple of partitions on it, you get a lot of
simultaneously 'disks' (partitions), which would completely kill your
RAID5, because RAID5 can IMHO only recover one failing device.
I'd assume, such a setup would kill you in this case, while with only
4 devices (whole 250G disks) you'd survive it. I'm quite sure one
could get it managed back together with more or less expert knowledge,
but I belive the complete RAID would stop processing first.
Just to make this clear - all this are spontaneous assumptions, I did
never play with RAID5.



regards,
   Mario
-- 
I heard, if you play a NT-CD backwards, you get satanic messages...
That's nothing. If you play it forwards, it installs NT.

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

