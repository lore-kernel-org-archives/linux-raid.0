From: Vasco =?iso-8859-15?b?Tul2b2E=?= <vasco.nevoa@sapo.pt>
Subject: Re: how to recover filesystem after clobbering array?
Date: Tue, 19 Jul 2011 10:46:41 +0100
Message-ID: <20110719104641.18055wdwaxq9rr0h@mail.sapo.pt>
References: <20110719104325.16112cl7f4lrzkjh@mail.sapo.pt>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	DelSp=Yes	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110719104325.16112cl7f4lrzkjh@mail.sapo.pt>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Oh, the type of array is Raid 1.

Citando Vasco N=E9voa <vasco.nevoa@sapo.pt>:

>
> Hello people.
>
> I've messed up good, and now I need you nice folks to help me =20
> recover 500GB of irreplaceable home video, the full 7 years of my =20
> family trove. :(
>
> I mistakenly used mdadm to *create* an array instead of *starting* =20
> the array (big Duh!). Now the array has no partition table. I =20
> shudder to think I may have clobbered not only the array but also =20
> the file system. I hardly slept last night. Acceptance is a process. =
=20
> :/
>
> I've learned my lesson there, no more fiddling with "--assume-clean" =
=20
> (which was a stupid idea in the first place), but the issue remains: =
=20
> how do I get to the file system that I know is still there? The =20
> array is up but obviously it was never mounted.
>
> Can I just recreate the partition table and it works?.... or do I =20
> have to use some complex form of forensics to recover the data?
>
> Thank you very much,
> Vasco.
>
>
>


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
