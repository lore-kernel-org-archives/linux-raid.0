From: "Ryan Wagoner" <rswagoner@gmail.com>
Subject: Re: Tips for good hard drives for a home server
Date: Thu, 13 Nov 2008 07:35:53 -0500
Message-ID: <7d86ddb90811130435w71917943vfc39ab71aa9410b7@mail.gmail.com>
References: <3ECBDC05781B3D48ABD520A01ABF2F9B299C974A5A@SE-EX008.groupinfra.com>
	 <A20315AE59B5C34585629E258D76A97C02A43936@34093-C3-EVS3.exchange.rackspace.com>
	 <837a927a0811120631j4bf074d1s5eab70142a7173b2@mail.gmail.com>
	 <3ECBDC05781B3D48ABD520A01ABF2F9B299C9ECE78@SE-EX008.groupinfra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3ECBDC05781B3D48ABD520A01ABF2F9B299C9ECE78@SE-EX008.groupinfra.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Actually a single drive is more reliable than 2 drives in RAID 0. If
either drive fails all your data is gone. RAID 0 is intended for
performance only. Personally I would buy the non enterprise class
drives and get 3 for the price of 2 and do RAID 5.

Just a thought.

Ryan

On Thu, Nov 13, 2008 at 7:11 AM, Henry, Andrew <andrew.henry@logica.com> wrote:
>> Any reason you are using RAID 0 for your server? Normally when I think of a server reliability  comes to mind and RAID 0 doesn't offer any.
>> I'm assumming you make nightly or weekly backups?
>
>
> Im using RAID 0 because I am not willing to shell out for several drives.  2 at once is my breaking point.  This is only a *home* server, and in my opinion, I think im already being way more conscious of reliability by choosing RAID 0 compared to average Joe that goes for a Windows Home Server with a single hard drive
>
> I do not currently have backups of my RAID 0 array: it is being used *for* my backup sets.  My data is stored on my desktop PC at the moment and im doing incremental tar backups to my RAID 0 disk.  There are other data on the array that I do not have on my desktop, but I have original media for these (music/movie library) and loss of this would be more inconvenience of having to rip the discs to hard drive again (very time consuming).
>
>
>> i recently bought the 2 of the WD RE3 750GB and using them with linux
>> raid level 1. time will only tell how these hard drives hold up. but
>> aside from the Velociraptos (which only go up to 300GB) these seem to
>> be top quality in their line.
>
> I've looked at the specs of the WD RE3, the Seagate ES.2, the Hitachi Ultrastar and Samsung Spinpoint F1, and the RE3 does seem to have the edge.  It is double the cost of the drive I was considering but thanks to all the tips I received, I think I will go with the RE3.
>
> One thing im not sure of: Is load/unload cycle equivalent to start/stop count?  WD has load cycle of 300.000 but Hitach/Samsung only 50.000 for 'start/stop count'.
>
> --andrew
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
