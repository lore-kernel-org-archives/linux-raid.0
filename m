From: "Ruth Ivimey-Cook" <Ruth.Ivimey-Cook@ivimey.org>
Subject: Strange shift to readonly mode on raid5
Date: Tue, 8 Mar 2005 17:05:46 -0000 (GMT)
Message-ID: <13151.81.102.15.210.1110301546.squirrel@ivimey.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I've just spent a couple of hours sorting out my server after it, for an
unknown reason, threw a wobbly and froze.

One of the stranger aspects of this is that once I got it more-or-less
working, I found that the raid5 array on the server was being switched to
readonly mode very early on in the init process (about when RedHat nash
starts): "md: md2 switched to readonly mode" or something similar.

dmesg output shows that all 3 arrays (2xraid1, 1xraid5) were constructed
properly, and the only other strangeness is that between the completion of
array assembly and the above-mentioned readonly switch I got an error from
Ext3 indicating it couldn't recover a filesystem on a readonly device.

I couldn't see any reason for the EXT3 error, nor for the md: output. Has
anyone any ideas?

Ruth
