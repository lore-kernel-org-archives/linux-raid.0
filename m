From: David Brown <david@westcontrol.com>
Subject: Re: possibly silly question (raid failover)
Date: Wed, 02 Nov 2011 12:27:59 +0100
Message-ID: <j8r9qj$h4f$1@dough.gmane.org>
References: <4EAF3F78.5060900@meetinghouse.net> <j8odkj$46h$1@dough.gmane.org> <4EAFEE95.6070608@meetinghouse.net> <4EAFF636.6060904@anonymous.org.uk> <j8p0g3$9r4$1@dough.gmane.org> <4EB052E6.4050400@meetinghouse.net> <20111101221539.GA1319@www5.open-std.org> <20111102092526.50b410b1@notabene.brown> <20111102013756.GA10763@www5.open-std.org> <20111102124816.33a55447@notabene.brown> <20111102070221.GA24797@www5.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111102070221.GA24797@www5.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/11/2011 08:02, keld@keldix.com wrote:
> On Wed, Nov 02, 2011 at 12:48:16PM +1100, NeilBrown wrote:
>> On Wed, 2 Nov 2011 02:37:56 +0100 keld@keldix.com wrote:
>>
>>> On Wed, Nov 02, 2011 at 09:25:26AM +1100, NeilBrown wrote:
>>>> On Tue, 1 Nov 2011 23:15:39 +0100 keld@keldix.com wrote:
>>>>
>>>>> On Tue, Nov 01, 2011 at 04:13:26PM -0400, Miles Fidelman wrote:
>>>>>> David Brown wrote:
>>>>>>>
>>>>>>> No, md RAID10 does /not/ offer more redundancy than RAID1.  You are
>>>>>>> right that md RAID10 offers more than RAID1 (or traditional RAID0 over
>>>>>>> RAID1 sets) - but it is a convenience and performance benefit, not a
>>>>>>> redundancy benefit.  In particular, it lets you build RAID10 from any
>>>>>>> number of disks, not just two.  And it lets you stripe over all disks,
>>>>>>> improving performance for some loads (though not /all/ loads - if you
>>>>>>> have lots of concurrent small reads, you may be faster using plain
>>>>>>> RAID1).
>>>>>
>>>>> In fact raid10 mas a bit less redundancy than raid1+0.
>>>>> It is as far as I know built as raid0+1 with a disk layout
>>>>> where you can only loose eg 1 out of 4 disks, while raid1+0
>>>>> in some cases can loose 2 disks out of 4.
>>>>
>>>> With md/raid10 you can in some case lose 2 out of 4 disks and survive, just
>>>> like raid1+0.
>>>
>>> OK, in which cases, and when is this not the case?
>>>
>>> best regards
>>> keld
>>
>> "just like raid1+0"
>
> No, that is not the case AFAIK. Eg the layout of raid10,f2 with 4 disks is
> "just like raid0+1".
>

And raid0+1 can also survive two disk failures in some cases.

It boils down to this - if you have a two-way mirror (RAID1, RAID10, 
RAID1+0, RAID0+1), then you can keep losing disks unless you lose both 
copies of part of your data.

Look at the layout diagrams on 
<http://en.wikipedia.org/wiki/Non-standard_RAID_levels#Linux_MD_RAID_10> 
for the four drive cases.  You can lose disk 1 and 3, or disk 2 and 4, 
in either the "near 2" or the "far 2" cases.  But if you lose disks 1 
and 2, or disks 3 and 4, your data is gone:

RAID10,n2, or RAID1+0 (stripe of mirrors) :

Good array        Lost 1+3 (OK)    Lost 1+2 (Dead)
A1 A1 A2 A2       x A1 x A2        x x A2 A2
A3 A3 A4 A4       x A3 x A4        x x A4 A4
A5 A5 A6 A6       x A5 x A6        x x A6 A6
A7 A7 A8 A8       x A7 x A8        x x A8 A8


RAID10,f2 :

Good array        Lost 1+3 (OK)    Lost 1+2 (Dead)
A1 A2 A3 A4       x A2 x A4        x x A3 A4
A5 A6 A7 A8       x A6 x A8        x x A7 A8
....
A4 A1 A2 A3       x A1 x A3        x x A2 A3
A8 A5 A6 A7       x A5 x A7        x x A6 A7


RAID10,02 :

Good array        Lost 1+3 (OK)    Lost 1+2 (Dead)
A1 A2 A3 A4       x A2 x A4        x x A3 A4
A4 A1 A2 A3       x A1 x A3        x x A2 A3
A5 A6 A7 A8       x A6 x A8        x x A7 A8
A8 A5 A6 A7       x A5 x A7        x x A6 A7

RAID0+1 (mirror of stripes) :

Good array        Lost 1+3 (Dead)  Lost 1+2 (OK)
A1 A2 A1 A2       x A2 x A2        x x A1 A2
A3 A4 A3 A4       x A4 x A4        x x A3 A4
A5 A6 A5 A6       x A6 x A6        x x A5 A6
A7 A8 A7 A8       x A8 x A8        x x A7 A8



