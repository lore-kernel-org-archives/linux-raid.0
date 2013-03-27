From: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Subject: Possible to change chunk size on RAID-1 without re-init or
 destructive result?
Date: Tue, 26 Mar 2013 22:30:01 -0700
Message-ID: <CAFCYAsfriik8VAPV9MVhsDtgqHTaKs3kzYoSLVQHaiYKfzjXZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings,

I have a RAID-1, two disk volume that was created with a strange chunk
size. For reasons I won't go into here removing the data and
redefining a new RAID-1 volume with a different chunk size is
presently not a viable option.

Since this is a two disk mirror I should, /*theoretically*/ be able to
redefine the chunk size without impacting existing data. I have never
attempted such a thing and am not sure how best to go about it. I know
in a striped data level like RAID-5 or RAID-6 this would absolutely
not be possible.

I know I would have to set a different chunk size in the superblock.
Google and wiki research do not show a clear method to do this.

Any suggestions are appreciated.

--Jeff


-- 
------------------------------
Jeff Johnson
Co-Founder
Aeon Computing

jeff.johnson@aeoncomputing.com
www.aeoncomputing.com
t: 858-412-3810 x101   f: 858-412-3845

4170 Morena Boulevard, Suite D - San Diego, CA 92117
