From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: bad /proc/mdstat message
Date: Mon, 12 Jan 2004 13:56:29 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200401121856.i0CIuXi25327@dns1.watkins-home.com>
References: <Pine.GSO.4.31.0401121226350.29377-100000@staff2.cso.uiuc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.GSO.4.31.0401121226350.29377-100000@staff2.cso.uiuc.edu>
To: 'Sharif Islam' <mislam@ux1.cso.uiuc.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My /proc/mdstat does not contain "Event: 1", or "Event".
So I would guess it is related to an event! :)

Look in "/var/log/messages", and dmesg.

I can't find any info that explains the contents of /proc/mdstat.
It also seems like mdadm has a bug!  It should support the "Event" line.
Maybe just ignore it.  Maybe /proc/mdstat should give details about the
events.  Just my 3 cents.

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Sharif Islam
Sent: Monday, January 12, 2004 1:29 PM
To: linux-raid@vger.kernel.org
Subject: bad /proc/mdstat message 

I am getting the following message:
mdadm: bad /proc/mdstat line starts : Event:


I wasn't able to figure out the reason. My array is acting normal and
/proc/mdstat looks ok to me.

# cat /proc/mdstat
Personalities : [linear] [raid0]
read_ahead 1024 sectors
Event: 1
md0 : active linear hdl[5] hdk[4] hdh[3] hdg[2] hdf[1] hde[0]
      703324416 blocks 64k rounding

unused devices: <none>

Any hints?

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


