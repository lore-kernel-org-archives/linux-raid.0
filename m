From: mru@kth.se (=?iso-8859-1?q?M=E5ns_Rullg=E5rd?=)
Subject: Re: raid0_make_request bug: can't convert block across chunks or
 bigger than
Date: Wed, 07 Jan 2004 11:49:31 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <yw1xvfnouj7o.fsf@ford.guide>
References: <yw1xznd0ult1.fsf@ford.guide>
	<20040107023332.5ff0b9ff.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20040107023332.5ff0b9ff.akpm@osdl.org> (Andrew Morton's
 message: 33:32 -0800")
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andrew Morton <akpm@osdl.org> writes:

> mru@kth.se (M=E5ns Rullg=E5rd) wrote:
>>
>> I'm using Linux 2.6.0 on an Alpha SX164 machine.  Using four ATA
>>  disks, hd[egik], on a Highpoint hpt374 controller, I created two ra=
id0
>>  arrays from hd[eg]1 and hd[ik]1, md0 and md1.  From these, I create=
d a
>>  raid1 mirror, md4, on which I created an XFS filesystem.  For vario=
us
>>  reasons, I first ran md4 with only md0 as a member and filled it wi=
th
>>  some files, all going well.  Then, I added md1, and it was synced
>>  properly.  Now, I can mount md4 without problems.  However, when I
>>  read things, I get this in the kernel log:
>>=20
>>  raid0_make_request bug: can't convert block across chunks or bigger=
 than 32k 439200 32
>
> This was fixed post-2.6.0.  2.6.1-rc2 should be OK.

I just noticed.

>>  raid1: Disk failure on md1, disabling device.=20
>>  	Operation continuing on 1 devices
>
> I assume this is due to the raid0 error above.

I should think so.

I'm still curious as to why it was only md1 that gave errors, and
never md0.  Was it just coincidence?

--=20
M=E5ns Rullg=E5rd
mru@kth.se
