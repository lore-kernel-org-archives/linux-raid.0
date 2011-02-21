From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: SSD - TRIM command
Date: Mon, 21 Feb 2011 15:25:03 -0300
Message-ID: <AANLkTim6qJRZABYj4y_1sL6xq7y_w-STbaC4MK3U05ug@mail.gmail.com>
References: <AANLkTikfeH_n04iJ=5e=_G4a_GrxiWyZNJ1oCYyiBhNO@mail.gmail.com>
	<4D517F4F.4060003@gmail.com>
	<4D5245DF.4020401@hardwarefreak.com>
	<iiu4rc$9ju$1@dough.gmane.org>
	<AANLkTi=WNk3=3Jwm-YJeujcrdh-OQ4W4mJrq+YJ5Xv4k@mail.gmail.com>
	<iiud2r$qci$1@dough.gmane.org>
	<4D62ACFE.4020401@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D62ACFE.4020401@cfl.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

TRIM is a new feature for many hard disk/ssd
it=B4s more to get a bigger life o disk, allow a dynamic badblock
reallocation (filesystem must tell where is empty)


2011/2/21 Phillip Susi <psusi@cfl.rr.com>:
> On 2/9/2011 10:49 AM, David Brown wrote:
>> I've been reading a little more about this. =A0It seems that the day=
s of
>> TRIM may well be numbered - the latest generation of high-end SSDs h=
ave
>> more powerful garbage collection algorithms, together with more spar=
e
>> blocks, making TRIM pretty much redundant. =A0This is, of course, th=
e most
>> convenient solution for everyone (as long as it doesn't cost too muc=
h!).
>>
>> The point of the TRIM command is to tell the SSD that a particular b=
lock
>> is no longer being used, so that the SSD can erase it in the backgro=
und
>> - that way when you want to write more data, there are more free blo=
cks
>> ready and waiting. =A0But if you've got plenty of spare blocks, it's=
 easy
>> to have them erased in advance and you don't need TRIM.
>
> It is not just about having free blocks ready and waiting. =A0When do=
ing
> wear leveling, you might find an erase block that has not been writte=
n
> to in a long time, so you want to move that data to a more worn block=
,
> and use the less worn block for more frequently written to sectors. =A0=
If
> you know that sectors are unused because they have been TRIMed, then =
you
> don't have to waste time and wear copying the junk there to the new
> flash block.
>
> TRIM is also quite useful for thin provisioned storage, which seems t=
o
> be getting popular.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
