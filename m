From: Miles Fidelman <mfidelman@meetinghouse.net>
Subject: looking for good reference on storage configuration
Date: Wed, 21 Oct 2015 08:00:07 -0400
Message-ID: <56277E47.9070003@meetinghouse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Folks,

Perhaps someone here might be able to point me at a reference or two on 
alternatives and best practices for configuring storage for a server - 
using a mix of SSDs and conventional drives.

I'm in the process of upgrading a small cluster of 4 machines - each 
containing RAID arrays, with DRBD across clusters to support failover.  
Easy enough with a uniform collection of HDDs.  But I can't get my head 
around how to add SSDs into the mix - what with the mismatch in access 
speeds and all, it would seem like one needs a more complex 
configuration with a level of caching between the faster and slower media.

Seems like someone would have written a book, or tutorial, or case 
study, or conference presentation - but damned if I can find anything.  
Any pointers, or guidance, would be much appreciated.

Thanks,

Miles Fidelman

-- 
In theory, there is no difference between theory and practice.
In practice, there is.   .... Yogi Berra

