From: "Scott D'Vileskis" <sdvileskis@gmail.com>
Subject: Re: Problem Syncing raid1
Date: Fri, 4 Apr 2014 10:10:48 -0400
Message-ID: <CAK_KU4YnrP4O=JCPQsTxRrOT+nXMAraiMN+_T6W96ekHpPtsTw@mail.gmail.com>
References: <BAY177-W404434C6EBAB450FA96A77C86D0@phx.gbl>
	<CADNH=7EwjLirv+zdUKu-Hsrw1djLNpPoz=WSg4pJwUc0giRzOw@mail.gmail.com>
	<BAY177-W961648C4893E888EECA18C86D0@phx.gbl>
	<CAK_KU4bh3S+rwMmJt4_8pyrOYbiLn83BHYabF79c4M59UoW1TA@mail.gmail.com>
	<BAY177-W35793297D3F640EF11F48C86D0@phx.gbl>
	<BAY177-W48FA7C4D5A92389BFC0667C86C0@phx.gbl>
	<CAK_KU4Z9ND2ivU-09qGSTsBAyVToNnUBAzwpGkQpY_M+khwcvg@mail.gmail.com>
	<alpine.DEB.2.02.1404041427350.10236@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1404041427350.10236@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Christian Schmitz <schnet@hotmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Apr 4, 2014 at 8:29 AM, Mikael Abrahamsson <swmike@swm.pp.se> wrote:
> On Thu, 3 Apr 2014, Scott D'Vileskis wrote:
>
>> Any sectors it has trouble with it will attempt to remap to 'spare'
>> data reserved on the disk.
>
>
> Could you please quote some kind of external resource for your claims here,
> because they are contrary to what truth is usually communicated here.
>
> Common wisdom here is that sectors that can't be read are "pending", and
> they keep being "pending" until someone writes to them, and when the sector
> is written to, it'll either succeed with the write to that sector and then
> all is fine, or it'll fail to write and then it'll mark it as bad, and write
> to spare space, ie this sector is now remapped.
>
> --
> Mikael Abrahamsson    email: swmike@swm.pp.se

I apologize if my relatively simplistic summary of what may actually
be happening left out the detail of pending sectors. In my
understanding, during a SMART self test, if a problem is encountered
and can be dealt with, it can probably handle the transition through
pending sectors, without the user ever witnessing the pending sector
count increase.
How else does one explain increases in reallocated sector counts
following a long self test?

Further, while the SMART description of 'pending' sector count
confirms the wisdom you have shared, the ATA spec on SMART only really
specifies what ATA commands should trigger/query SMART subsystems. It
doesn't suggest how a manufacturer should implement their self tests.

http://www.t13.org/Documents/UploadedDocuments/docs2006/D1699r3f-ATA8-ACS.pdf
Page 243 suggests some logic during a self test, including this
comment about a selective self test: "...Instead error locations MAY
be logged for future reallocation."
Also interesting is the lack of agreement in SMART information. Page
245 of the ATA8 draft shows bytes 0-361 of the SMART table being
'vendor specific'. Other searches yield documents reflecting the lack
of agreement between vendors from time to time.

OP-- I am interested in your self test findings.
