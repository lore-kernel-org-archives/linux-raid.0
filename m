From: Miles Fidelman <mfidelman@meetinghouse.net>
Subject: Re: possibly silly question (raid failover)
Date: Tue, 01 Nov 2011 18:58:27 -0400
Message-ID: <4EB07993.7000906@meetinghouse.net>
References: <4EAF3F78.5060900@meetinghouse.net> <j8odkj$46h$1@dough.gmane.org> <4EAFEE95.6070608@meetinghouse.net> <4EAFF636.6060904@anonymous.org.uk> <j8p0g3$9r4$1@dough.gmane.org> <4EB052E6.4050400@meetinghouse.net> <20111101212023.GA20565@cthulhu.home.robinhill.me.uk> <4EB06561.8090706@meetinghouse.net> <j8pq51$jol$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <j8pq51$jol$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Brown wrote:
>
> You are aware, of course, that if you take your 16 drives and use 
> "-n8", you will get a total disk space equivalent to two drives.  It 
> would be very resistant to drive failures, but /very/ poor space 
> efficiency.  It would also be very fast for reads, but very slow for 
> writes (as everything must be written 8 times).
>
> It's your choice - md is very flexible.  But I think an eight-way 
> mirror would be considered somewhat unusual.

What would be particularly interesting is if I can do -n4 and configure 
things in a way that insures that each of those 4 is on a different one 
of my 4 boxes (4 boxes, 4 disks each).




-- 
In theory, there is no difference between theory and practice.
In<fnord>  practice, there is.   .... Yogi Berra


