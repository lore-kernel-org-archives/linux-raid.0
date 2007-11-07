From: Paul VanGundy <pvangundy@bradfordnetworks.com>
Subject: Re: Kernel Module - Raid
Date: Wed, 07 Nov 2007 11:51:54 -0500
Message-ID: <4731ED2A.2020107@bradfordnetworks.com>
References: <472F7AED.1030207@bradfordnetworks.com> <472F81B9.2070100@dgreaves.com> <472F840F.2060607@bradfordnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <472F840F.2060607@bradfordnetworks.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

All,

So I was able to get the Adaptec kernel module uncompiled (YES! :)). I
followed the instructions and now when I run 'make menuconfig' I see
that I can make the ADPAHCI a module of the kernel under Device Drivers
- -> SCSI (I belive) -> Low-level -> ADPAHCI. Everything to this point =
is
nice and happy.....However, when I start to compile the kernel I get th=
e
following error once it gets to drivers/scsi/adphaci:

- ----------------------------------------------------------------
CC [M]  drivers/scsi/adpahci/hr.o
In file included from drivers/scsi/adpahci/hr.c:35:
drivers/scsi/adpahci/hr.h:50:26: error: linux/config.h: No such file or
directory
In file included from drivers/scsi/adpahci/cdacsmi.h:47,
                 from drivers/scsi/adpahci/hr.h:96,
                 from drivers/scsi/adpahci/hr.c:35:
drivers/scsi/adpahci/osmcda.h:228: warning: function declaration isn=E2=
=80=99t a
prototype
drivers/scsi/adpahci/osmcda.h:232: warning: function declaration isn=E2=
=80=99t a
prototype
In file included from drivers/scsi/adpahci/sysdef.h:186,
                 from drivers/scsi/adpahci/cdacsmi.h:60,
                 from drivers/scsi/adpahci/hr.h:96,
                 from drivers/scsi/adpahci/hr.c:35:
drivers/scsi/adpahci/cdadef.h:301: warning: useless storage class
specifier in empty declaration
drivers/scsi/adpahci/cdadef.h:314: warning: useless storage class
specifier in empty declaration
drivers/scsi/adpahci/cdadef.h:325: warning: useless storage class
specifier in empty declaration
drivers/scsi/adpahci/cdadef.h:338: warning: useless storage class
specifier in empty declaration
In file included from drivers/scsi/adpahci/cdacsmi.h:60,
                 from drivers/scsi/adpahci/hr.h:96,
                 from drivers/scsi/adpahci/hr.c:35:
drivers/scsi/adpahci/sysdef.h:469:1: warning: "/*" within comment
drivers/scsi/adpahci/sysdef.h:489:1: warning: "/*" within comment
In file included from drivers/scsi/adpahci/chim.h:45,
                 from drivers/scsi/adpahci/sysdef.h:523,
                 from drivers/scsi/adpahci/cdacsmi.h:60,
                 from drivers/scsi/adpahci/hr.h:96,
                 from drivers/scsi/adpahci/hr.c:35:
drivers/scsi/adpahci/chimosm.h:99:5: warning: "SAS_DOWNSHIFT_SUPPORT" i=
s
not defined
drivers/scsi/adpahci/chimosm.h:142:7: warning:
"SAS_PROGRAMABLE_ALIGN_RATE" is not defined
In file included from drivers/scsi/adpahci/chim.h:49,
                 from drivers/scsi/adpahci/sysdef.h:523,
                 from drivers/scsi/adpahci/cdacsmi.h:60,
                 from drivers/scsi/adpahci/hr.h:96,
                 from drivers/scsi/adpahci/hr.c:35:
drivers/scsi/adpahci/chimdef.h:2602:5: warning:
"SATA_MESSAGE_SIGNALED_INTERRUPTS_SUPPORT" is not defined
drivers/scsi/adpahci/chimdef.h:2629:5: warning: "SAS_SAVE_RESTORE_STATE=
"
is not defined
drivers/scsi/adpahci/chimdef.h:2754:5: warning: "SAS_OSM_DEBUG_MODE" is
not defined
In file included from drivers/scsi/adpahci/raidtype.h:56,
                 from drivers/scsi/adpahci/sysdef.h:561,
                 from drivers/scsi/adpahci/cdacsmi.h:60,
                 from drivers/scsi/adpahci/hr.h:96,
                 from drivers/scsi/adpahci/hr.c:35:
drivers/scsi/adpahci/sysdef.h:469:1: warning: "/*" within comment
drivers/scsi/adpahci/sysdef.h:489:1: warning: "/*" within comment
In file included from drivers/scsi/adpahci/sysdef.h:574,
                 from drivers/scsi/adpahci/cdacsmi.h:60,
                 from drivers/scsi/adpahci/hr.h:96,
                 from drivers/scsi/adpahci/hr.c:35:
