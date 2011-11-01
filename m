From: Miles Fidelman <mfidelman@meetinghouse.net>
Subject: Re: possibly silly question (raid failover)
Date: Tue, 01 Nov 2011 16:13:26 -0400
Message-ID: <4EB052E6.4050400@meetinghouse.net>
References: <4EAF3F78.5060900@meetinghouse.net> <j8odkj$46h$1@dough.gmane.org> <4EAFEE95.6070608@meetinghouse.net> <4EAFF636.6060904@anonymous.org.uk> <j8p0g3$9r4$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <j8p0g3$9r4$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Brown wrote:
>
> No, md RAID10 does /not/ offer more redundancy than RAID1.  You are 
> right that md RAID10 offers more than RAID1 (or traditional RAID0 over 
> RAID1 sets) - but it is a convenience and performance benefit, not a 
> redundancy benefit.  In particular, it lets you build RAID10 from any 
> number of disks, not just two.  And it lets you stripe over all disks, 
> improving performance for some loads (though not /all/ loads - if you 
> have lots of concurrent small reads, you may be faster using plain 
> RAID1).

wasn't suggesting that it does - just that it does things differently 
than normal raid 1+0 - for example, by doing mirroring and striping as a 
unitary operation, it works across odd number of drives - it also (I 
think) allows for more than 2 copies of a block (not completely clear 
how many copies of a block would be made if you specified a 16 drive 
array) - sort of what I'm wondering here





-- 
In theory, there is no difference between theory and practice.
In<fnord>  practice, there is.   .... Yogi Berra


