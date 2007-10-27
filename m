From: Ming Zhang <blackmagic02881@gmail.com>
Subject: Re: [BUG] Raid1/5 over iSCSI trouble
Date: Sat, 27 Oct 2007 17:13:24 -0400
Message-ID: <1193519604.4060.10.camel@localhost.localdomain>
References: <4714BB92.7040701@systella.fr> <471864F8.9010209@systella.fr>
	 <1192809103.30976.11.camel@dwillia2-linux.ch.intel.com>
	 <4718DE66.8000905@tmr.com> <471916B5.6080709@systella.fr>
	 <47191855.4020402@systella.fr> <47191BCF.2000908@systella.fr>
	 <1192828331.30976.26.camel@dwillia2-linux.ch.intel.com>
	 <4719B6DE.9040403@systella.fr> <471EF07A.5040007@systella.fr>
	 <e9c3a7c20710241649qb26c36by5733a93cff394c40@mail.gmail.com>
	 <47233D37.6070409@systella.fr>
Reply-To: blackmagic02881@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <47233D37.6070409@systella.fr>
Sender: sparclinux-owner@vger.kernel.org
To: BERTRAND =?ISO-8859-1?Q?Jo=EBl?= <joel.bertrand@systella.fr>
Cc: Dan Williams <dan.j.williams@intel.com>, Bill Davidsen <davidsen@tmr.com>, linux-raid@vger.kernel.org, sparclinux@vger.kernel.org, iscsitarget-devel@lists.sourceforge.net
List-Id: linux-raid.ids

off topic, could you resubmit the alignment issue patch to list and see
if tomof accept. he needs a patch inlined in email. it is found and
fixed by you, so had better you post it (instead of me). thx.


On Sat, 2007-10-27 at 15:29 +0200, BERTRAND Jo=C3=ABl wrote:
> Dan Williams wrote:
> > On 10/24/07, BERTRAND Jo=C3=ABl <joel.bertrand@systella.fr> wrote:
> >>         Hello,
> >>
> >>         Any news about this trouble ? Any idea ? I'm trying to fix=
 it, but I
> >> don't see any specific interaction between raid5 and istd. Does an=
yone
> >> try to reproduce this bug on another arch than sparc64 ? I only us=
e
> >> sparc32 and 64 servers and I cannot test on other archs. Of course=
, I
> >> have a laptop, but I cannot create a raid5 array on its internal H=
D to
> >> test this configuration ;-)
> >>
> >=20
> > Can you collect some oprofile data, as Ming suggested, so we can ma=
ybe
> > see what md_d0_raid5 and istd1 are fighting about?  Hopefully it is=
 as
> > painless to run on sparc as it is on IA:
> >=20
> > opcontrol --start --vmlinux=3D/path/to/vmlinux
> > <wait>
> > opcontrol --stop
> > opreport --image-path=3D/lib/modules/`uname -r` -l
>=20
> 	Done.
>=20
> Profiling through timer interrupt
> samples  %        image name               app name=20
> symbol name
> 20028038 92.9510  vmlinux-2.6.23           vmlinux-2.6.23           c=
pu_idle
> 1198566   5.5626  vmlinux-2.6.23           vmlinux-2.6.23           s=
chedule
> 41558     0.1929  vmlinux-2.6.23           vmlinux-2.6.23           y=
ield
> 34791     0.1615  vmlinux-2.6.23           vmlinux-2.6.23           N=
Gmemcpy
> 18417     0.0855  vmlinux-2.6.23           vmlinux-2.6.23=20
> xor_niagara_5

raid5 use these 2. forgot to ask if you met any memory pressure here.




> 17430     0.0809  raid456                  raid456                  (=
no=20
> symbols)
> 15837     0.0735  vmlinux-2.6.23           vmlinux-2.6.23=20
> sys_sched_yield
> 14860     0.0690  iscsi_trgt.ko            iscsi_trgt               i=
std

could you get a call graph from oprofile. the yield is called quite
frequently. iet has some place to call it when no memory available. not
sure if this is the case.

