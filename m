From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Raid5 Construction Question
Date: Fri, 20 Aug 2004 02:52:17 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408200652.i7K6qH315986@watkins-home.com>
References: <4125896A.8040800@earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4125896A.8040800@earthlink.net>
To: 'Mike Baynton' <mikeb414@earthlink.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From what I have read on this list, raidtools is no longer supported.
This includes raidstart, raidstop, raidhotadd and raidhotremove, maybe more.

mdadm is the preferred tool to maintain your arrays.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Mike Baynton
Sent: Friday, August 20, 2004 1:18 AM
To: linux-raid@vger.kernel.org
Subject: Re: Raid5 Construction Question

Paul Nowoczynski wrote:

 > Neil,
 > Thanks for the info - I tried something along these lines
 > but didn't know how to set the faulty disk.  I didn't see it in
 > a man page


How bout that. Does somebody know if there is ANY man page detailing all 
of those little raidtools utilities? How are man pages maintained, 
anyway? Even though you can #raid\tab\tab it seems like they should at 
least be mentioned by name in the man pages somewhere, mkraid maybe. Or 
am i just missing it?

though I should have caught it with raid\tab\tab :)

 >
 > Ironically, the performance did end up hovering around 30MB/sec
 > for most of the rebuild.
 >
 > Thanks.
 > Pul
 >

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

