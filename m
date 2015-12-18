From: Scott Sinno <scott.sinno@nasa.gov>
Subject: clustered MD - beyond RAID1
Date: Fri, 18 Dec 2015 10:29:22 -0500
Message-ID: <56742652.5040304@nasa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: "Knister, Aaron S. (GSFC-606.2)[COMPUTER SCIENCE CORP]" <aaron.s.knister@nasa.gov>
List-Id: linux-raid.ids

Neil(or anyone well informed in mdadm development roadmaps),
	
	Aaron and myself are engineers at NASA Goddard with strong interest in
MDADM.  We currently host 6PB(raw) of live JBOD storage leveraging MDADM
exclusively for RAID functionality.

	We're very interested in Clustered MDADM to improve data-availability
in the environment, but note that only RAID1 is currently supported.
Are there plans in the nearish-term(say over the next year) to expound
clustered bitmap functionality to RAID5/6, or anything else you can
divulge on that front?  Thanks in advance for any guidance.


