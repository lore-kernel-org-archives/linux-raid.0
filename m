From: Marcus <nexuslite@gmail.com>
Subject: Re: Raid 5 Array
Date: Sat, 2 Apr 2011 16:06:58 -0700
Message-ID: <BANLkTi=wWAE79KOPhZ0OUWpicgcD7QNG-g@mail.gmail.com>
References: <BANLkTim8620MUckc+EVCWo9FCTs=65_p8Q@mail.gmail.com>
	<4D977279.30107@gmail.com>
	<BANLkTimJfUhvkpkkAH=NLJOvLL-Jotrwqg@mail.gmail.com>
	<4D97828C.8050806@gmail.com>
	<6158157523854459259@unknownmsgid>
	<20110403040113.472838d4@natsu>
	<AANLkTikJtFb0JtS1-Je9NFXn-CRc4pi7pmYFNV7v2SEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikJtFb0JtS1-Je9NFXn-CRc4pi7pmYFNV7v2SEg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Roman Mamedov <rm@romanrm.ru>, Simon Mcnair <simonmcnair@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I am running a raid 5 only. The raid 0 is to make a number of smaller
drives larger. Because a raid 5 takes the smallest drive and applies
it to all drives.

The original raid started off as a 26GB raid 5 with a 13GB, 40GB and a
160GB drive and I have grown it from there to its current size which
is 1TB.

I bought another 1TB drive yesterday and am trying to combine a 500GB
and a 250GB drive to make a 750GB drive so I can push the raid up
again this time to 1.5TB.

The last configuration was a raid0 md0 320GB (160GB, 160GB), raid 0
md1 570GB (md0, 250GB), raid 5 1TB (md1, 500GB, 1.0TB) which has been
extremely stable for the last 3 months but ran out of space.

The configuration I am trying to achieve is raid0 md0 750GB (250GB,
500GB) , raid 5 md2 1.5TB (md0, 1.0TB, 1.0TB)

This started out as an experiment to see if I could do a raid 5
system. It was originally built with drives I had laying around the
house. Now it is big enough that I have started buying drives for it.
I have gone through many configurations of extra drives to get it
where it is now. I have had 1 catastrophic failure since I started and
that was the last time I made it bigger. I was running on 2 drives one
of them being the md0, md1 configuration and mdadm got confused and
couldn't put md0 and md1 back together to have 2 working drives. I
probably could have corrected the problem if I knew what I know now
but as this is an experimental raid it is a learning process.

The current problem I am having is every time I try to apply the 750GB
raid drive to the raid 5 it corrupts the headers and 1 of the arrays
report the wrong size. Which causes it not to mount. The only way to
correct the problem seems to be to unplug the two drives that make up
md0 and reboot onto 2 drives then start the process again. I am
currently working on my 3rd attempt to integrate the 750GB raid drive.
Each attempt takes 4 hours to restore the drive so it has been a long
process. I haven't lost the data yet though so I guess I will keep
trying. Hopefully it won't be too corrupt when I am done.



On Sat, Apr 2, 2011 at 3:04 PM, Roberto Spadim <roberto@spadim.com.br> =
wrote:
> why use raid 5,6? raid1 isn=B4t more secure?
>
> 2011/4/2 Roman Mamedov <rm@romanrm.ru>:
>> On Sat, 2 Apr 2011 22:45:58 +0100
>> Simon Mcnair <simonmcnair@gmail.com> wrote:
>>
>>> One last thing.... I've never heard of anyone using a raid 05. Why
>>> wouldn't you use a RAID50 ? =A0Please can you dish the dirt on what
>>> benefit there is ? (I would have thought a raid50 would have been
>>> better with no disadvantages ?). I thought that raid10 & 50 were th=
e
>>> main ones in use in 'the industry'.
>>
>> RAID5/6 with some RAID0 (or JBOD) members is what you use when you w=
ant to
>> include differently-sized devices into the array:
>> http://louwrentius.com/blog/2008/08/building-a-raid-6-array-of-mixed=
-drives/
>> --
>> With respect,
>> Roman
>>
>
>
>
> --
> Roberto Spadim
> Spadim Technology / SPAEmpresarial
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
