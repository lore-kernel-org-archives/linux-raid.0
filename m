From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Concatenation with redundancy
Date: Wed, 8 Sep 2004 14:25:46 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16702.35274.336118.561191@cse.unsw.edu.au>
References: <56EE8176-00EE-11D9-94CF-0005023722B8@ubb.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Tony Mantler on Tuesday September 7
To: Tony Mantler <nicoya@ubb.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday September 7, nicoya@ubb.ca wrote:
> Hello,
> 
> Recently I've seen a growing trend in creating very ad-hoc storage 
> arrays for storing large quantities of media files (videos, music, 
> etc). These arrays are usually initially created with a small number of 
> concatenated drives, say 2 or 3, but over time can easily grow to span 
> 6 or 8 drives as personal budgets allow.
...
> 
> 
> So, am I smoking crack here? Does anyone think this would be worth 
> implementing? Has this already been implemented and I just haven't seen 
> it?

I don't know if it has been implemented, though it's not known on
Linux.
I am planning to do something like that eventually, but not until I
have written a filesystem that would make good use of it (it's
planned, but work is slow).

I hadn't thought of allowing drives to be different sizes.  It would
complicate some aspects, but it could be made to work... I guess.

NeilBrown