drivers/scsi/adpahci/sysdev.h:232:5: warning: "PROFILER" is not defined
In file included from drivers/scsi/adpahci/sysdef.h:577,
                 from drivers/scsi/adpahci/cdacsmi.h:60,
                 from drivers/scsi/adpahci/hr.h:96,
                 from drivers/scsi/adpahci/hr.c:35:
drivers/scsi/adpahci/osifprot.h:509: warning: function declaration isn=E2=
=80=99t
a prototype
drivers/scsi/adpahci/osifprot.h:512: warning: function declaration isn=E2=
=80=99t
a prototype
drivers/scsi/adpahci/osifprot.h:531: warning: parameter names (without
types) in function declaration
drivers/scsi/adpahci/osifprot.h:540: warning: function declaration isn=E2=
=80=99t
a prototype
drivers/scsi/adpahci/osifprot.h:552: warning: function declaration isn=E2=
=80=99t
a prototype
drivers/scsi/adpahci/osifprot.h:571: warning: function declaration isn=E2=
=80=99t
a prototype
drivers/scsi/adpahci/osifprot.h:573: warning: function declaration isn=E2=
=80=99t
a prototype
In file included from drivers/scsi/adpahci/sysdef.h:578,
                 from drivers/scsi/adpahci/cdacsmi.h:60,
                 from drivers/scsi/adpahci/hr.h:96,
                 from drivers/scsi/adpahci/hr.c:35:
drivers/scsi/adpahci/coreprot.h:274: warning: function declaration isn=E2=
=80=99t
a prototype
drivers/scsi/adpahci/coreprot.h:281: warning: function declaration isn=E2=
=80=99t
a prototype
drivers/scsi/adpahci/coreprot.h:487: warning: function declaration isn=E2=
=80=99t
a prototype
drivers/scsi/adpahci/coreprot.h:555: warning: function declaration isn=E2=
=80=99t
a prototype
drivers/scsi/adpahci/coreprot.h:741: warning: function declaration isn=E2=
=80=99t
a prototype
In file included from drivers/scsi/adpahci/cdacsmi.h:60,
                 from drivers/scsi/adpahci/hr.h:96,
                 from drivers/scsi/adpahci/hr.c:35:
drivers/scsi/adpahci/sysdef.h:604: warning: useless storage class
specifier in empty declaration
In file included from drivers/scsi/adpahci/cdacsmi.h:60,
                 from drivers/scsi/adpahci/hr.h:96,
                 from drivers/scsi/adpahci/hr.c:35:
drivers/scsi/adpahci/sysdef.h:613:1: warning: "ABORT_TASK" redefined
In file included from drivers/scsi/adpahci/hr.h:71,
                 from drivers/scsi/adpahci/hr.c:35:
include/scsi/scsi.h:277:1: warning: this is the location of the previou=
s
definition
In file included from drivers/scsi/adpahci/cdacsmi.h:66,
                 from drivers/scsi/adpahci/hr.h:96,
                 from drivers/scsi/adpahci/hr.c:35:
drivers/scsi/adpahci/csmisasa.h:117:7: warning: "_WIN32" is not defined
In file included from drivers/scsi/adpahci/cdacsmi.h:66,
                 from drivers/scsi/adpahci/hr.h:96,
                 from drivers/scsi/adpahci/hr.c:35:
drivers/scsi/adpahci/csmisasa.h:184: warning: ignoring #pragma
CSMI_SAS_BEGIN_PACK
drivers/scsi/adpahci/csmisasa.h:257: warning: ignoring #pragma
CSMI_SAS_END_PACK
In file included from drivers/scsi/adpahci/hr.c:35:
drivers/scsi/adpahci/hr.h:134:5: warning: "HR_DEBUG" is not defined
drivers/scsi/adpahci/hr.h:392:1: warning: "roundup" redefined
In file included from include/linux/cache.h:4,
                 from include/asm/pda.h:7,
                 from include/asm/thread_info.h:14,
                 from include/linux/thread_info.h:21,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:49,
                 from include/linux/vmalloc.h:4,
                 from include/asm/io.h:105,
                 from drivers/scsi/adpahci/hr.h:40,
                 from drivers/scsi/adpahci/hr.c:35:
