From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH mdadm] raid6check.c: fix "misleading-indentation" error
Date: Wed, 26 Oct 2016 06:50:42 +1100
Message-ID: <87funkus19.fsf@notabene.neil.brown.name>
References: <1477374077-4195-1-git-send-email-yilongx.ren@intel.com> <wrfjmvhsskou.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjmvhsskou.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>, renyl <yilongx.ren@intel.com>
Cc: LKP <lkp@eclists.intel.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 25 2016, Jes Sorensen wrote:

> renyl <yilongx.ren@intel.com> writes:
>> From: Yilong Ren <yilongx.ren@intel.com>
>>
>> To fix the following error info:
>>
>> root@vm-lkp-nex04-8G-7 /tmp/mdadm# make test
>> cc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter -ggdb=
 -DSendmail=3D\""/usr/sbin/sendmail -t"\" -DCONFFILE=3D\"/etc/mdadm.conf\" =
-DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\" -DMAP_DIR=3D\"/run/mdadm\" -DMAP_FI=
LE=3D\"map\" -DMDMON_DIR=3D\"/run/mdadm\" -DFAILED_SLOTS_DIR=3D\"/run/mdadm=
/failed-slots\" -DNO_COROSYNC -DNO_DLM -DVERSION=3D\"3.4-43-g1dcee1c\" -DVE=
RS_DATE=3D"\"06th April 2016\"" -DUSE_PTHREADS -DBINDIR=3D\"/sbin\"  -c -o =
raid6check.o raid6check.c
>> raid6check.c: In function 'manual_repair':
>> raid6check.c:267:4: error: this 'else' clause does not guard... [-Werror=
=3Dmisleading-indentation]
>>     else
>>     ^~~~
>> raid6check.c:269:5: note: ...this statement, but the latter is misleadin=
gly indented as if it is guarded by the 'else'
>>      printf("Repairing D(%d) and P\n", failed_data);
>>      ^~~~~~
>> cc1: all warnings being treated as errors
>> <builtin>: recipe for target 'raid6check.o' failed
>> make: *** [raid6check.o] Error 1
>> root@vm-lkp-nex04-8G-7 /tmp/mdadm#=20
>>
>>
>> Cc: NeilBrown <neilb@suse.com>
>> Cc: linux-raid <linux-raid@vger.kernel.org>
>> Cc: LKP <lkp@eclists.intel.com>
>> Signed-off-by: Yilong Ren <yilongx.ren@intel.com>
>> ---
>>  raid6check.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/raid6check.c b/raid6check.c
>> index ad7ffe7..acfc9a3 100644
>> --- a/raid6check.c
>> +++ b/raid6check.c
>> @@ -264,9 +264,10 @@ int manual_repair(int chunk_size, int syndrome_disk=
s,
>>  			int failed_data;
>>  			if (failed_slot1 =3D=3D -1)
>>  				failed_data =3D failed_slot2;
>> -			else
>> +			else {
>>  				failed_data =3D failed_slot1;
>>  				printf("Repairing D(%d) and P\n", failed_data);
>> +			}
>>  			raid6_datap_recov(syndrome_disks+2, chunk_size,
>>  					  failed_data, (uint8_t**)blocks, 1);
>>  		} else {
>
> Hi,
>
> I suspect this patch is wrong and the code is meant to print in either
> case.
>
> Neil?

Looking at the whole=20

	if (failed_slot1 =3D=3D -2 || failed_slot2 =3D=3D -2) {

statement it looks like every path through should print a message, and
this section would be more similar to the previous section if, as you
say, the code prints in either case.

So I agree: original code is correct, indentation is wrong.

NeilBrown

>
> Cheers,
> Jes

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYD7eSAAoJEDnsnt1WYoG5emIQAIcPH0ORlzLoDGaqPEske6J+
/yMJl0jLR0fgxlZUAr4HjjBhwlDAXPVpLLmr9i6kcYI9TNvAbGU5n75JVLmKLGqa
Qz3by/bnnV+TrxYJhikpaiQU+GLjPHnMj21NYeGd01p++fIOopjUY++mrcZGCXnk
VqVXQjolXnx/e+bik2Yakdd75uGUVuXumy2LakCK2zNOHE+4ITq4JicvyfUTqxiq
a6ldZlriOuiK7OoIoVFK8xs/K8giNMoAf0Nbw8BXpbTgOcf0bxQPEL/hDscuv6VX
D8fJJYY+m9NyTXZ0nxN/o35sNBal++y+Tt+Fj45ch8bnMXrtXiwngkBdHwBAczEI
0eeU1+Yfse41tHpr3khjn2pmKKP2Mmni1aMeRN8WlbQUXbXYSX62ioEaRxdz17NR
dXQgltwn2jJ+SJkQ/b9KYhjbiOKSR7k3ryA47xf9+1IY0eSKVPNOqC1C3d/g8H10
ze1SmO2QPsdXZrGrOQrOKPEZ1crf4hCls8PSW7uly/x5bDTKW0qyiLhq2ggO7Hy/
6ElVNRWeBG49KjwsTMTbOIQ2iUOnvu3vEk+YyjD7FfpXYreiWN6/iYorfGb655kR
/4NytpPqjQGMCQospQqqcsfa+sM0bSOwNPpCcnrJ3LnBsy3FiFCFZJ6plipVwDJN
b7R9SuvdjNmNzXWNUNon
=9VYF
-----END PGP SIGNATURE-----
--=-=-=--
