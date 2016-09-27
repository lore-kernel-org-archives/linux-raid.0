From: Benjammin2068 <benjammin2068@gmail.com>
Subject: Re: WARNING: mismatch_cnt is not 0 on <array device>
Date: Mon, 26 Sep 2016 20:08:24 -0500
Message-ID: <c7bfde3e-0605-96d0-4e3d-fb76a9a8c724@gmail.com>
References: <26b91420-97c9-f405-aa71-16cd5cda3a67@gmail.com>
 <409d9f5f-6f72-a399-93ab-2b10323f4122@fnarfbargle.com>
 <c72d3567-7c9c-39dc-c2e1-722bc267bdd6@gmail.com>
 <74e5712f-e89e-97af-8aa4-ae2948c02e94@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <74e5712f-e89e-97af-8aa4-ae2948c02e94@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On 09/26/2016 04:15 PM, Phil Turmel wrote:
> On 09/26/2016 03:47 PM, Benjammin2068 wrote:
>> Well that instills fear and doubt...
>>
>> the mismatch_cnt was 8.
>>
>> I did a repair and then a check and now it's 10704....
>>
>> :(
> Danger Will Robinson!
>
> Seriously.  You very likely have a hardware problem corrupting your
> data.  Do you have ECC RAM, and if not, when was the last time you did
> an exhaustive memtest?

ECC RAM: Yes.

MEMtest - not for a while. Will do. Have to take my server down for that.

This problem has only popped up since putting in this new controller *AND* expanding the RAID to a drive on this controller when changing RAID5 with 4 members (using MB SATA ports) to RAID6 using 5 members that includes 2 drives on new controller of which 1 is a hot spare.

(and the controller is a Marvell 88SE9485 - anyone know of any problems with this controller? It's a x8 controller living in a x8 slot.

> Recheck all of your data cables and if using an add-on controller, check
> for a secure install in the PCIe slot.
>

Will do.

Is there way to verify if that 5th drive is "the problem drive"?

Also, I just did a "repair" and the mismatch is now back to 8... which seems like a suspicious number considering the filesystem on this new drive (because it's a WD10 series with 4096byte sectors) has a slightly larger FS than the Samsung HD103SJ (and Seagate equivalents) in the array too.

And I just found this:

https://www.thomas-krenn.com/en/wiki/Mdadm_checkarray

Which says, "It could simply be that the system does not care what is stored on that part of the array - it is unused space."

I have WD10 drives that have this "extra space" thing going on because of their 4096byte sector size thing. (see previous posts about that to this list.)

 -Ben

