From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Riad scrub generated errors, should I worry?
Date: Mon, 2 Mar 2015 14:17:25 -0700
Message-ID: <CAJCQCtTwHex2y8tdkAZ6FfDTyH0-umnYrYmbUpjj32sBge3TTA@mail.gmail.com>
References: <BLU436-SMTP203777F3704141DF5C096B898100@phx.gbl>
	<CAJCQCtR1th-V67c7dwZxNBFqKZ=96sAVLzyp4zscO-wPv9jA9g@mail.gmail.com>
	<BLU436-SMTP202531F6FEBD121B8D09E7498100@phx.gbl>
	<CAJCQCtTVA6ntASWFtWMw7ZEwu=8jH+UjvN8avPZ8jXZ1_4BQXg@mail.gmail.com>
	<CAJCQCtRdYmtx6PTyif6mv_j8htf5hYNZPq3SubJxQoyjULdZPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtRdYmtx6PTyif6mv_j8htf5hYNZPq3SubJxQoyjULdZPA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thing is, we don't have the entire dmesg. I vaguely recall that md
write entire chunks when correcting, not a single sector. For a
default 512KB chunk size (assuming raid56), I'd expect 128 "read error
corrected" events. So it might be we just don't have the full dmesg
reporting the affected sector being overwritten and in the meantime
the drive keeps complaining about this one sector.

-- 
Chris Murphy
