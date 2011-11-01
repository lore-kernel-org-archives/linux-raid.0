From: Miles Fidelman <mfidelman@meetinghouse.net>
Subject: Re: possibly silly question (raid failover)
Date: Tue, 01 Nov 2011 18:38:38 -0400
Message-ID: <4EB074EE.10709@meetinghouse.net>
References: <4EAF3F78.5060900@meetinghouse.net> <j8odkj$46h$1@dough.gmane.org> <4EAFEE95.6070608@meetinghouse.net> <4EAFF636.6060904@anonymous.org.uk> <j8p0g3$9r4$1@dough.gmane.org> <4EB052E6.4050400@meetinghouse.net> <20111101221539.GA1319@www5.open-std.org> <20111102092526.50b410b1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111102092526.50b410b1@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown wrote:
> On Tue, 1 Nov 2011 23:15:39 +0100 keld@keldix.com wrote:
>
>> On Tue, Nov 01, 2011 at 04:13:26PM -0400, Miles Fidelman wrote:
>>> David Brown wrote:
>>>> No, md RAID10 does /not/ offer more redundancy than RAID1.  You are
>>>> right that md RAID10 offers more than RAID1 (or traditional RAID0 over
>>>> RAID1 sets) - but it is a convenience and performance benefit, not a
>>>> redundancy benefit.  In particular, it lets you build RAID10 from any
>>>> number of disks, not just two.  And it lets you stripe over all disks,
>>>> improving performance for some loads (though not /all/ loads - if you
>>>> have lots of concurrent small reads, you may be faster using plain
>>>> RAID1).
>> In fact raid10 mas a bit less redundancy than raid1+0.
>> It is as far as I know built as raid0+1 with a disk layout
>> where you can only loose eg 1 out of 4 disks, while raid1+0
>> in some cases can lose 2 disks out of 4.
> With md/raid10 you can in some case lose 2 out of 4 disks and survive, just
> like raid1+0.
>
it occurs to me that it's a real bummer that all the md documentation, 
that was on raid.wiki.kernel.org, has been inaccessible since the 
kernel.org hack a couple of months ago -- anybody know if that's going 
to be back soon, or if that documentation lives somewhere else as well?




-- 
In theory, there is no difference between theory and practice.
In<fnord>  practice, there is.   .... Yogi Berra