include/linux/kernel.h:43:1: warning: this is the location of the
previous definition
drivers/scsi/adpahci/hr.c:1024:43: error: macro "INIT_WORK" passed 3
arguments, but takes just 2
drivers/scsi/adpahci/hr.c: In function =E2=80=98hr_setup_dev_dpc_task=E2=
=80=99:
drivers/scsi/adpahci/hr.c:1024: error: =E2=80=98INIT_WORK=E2=80=99 unde=
clared (first use
in this function)
drivers/scsi/adpahci/hr.c:1024: error: (Each undeclared identifier is
reported only once
drivers/scsi/adpahci/hr.c:1024: error: for each function it appears in.=
)
drivers/scsi/adpahci/hr.c: In function =E2=80=98hr_pci_init=E2=80=99:
drivers/scsi/adpahci/hr.c:1186: error: implicit declaration of function
=E2=80=98pci_module_init=E2=80=99
drivers/scsi/adpahci/hr.c: In function =E2=80=98hr_register_host=E2=80=99=
:
drivers/scsi/adpahci/hr.c:1560: error: implicit declaration of function
=E2=80=98scsi_assign_lock=E2=80=99
drivers/scsi/adpahci/hr.c: In function =E2=80=98hr_ioctl=E2=80=99:
drivers/scsi/adpahci/hr.c:2444: warning: ignoring return value of
=E2=80=98copy_to_user=E2=80=99, declared with attribute warn_unused_res=
ult
drivers/scsi/adpahci/hr.c:2540: warning: ignoring return value of
=E2=80=98copy_to_user=E2=80=99, declared with attribute warn_unused_res=
ult
drivers/scsi/adpahci/hr.c:2838:5: warning: "_NOTYET_" is not defined
drivers/scsi/adpahci/hr.c: At top level:
drivers/scsi/adpahci/hr.c:2966: warning: initialization from
incompatible pointer type
drivers/scsi/adpahci/hr.c: In function =E2=80=98hr_pci_dev_probe=E2=80=99=
:
drivers/scsi/adpahci/hr.c:3129: warning: =E2=80=98deprecated_irq_flag=E2=
=80=99 is
deprecated (declared at include/linux/interrupt.h:64)
drivers/scsi/adpahci/hr.c:3129: warning: passing argument 2 of
=E2=80=98request_irq=E2=80=99 from incompatible pointer type
drivers/scsi/adpahci/hr.c: In function =E2=80=98hr_watchdog_thread=E2=80=
=99:
drivers/scsi/adpahci/hr.c:3704: error: =E2=80=98PF_FREEZE=E2=80=99 unde=
clared (first use
in this function)
drivers/scsi/adpahci/hr.c: In function =E2=80=98hr_ehandler_thread=E2=80=
=99:
drivers/scsi/adpahci/hr.c:4830: error: =E2=80=98PF_FREEZE=E2=80=99 unde=
clared (first use
in this function)
gmake[5]: *** [drivers/scsi/adpahci/hr.o] Error 1
gmake[4]: *** [drivers/scsi/adpahci] Error 2
gmake[3]: *** [drivers/scsi] Error 2
make[2]: *** [drivers] Error 2
error: Bad exit status from /var/tmp/rpm-tmp.66191 (%build)
- ----------------------------------------------------------------

Sorry for the long output, but that is the entire error so I included
the whole thing.

I guess the thing I am looking for is to ask if anyone else on this lis=
t
has successfully compiled Adaptec modules into the kernel before. I am
also wondering why there are so many errors and undeclared functions. I
did follow the instructions that came with the module and have even
tried over and over again. Thanks.

/paul

Paul VanGundy wrote:
> Thanks for the prompt replay David. Below are the answers to your que=
stions:
>=20
>>> Hello. I don't know if this is the right place to post this issue b=
ut it
>>> does deal with RAID so I thought I would try.
>> It deals primarily with linux *software* raid.
>> But stick with it - you may end up doing that...
>=20
>> What hardware/distro etc are you using?
>> Is this an expensive (hundreds of =C2=A3) card? Or an onboard/mother=
board chipset?
> The distro is Suse 10.1. It is an onboard chipset.
>> Once you answer this then it may be worth suggesting using sw-raid (=
in which
>> case we can help out) or pointing you elsewhere...
>=20
>>> I successfully built a new kernel and am able to boot from it.
>>> However, I need to incorporate a specific RAID driver (adpahci.ko) =
so we
>>> can use the on-board RAID.
>> I think this is the adaptec proprietary code - in which case you may=
 need a very
>> specific kernel to run it. You may find others on here who can help =
but you'll
>> probably need an Adaptec forum/list.
> Oi. This is a pain... ;)
>>> I have the adpahci.ko and am unable to get
>>> it to compile against any other kernel because I don't have the ori=
ginal
>>> kernel module (adpahci.c I assume is what I need). Is there any way=
 I
>>> can view the adpahci.ko and copy the contents to make a adpahci.c?
>> No
> That sucks. :)
>>> Is it
>>> possible to get the kernel object to compile with another kernel on=
ly
>>> using the adpahci.ko?
>> No
>=20
>>> Am I making sense?  :)
>> Yes
> Good, because sometimes I don't make sense to myself. :)
>> That's one of the big reasons proprietary drivers suck on linux.
>=20
> Ok. So this chipset has the ability to use an Intel based RAID. Would
> that be better?
>=20
> Thanks again.
>=20
> /paul
- -
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHMe0Wul+dQkHY548RApPuAJwMDgD9QsTd95KstkBQ9lwYGoMIvQCeNo1+
zod3Ps0tRbgAqaF4ChvWBMc=3D
=3DKtCC
-----END PGP SIGNATURE-----
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
