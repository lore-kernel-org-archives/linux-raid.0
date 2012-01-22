From: linbloke <linbloke@fastmail.fm>
Subject: Re: Raid 6--best practices
Date: Mon, 23 Jan 2012 10:25:45 +1100
Message-ID: <4F1C9AF9.2000201@fastmail.fm>
References: <4F173D3D.6070902@npr.org> <CF17461882827E43AD7DF6E471FFA903834EFD7853@EXCHANGE.ads.npr.org> <CF17461882827E43AD7DF6E471FFA903834EFD7858@EXCHANGE.ads.npr.org>,<CADNH=7Fb5tV+_z4eeOW0K8X+FVtUnaKxtT04qBSh_WQNT+kTDg@mail.gmail.com> <CF17461882827E43AD7DF6E471FFA903834EFD7859@EXCHANGE.ads.npr.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CF17461882827E43AD7DF6E471FFA903834EFD7859@EXCHANGE.ads.npr.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shain Miley <SMiley@npr.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 20/01/12 2:16 PM, Shain Miley wrote:
> Mathias,
> Thank you very much for the helpful advice.
>
> Shain
>
> ________________________________________
> From: Mathias Bur=E9n [mathias.buren@gmail.com]
> Sent: Thursday, January 19, 2012 10:06 PM
> To: Shain Miley
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Raid 6--best practices
>
> On 20 January 2012 02:54, Shain Miley<SMiley@npr.org>  wrote:
>> Hello all,
>> I have been doing some research into possible alternatives to our
>> OpenSolaris/ZFS/Gluster file server.  The main reason behind this is=
,
>> due to RedHat's recent purchase of Gluster, our current configuratio=
n
>> will no longer be supported and even before the acquisition, the upg=
rade
>> path for the OpenSolaris/ZFS stack was murky at best.
>>
>> The current servers in question consist of a total of 48, 2TB drives=
=2E
>> My thought was that I would setup a total of 6 RAID-6 arrays (each
>> containing 7 drives + a spare or a flat 8 drive RAID-6 config) and p=
lace
>> LVM + XFS on top of that.
>>
>> My questions really are:
>>
>> a)    What is the maximum number of drives typically seen in a RAID-=
6
>> setup like this?  I noticed when looking at the Backblaze blog, that
>> they are using RAID-6 with 15 disks (13 + 2 for parity).  That numbe=
r seemed
>> kind of high to me....but I was wondering what others on the list th=
ought.
>>
>> b)    Would you recommend using any specific Linux distro over any o=
ther?
>> Right now I am trying to decide between Debian and Ubuntu....but I w=
ould be open to
>> any others...if there was a legitimate reason to do so (performance,=
 stability, etc) in terms of the Raid codebase.
>>
>> Thanks in advance,
>>
>> Shain
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Hi,
>
> Personally I wouldn't use more than 10 HDDs in a RAID6 setup (+ spare
> perhaps). Regarding the choice of distribution, it doesn't matter
> really. Pick the one you're comfortable with.
>
> Good luck!
>
> /M

Whilst I love Debian, I find the release schedule a bit frustrating. If=
=20
you can hold off until May (a big stretch for projects wanting to go=20
now, I know), then it may be worth looking at Ubuntu 12.04 LTS and get =
5=20
years of supported OS.

https://wiki.ubuntu.com/PrecisePangolin/ReleaseSchedule

Just a thought. Get Debian stability and Ubuntu long term support.

Cheers,

Josh

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
