From: Phil Turmel <philip@turmel.org>
Subject: Re: Storage device enumeration script
Date: Thu, 26 May 2011 07:41:39 -0400
Message-ID: <4DDE3C73.6010504@turmel.org>
References: <4DDDC301.7090608@turmel.org>	<7D.22.00666.3BFEDDD4@cdptpa-omtalb.mail.rr.com> <BANLkTinKG2THYLQUK4Bo-tOamQTvLpQpqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTinKG2THYLQUK4Bo-tOamQTvLpQpqg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>
Cc: lrhorer@satx.rr.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/26/2011 02:16 AM, Mathias Bur=C3=A9n wrote:
> On 26 May 2011 07:14, Leslie Rhorer <lrhorer@satx.rr.com> wrote:
>>
>>        I get an error right off the bat:
>>
>> Traceback (most recent call last):
>>  File "./lsdrv.txt", line 264, in <module>
>>    for x in runx(['pvs', '-o',
>> 'pv_name,pv_used,pv_size,pv_uuid,vg_name,vg_size,vg_free,vg_uuid',
>> '--noheadings', '--separator', ' ']).split("\n"):
>>  File "./lsdrv.txt", line 50, in runx
>>    sub =3D Popen(*args, **kwargs)
>>  File "/usr/lib/python2.6/subprocess.py", line 623, in __init__
>>    errread, errwrite)
>>  File "/usr/lib/python2.6/subprocess.py", line 1141, in _execute_chi=
ld
>>    raise child_exception
>> OSError: [Errno 2] No such file or directory
>>
>> I'm running Python 2.6.6 and mdadm 3.1.4 running on kernel 2.6.32-5-=
amd64
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>=20
> I get that in Ubuntu 11.04 on a laptop as well.
>=20
> /M

Does a plain install of Ubuntu include the LVM utilities?  Can you run =
"pvs" directly?

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
