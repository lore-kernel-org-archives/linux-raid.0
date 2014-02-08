From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Storage system
Date: Fri, 7 Feb 2014 17:14:57 -0700
Message-ID: <BAEB6EB8-6D73-40A8-8250-85B15645E629@colorremedies.com>
References: <20140206180909.GA2419@lazy.lzy>	<52F49433.8080904@hesbynett.no> <CAJvUf-BTjmxonub0eWGNm1YNp4zYis5Mgti9FuRiQ8RbVY3cXQ@mail.gmail.com> <52F505B3.2050902@hesbynett.no> <52F508EF.7090808@gmail.com> <52F50B7B.8020902@hesbynett.no>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52F50B7B.8020902@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Can Jeuleers <can.jeuleers@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Feb 7, 2014, at 9:36 AM, David Brown <david.brown@hesbynett.no> wrot=
e:

> On 07/02/14 17:25, Can Jeuleers wrote:
>> On 02/07/2014 05:11 PM, David Brown wrote:
>>> The only thing you can't erase are re-mapped sectors - but hopefull=
y
>>> those will be rare!
>>=20
>> I wonder if using the Secure Erase feature destroys all sectors
>> (including remapped-ones) or not.
>>=20
>=20
> I think secure erase can be done in different ways.  On disks that ha=
ve
> full-disk encryption, it simply erases (or changes) the password.  Fo=
r
> other drives, it has to write through all sectors on the disk - I wou=
ld
> expect re-mapped sectors are included, but I don't know the details.

=46rom the September 2012 draft, rev 1 of NIST 800-80, they distinguish=
 between the following ATA commands:

	=95 ATA sanitize command
	=95 ATA Secure Erase command
	=95 Cryptographic Erase

I don't have a clear understanding of what "sanitize" command is, altho=
ugh it's relatively new. None of my drives have it. hdparm reports my d=
rives support SECURITY ERASE UNIT and ENHANCED SECURITY ERASE UNIT. For=
 HDDs, these take the same time. The first one writes zeros. The 2nd on=
e writes a manufacturer defined pattern (i.e. it's almost certainly not=
 random). The Samsung 830 SSD also has these two commands, but the time=
 difference between them was substantial: I *think* 3 minutes for one a=
nd 18 minutes for the other.

Cryptographic erase doesn't overwrite anything. It just makes sure the =
MEKs are changed, thereby making the drive unreadable, since SEDs are a=
lways encrypting using a MEK, even if there isn't a KEK set.


>=20
>=20
>> Also, what level of trust do people on this list have that the disk'=
s
>> Secure Erase feature does what it says on the tin?\

Again NIST 800-80 says: "Verification must be performed for each techni=
que within Clear and Purge, except degaussing." Strictly speaking the t=
rust is zero without verification.

Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
