From: David Brown <david.brown@hesbynett.no>
Subject: Re: Status of Tripe Parity RAID
Date: Thu, 07 Aug 2014 21:34:49 +0200
Message-ID: <53E3D4D9.1050502@hesbynett.no>
References: <D00269CC.3E6BB%ronnyegner@ronnyegner-consulting.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D00269CC.3E6BB%ronnyegner@ronnyegner-consulting.de>
Sender: linux-raid-owner@vger.kernel.org
To: Ronny Egner <ronnyegner@ronnyegner-consulting.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/08/14 10:11, Ronny Egner wrote:
> Dear All,
>
> i would like to ask about the status of Tripe Parity RAID.
>
> I=B4ve found some posts on the list from Andrea Mazzoleni dating back=
 to
> 2013
> but after that nothing seemed to be moving.
>
> If this is currently not on the wish list i would like to add that as
> Feature Request :-)
>
>
> Thanks Neil for this great piece of software.
>

I believe Andrea got the code working for doing the multiple parity rai=
d=20
calculations, but I don't know how complete it is.  I have looked at hi=
s=20
maths, and agree that it is solid - and I think the general opinion is=20
that he has found the best algorithms for the task (better than the one=
=20
I came up with, and better than the one used by ZFS for triple parity).

As far as I know, no work has been done on integrating this into the md=
=20
code itself, nor into the mdadm code.

As Neil says, we don't need a feature request on this - it is already=20
requested.  We need someone who is able to spend the time putting it=20
together.  The mathematical bit is in place, so it doesn't have to be a=
=20
person (or people) who understands that part so well.


David


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