i remember there was a post (maybe in lwn.net?) about some issues
between tickless kernel and yield() lead to 100% cpu utilization, i jus=
t
could not recalled the place, anybody have a clue?

or sparc64 does not have tickless kernel yet? did not follow these
carefully these days.


> 12705     0.0590  nf_conntrack             nf_conntrack             (=
no=20
> symbols)
> 9236      0.0429  libc-2.6.1.so            libc-2.6.1.so            (=
no=20
> symbols)
> 9034      0.0419  vmlinux-2.6.23           vmlinux-2.6.23=20
> xor_niagara_2
> 6534      0.0303  oprofiled                oprofiled                (=
no=20
> symbols)
> 6149      0.0285  vmlinux-2.6.23           vmlinux-2.6.23=20
> scsi_request_fn
> 5947      0.0276  ip_tables                ip_tables                (=
no=20
> symbols)
> 4510      0.0209  vmlinux-2.6.23           vmlinux-2.6.23=20
> dma_4v_map_single
> 3823      0.0177  vmlinux-2.6.23           vmlinux-2.6.23=20
> __make_request
> 3326      0.0154  vmlinux-2.6.23           vmlinux-2.6.23           t=
g3_poll
> 3162      0.0147  iscsi_trgt.ko            iscsi_trgt=20
> scsi_cmnd_exec
> 3091      0.0143  vmlinux-2.6.23           vmlinux-2.6.23=20
> scsi_dispatch_cmd
> 2849      0.0132  vmlinux-2.6.23           vmlinux-2.6.23=20
> tcp_v4_rcv
> 2811      0.0130  vmlinux-2.6.23           vmlinux-2.6.23=20
> nf_iterate
> 2729      0.0127  vmlinux-2.6.23           vmlinux-2.6.23=20
> _spin_lock_bh
> 2551      0.0118  vmlinux-2.6.23           vmlinux-2.6.23           k=
free
> 2467      0.0114  vmlinux-2.6.23           vmlinux-2.6.23=20
> kmem_cache_free
> 2314      0.0107  vmlinux-2.6.23           vmlinux-2.6.23=20
> atomic_add
> 2065      0.0096  vmlinux-2.6.23           vmlinux-2.6.23=20
> NGbzero_loop
> 1826      0.0085  vmlinux-2.6.23           vmlinux-2.6.23           i=
p_rcv
> 1823      0.0085  nf_conntrack_ipv4        nf_conntrack_ipv4        (=
no=20
> symbols)
> 1822      0.0085  vmlinux-2.6.23           vmlinux-2.6.23=20
> clear_bit
> 1767      0.0082  python2.4                python2.4                (=
no=20
> symbols)
> 1734      0.0080  vmlinux-2.6.23           vmlinux-2.6.23=20
> atomic_sub_ret
> 1694      0.0079  vmlinux-2.6.23           vmlinux-2.6.23=20
> tcp_rcv_established
> 1673      0.0078  vmlinux-2.6.23           vmlinux-2.6.23=20
> tcp_recvmsg
> 1670      0.0078  vmlinux-2.6.23           vmlinux-2.6.23=20
> netif_receive_skb
> 1668      0.0077  vmlinux-2.6.23           vmlinux-2.6.23           s=
et_bit
> 1545      0.0072  vmlinux-2.6.23           vmlinux-2.6.23=20
> __kmalloc_track_caller
> 1526      0.0071  iptable_nat              iptable_nat              (=
no=20
> symbols)
> 1526      0.0071  vmlinux-2.6.23           vmlinux-2.6.23=20
> kmem_cache_alloc
> 1373      0.0064  vmlinux-2.6.23           vmlinux-2.6.23=20
> generic_unplug_device
> ...
>=20
> 	Is it enough ?
>=20
> 	Regards,
>=20
> 	JKB
--=20
Ming Zhang


@#$%^ purging memory... (*!%
http://blackmagic02881.wordpress.com/
http://www.linkedin.com/in/blackmagic02881
--------------------------------------------

-
To unsubscribe from this list: send the line "unsubscribe sparclinux" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
