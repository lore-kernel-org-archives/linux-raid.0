From: Neil Brown <neilb@suse.de>
Subject: Re: PROBLEM: system crash on AMD64 with 2.6.17.11 while accessing 3TB Software-RAID5
Date: Thu, 31 Aug 2006 13:56:43 +1000
Message-ID: <17654.24059.852752.251958@cse.unsw.edu.au>
References: <758194931.20060829001041@TU-Ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Ralf Herrmann on Tuesday August 29
Sender: linux-raid-owner@vger.kernel.org
To: Ralf.Herrmann@TU-Ilmenau.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday August 29, Ralf.Herrmann@TU-Ilmenau.de wrote:
> Hi,
> 
> i hope i picked the right list for this problem,
> here's the formal report:
> 
> [1.] One line summary of the problem:
> 
>  System crashes while accessing a 3TB RAID5 on an AMD64 with 2.6.17.11.
> 

Yes...... you are hitting some pretty serious BUGs.  And this is in
code that is not specific to RAID at all, so if there really were bugs
there, we would expect to have seen them well before now.

I really looks to me like a hardware problem.  Some how various bits
of memory sometimes have bad values and cause a problem.

How long did you run memtest?  I would suggest running it for at
least 24 hours, because my best guess is that it is bad memory, even
though your tests so far don't show that.

Is it possible for you to place 'mix and match' with another machine?
i.e. swap the memory and see if it still fails.  Then swap the
processors.  Then swap the mother boards.  Then the power supplies...

If not, you could try selective disablement.
i.e. pull out half the RAM.  If it still fails, put that back and pull
out the other half.
Pull out one processor and if it still fails, put that back and pull
out the other one.

Good luck...


NeilBrown
