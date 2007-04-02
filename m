From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Subject: Re: raid5 write performance
Date: Mon, 2 Apr 2007 17:13:43 +0300
Message-ID: <5d96567b0704020713s6ae02102kaeca12edfb663cb1@mail.gmail.com>
References: <5d96567b0607020702p25d66490i79445bac606e5210@mail.gmail.com>
	 <17576.18978.563672.656847@cse.unsw.edu.au>
	 <5d96567b0608130619w60d8d883q4ffbfefcf650ee82@mail.gmail.com>
	 <17650.29175.778076.964022@cse.unsw.edu.au>
	 <5d96567b0703301444j9b416c2nbc5ce27487eef5bc@mail.gmail.com>
	 <e9c3a7c20704011608lb1fcb55j628a7d1172812869@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_108472_14699732.1175523223384"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20704011608lb1fcb55j628a7d1172812869@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Neil Brown <neilb@suse.de>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

------=_Part_108472_14699732.1175523223384
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 4/2/07, Dan Williams <dan.j.williams@intel.com> wrote:
> On 3/30/07, Raz Ben-Jehuda(caro) <raziebe@gmail.com> wrote:
> > Please see bellow.
> >
> > On 8/28/06, Neil Brown <neilb@suse.de> wrote:
> > > On Sunday August 13, raziebe@gmail.com wrote:
> > > > well ... me again
> > > >
> > > > Following your advice....
> > > >
> > > > I added a deadline for every WRITE stripe head when it is created.
> > > > in raid5_activate_delayed i checked if deadline is expired and if not i am
> > > > setting the sh to prereadactive mode as .
> > > >
> > > > This small fix ( and in few other places in the code) reduced the
> > > > amount of reads
> > > > to zero with dd but with no improvement to throghput. But with random access to
> > > > the raid  ( buffers are aligned by the stripe width and with the size
> > > > of stripe width )
> > > > there is an improvement of at least 20 % .
> > > >
> > > > Problem is that a user must know what he is doing else there would be
> > > > a reduction
> > > > in performance if deadline line it too long (say 100 ms).
> > >
> > > So if I understand you correctly, you are delaying write requests to
> > > partial stripes slightly (your 'deadline') and this is sometimes
> > > giving you a 20% improvement ?
> > >
> > > I'm not surprised that you could get some improvement.  20% is quite
> > > surprising.  It would be worth following through with this to make
> > > that improvement generally available.
> > >
> > > As you say, picking a time in milliseconds is very error prone.  We
> > > really need to come up with something more natural.
> > > I had hopped that the 'unplug' infrastructure would provide the right
> > > thing, but apparently not.  Maybe unplug is just being called too
> > > often.
> > >
> > > I'll see if I can duplicate this myself and find out what is really
> > > going on.
> > >
> > > Thanks for the report.
> > >
> > > NeilBrown
> > >
> >
> > Neil Hello. I am sorry for this interval , I was assigned abruptly to
> > a different project.
> >
> > 1.
> >   I'd taken a look at the raid5 delay patch I have written a while
> > ago. I ported it to 2.6.17 and tested it. it makes sounds of working
> > and when used correctly it eliminates the reads penalty.
> >
> > 2. Benchmarks .
> >     configuration:
> >      I am testing a raid5 x 3 disks with 1MB chunk size.  IOs are
> > synchronous and non-buffered(o_direct) , 2 MB in size and always
> > aligned to the beginning of a stripe. kernel is 2.6.17. The
> > stripe_delay was set to 10ms.
> >
> >  Attached is the simple_write code.
> >
> >          command :
> >                simple_write /dev/md1 2048 0 1000
> >                        simple_write raw writes (O_DIRECT) sequentially
> > starting from offset zero 2048 kilobytes 1000 times.
> >
> > Benchmark Before patch
> >
> > sda            1848.00      8384.00     50992.00       8384      50992
> > sdb            1995.00     12424.00     51008.00      12424      51008
> > sdc            1698.00      8160.00     51000.00       8160      51000
> > sdd               0.00         0.00         0.00          0          0
> > md0               0.00         0.00         0.00          0          0
> > md1             450.00         0.00    102400.00          0     102400
> >
> >
> > Benchmark After patch
> >
> > sda             389.11         0.00    128530.69          0     129816
> > sdb             381.19         0.00    129354.46          0     130648
> > sdc             383.17         0.00    128530.69          0     129816
> > sdd               0.00         0.00         0.00          0          0
> > md0               0.00         0.00         0.00          0          0
> > md1            1140.59         0.00    259548.51          0     262144
> >
> > As one can see , no additional reads were done. One can actually
> > calculate  the raid's utilization: n-1/n * ( single disk throughput
> > with 1M writes ) .
> >
> >
> >       3.  The patch code.
> >           Kernel tested above was 2.6.17. The patch is of 2.6.20.2
> > because I have noticed a big code differences between 17 to 20.x .
> > This patch was not tested on 2.6.20.2 but it is essentialy the same. I
> > have not tested (yet) degraded mode or any other non-common pathes.
> >
> This is along the same lines of what I am working on, new cache
> policies for raid5/6, so I want to give it a try as well.
> Unfortunately gmail has mangled your patch.  Can you resend as an
> attachment?
>
> patch: **** malformed patch at line 10:
> (&((conf)->stripe_hashtbl[((sect) >> STRIPE_SHIFT) & HASH_MASK]))
>
> Thanks,
> Dan
>

Dan hello.
Attached are the patches. Also , I have added another test unit : random_writev.
It is not much of a code but it does the work. It tests writing a
vector .it shows the same results as writing using a single buffer.

What is the new cache poilcies ?

Please note !
I haven't indented the patch nor did the instructions according to
SubmitingPatches document. If Neil would approve this patch or parts
of it, I will do so.

# Benchmark 3:  Testing  8 disks raid5.

Tyan Numa dual (amd) CPU machine, with 8 sata maxtor disks, controller
is promise
in jbod mode.

raid conf:
md1 : active raid5 sda2[0] sdh1[7] sdg1[6] sdf1[5] sde1[4] sdd1[3]
sdc1[2] sdb2[1]
      3404964864 blocks level 5, 1024k chunk, algorithm 2 [8/8] [UUUUUUUU]

In order to achieve zero reads I had to tune the deadline to 20ms ( so
long ? ). stripe_cache_size is 256 which is exactly what is needed to
preform a full stripe hit
with this configuration.

> comand:    random_writev /dev/md1 7168 0 3000 10000

iostats snapshot

avg-cpu:  %user   %nice    %sys %iowait   %idle
           0.00    0.00   21.00   29.00   50.00

Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
hda               0.00         0.00         0.00          0          0
md0               0.00         0.00         0.00          0          0
sda             234.34         0.00     50400.00          0      49896
sdb             235.35         0.00     50658.59          0      50152
sdc             242.42         0.00     51014.14          0      50504
sdd             246.46         0.00     50755.56          0      50248
sde             248.48         0.00     51272.73          0      50760
sdf             245.45         0.00     50755.56          0      50248
sdg             244.44         0.00     50755.56          0      50248
sdh             245.45         0.00     50755.56          0      50248
md1            1407.07         0.00    347741.41          0     344264

Try setting it the stripe_cace_size to 255 and you will notice the delay.
Try lowering with the stripe_deadline and you will notice how the amount
of reads grow.

Cheers
-- 
Raz

------=_Part_108472_14699732.1175523223384
Content-Type: text/x-patch; name=raid5_write.c.patch; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f00yrld7
Content-Disposition: attachment; filename="raid5_write.c.patch"

ZGlmZiAtcnVOIC1YIGxpbnV4LTIuNi4yMC4yL0RvY3VtZW50YXRpb24vZG9udGRpZmYgbGludXgt
Mi42LjIwLjIvZHJpdmVycy9tZC9yYWlkNS5jIGxpbnV4LTIuNi4yMC4yLXJhaWQvZHJpdmVycy9t
ZC9yYWlkNS5jCi0tLSBsaW51eC0yLjYuMjAuMi9kcml2ZXJzL21kL3JhaWQ1LmMJMjAwNy0wMy0w
OSAyMDo1ODowNC4wMDAwMDAwMDAgKzAyMDAKKysrIGxpbnV4LTIuNi4yMC4yLXJhaWQvZHJpdmVy
cy9tZC9yYWlkNS5jCTIwMDctMDMtMzAgMTI6Mzc6NTUuMDAwMDAwMDAwICswMzAwCkBAIC02NSw2
ICs2NSw3IEBACiAjZGVmaW5lIE5SX0hBU0gJCQkoUEFHRV9TSVpFIC8gc2l6ZW9mKHN0cnVjdCBo
bGlzdF9oZWFkKSkKICNkZWZpbmUgSEFTSF9NQVNLCQkoTlJfSEFTSCAtIDEpCiAKKwogI2RlZmlu
ZSBzdHJpcGVfaGFzaChjb25mLCBzZWN0KQkoJigoY29uZiktPnN0cmlwZV9oYXNodGJsWygoc2Vj
dCkgPj4gU1RSSVBFX1NISUZUKSAmIEhBU0hfTUFTS10pKQogCiAvKiBiaW8ncyBhdHRhY2hlZCB0
byBhIHN0cmlwZStkZXZpY2UgZm9yIEkvTyBhcmUgbGlua2VkIHRvZ2V0aGVyIGluIGJpX3NlY3Rv
cgpAQCAtMjM0LDYgKzIzNSw4IEBACiAJc2gtPnNlY3RvciA9IHNlY3RvcjsKIAlzaC0+cGRfaWR4
ID0gcGRfaWR4OwogCXNoLT5zdGF0ZSA9IDA7CisJc2gtPmFjdGl2ZV9wcmVyZWFkX2ppZmZpZXMg
PQorICAgICAgICAJCW1zZWNzX3RvX2ppZmZpZXMoIGF0b21pY19yZWFkKCZjb25mLT5kZWFkbGlu
ZV9tcykgKSsgamlmZmllczsKIAogCXNoLT5kaXNrcyA9IGRpc2tzOwogCkBAIC02MjgsNiArNjMx
LDcgQEAKIAkKIAljbGVhcl9iaXQoUjVfTE9DS0VELCAmc2gtPmRldltpXS5mbGFncyk7CiAJc2V0
X2JpdChTVFJJUEVfSEFORExFLCAmc2gtPnN0YXRlKTsKKwlzaC0+YWN0aXZlX3ByZXJlYWRfamlm
ZmllcyA9IGppZmZpZXM7CiAJcmVsZWFzZV9zdHJpcGUoc2gpOwogCXJldHVybiAwOwogfQpAQCAt
MTI1NSw4ICsxMjU5LDExIEBACiAJCWJpcCA9ICZzaC0+ZGV2W2RkX2lkeF0udG93cml0ZTsKIAkJ
aWYgKCpiaXAgPT0gTlVMTCAmJiBzaC0+ZGV2W2RkX2lkeF0ud3JpdHRlbiA9PSBOVUxMKQogCQkJ
Zmlyc3R3cml0ZSA9IDE7Ci0JfSBlbHNlCisJfSBlbHNlewogCQliaXAgPSAmc2gtPmRldltkZF9p
ZHhdLnRvcmVhZDsKKwkJc2gtPmFjdGl2ZV9wcmVyZWFkX2ppZmZpZXMgPSBqaWZmaWVzOwkKKwl9
CisKIAl3aGlsZSAoKmJpcCAmJiAoKmJpcCktPmJpX3NlY3RvciA8IGJpLT5iaV9zZWN0b3IpIHsK
IAkJaWYgKCgqYmlwKS0+Ymlfc2VjdG9yICsgKCgqYmlwKS0+Ymlfc2l6ZSA+PiA5KSA+IGJpLT5i
aV9zZWN0b3IpCiAJCQlnb3RvIG92ZXJsYXA7CkBAIC0yNDM3LDEzICsyNDQ0LDI3IEBACiAKIAog
Ci1zdGF0aWMgdm9pZCByYWlkNV9hY3RpdmF0ZV9kZWxheWVkKHJhaWQ1X2NvbmZfdCAqY29uZikK
K3N0YXRpYyBzdHJ1Y3Qgc3RyaXBlX2hlYWQqICByYWlkNV9hY3RpdmF0ZV9kZWxheWVkKHJhaWQ1
X2NvbmZfdCAqY29uZikKIHsKIAlpZiAoYXRvbWljX3JlYWQoJmNvbmYtPnByZXJlYWRfYWN0aXZl
X3N0cmlwZXMpIDwgSU9fVEhSRVNIT0xEKSB7CiAJCXdoaWxlICghbGlzdF9lbXB0eSgmY29uZi0+
ZGVsYXllZF9saXN0KSkgewogCQkJc3RydWN0IGxpc3RfaGVhZCAqbCA9IGNvbmYtPmRlbGF5ZWRf
bGlzdC5uZXh0OwogCQkJc3RydWN0IHN0cmlwZV9oZWFkICpzaDsKIAkJCXNoID0gbGlzdF9lbnRy
eShsLCBzdHJ1Y3Qgc3RyaXBlX2hlYWQsIGxydSk7CisgICAgICAJCQkKKwkJCWlmKCB0aW1lX2Jl
Zm9yZShqaWZmaWVzLHNoLT5hY3RpdmVfcHJlcmVhZF9qaWZmaWVzKSApeworICAgICAgICAJCSAg
UFJJTlRLKCJkZWFkbGluZSA6IG5vIGV4cGlyZSBzZWM9JWxsZCAlOHUgJTh1XG4iLAorCSAgICAg
ICAgICAgICAgIAkJKHVuc2lnbmVkIGxvbmcgbG9uZykgc2gtPnNlY3RvciwKKyAgICAgICAgICAg
ICAgIAkJCWppZmZpZXNfdG9fbXNlY3Moc2gtPmFjdGl2ZV9wcmVyZWFkX2ppZmZpZXMpLAorICAg
ICAgICAgICAgICAgCQkJamlmZmllc190b19tc2VjcyhqaWZmaWVzKSk7CisgICAgICAgIAkJICBy
ZXR1cm4gc2g7CisgICAgICAJCQl9CisgICAgICAJCQllbHNleworCQkJICAgICAgUFJJTlRLKCJk
ZWFkbGluZTogIGV4cGlyZTpzZWM9JWxsZCAlOHUgJTh1XG4iLAorCSAgICAgICAgICAgICAgIAkJ
CSh1bnNpZ25lZCBsb25nIGxvbmcpc2gtPnNlY3RvciwKKyAgICAgICAgCSAgICAgICAJCQlqaWZm
aWVzX3RvX21zZWNzKHNoLT5hY3RpdmVfcHJlcmVhZF9qaWZmaWVzKSwKKyAgICAgICAgICAgICAg
IAkJCQlqaWZmaWVzX3RvX21zZWNzKGppZmZpZXMpKTsKKwkJCX0KIAkJCWxpc3RfZGVsX2luaXQo
bCk7CiAJCQljbGVhcl9iaXQoU1RSSVBFX0RFTEFZRUQsICZzaC0+c3RhdGUpOwogCQkJaWYgKCF0
ZXN0X2FuZF9zZXRfYml0KFNUUklQRV9QUkVSRUFEX0FDVElWRSwgJnNoLT5zdGF0ZSkpCkBAIC0y
NDUxLDYgKzI0NzIsNyBAQAogCQkJbGlzdF9hZGRfdGFpbCgmc2gtPmxydSwgJmNvbmYtPmhhbmRs
ZV9saXN0KTsKIAkJfQogCX0KKyAgICAgcmV0dXJuIE5VTEw7CiB9CiAKIHN0YXRpYyB2b2lkIGFj
dGl2YXRlX2JpdF9kZWxheShyYWlkNV9jb25mX3QgKmNvbmYpCkBAIC0zMTkxLDcgKzMyMTMsNyBA
QAogICovCiBzdGF0aWMgdm9pZCByYWlkNWQgKG1kZGV2X3QgKm1kZGV2KQogewotCXN0cnVjdCBz
dHJpcGVfaGVhZCAqc2g7CisJc3RydWN0IHN0cmlwZV9oZWFkICpzaCwqZGVsYXllZF9zaD1OVUxM
OwogCXJhaWQ1X2NvbmZfdCAqY29uZiA9IG1kZGV2X3RvX2NvbmYobWRkZXYpOwogCWludCBoYW5k
bGVkOwogCkBAIC0zMjE4LDggKzMyNDAsMTAgQEAKIAkJICAgIGF0b21pY19yZWFkKCZjb25mLT5w
cmVyZWFkX2FjdGl2ZV9zdHJpcGVzKSA8IElPX1RIUkVTSE9MRCAmJgogCQkgICAgIWJsa19xdWV1
ZV9wbHVnZ2VkKG1kZGV2LT5xdWV1ZSkgJiYKIAkJICAgICFsaXN0X2VtcHR5KCZjb25mLT5kZWxh
eWVkX2xpc3QpKQotCQkJcmFpZDVfYWN0aXZhdGVfZGVsYXllZChjb25mKTsKLQorCQkJZGVsYXll
ZF9zaD1yYWlkNV9hY3RpdmF0ZV9kZWxheWVkKGNvbmYpOworCQkKKwkJaWYoZGVsYXllZF9zaCkg
YnJlYWs7CisJCSAgICAKIAkJd2hpbGUgKChiaW8gPSByZW1vdmVfYmlvX2Zyb21fcmV0cnkoY29u
ZikpKSB7CiAJCQlpbnQgb2s7CiAJCQlzcGluX3VubG9ja19pcnEoJmNvbmYtPmRldmljZV9sb2Nr
KTsKQEAgLTMyNTQsOSArMzI3OCw1MSBAQAogCXVucGx1Z19zbGF2ZXMobWRkZXYpOwogCiAJUFJJ
TlRLKCItLS0gcmFpZDVkIGluYWN0aXZlXG4iKTsKKyAJaWYgKGRlbGF5ZWRfc2gpeworICAgCQls
b25nIHdha2V1cD1kZWxheWVkX3NoLT5hY3RpdmVfcHJlcmVhZF9qaWZmaWVzLWppZmZpZXM7Cisg
ICAJCVBSSU5USygiLS0tIHJhaWQ1ZCBpbmFjdGl2ZSBzbGVlcCBmb3IgJWRcbiIsCisgICAgICAg
ICAgICAJCWppZmZpZXNfdG9fbXNlY3Mod2FrZXVwKSApOworICAgCQlpZiAod2FrZXVwPjApCisg
ICAgIAkJbWRkZXYtPnRocmVhZC0+dGltZW91dCA9IHdha2V1cDsKKyAgCX0KK30KKworc3RhdGlj
IHNzaXplX3QKK3JhaWQ1X3Nob3dfc3RyaXBlX2RlYWRsaW5lKG1kZGV2X3QgKm1kZGV2LCBjaGFy
ICpwYWdlKQoreworICByYWlkNV9jb25mX3QgKmNvbmYgPSBtZGRldl90b19jb25mKG1kZGV2KTsK
KyAgaWYgKGNvbmYpCisgICAgcmV0dXJuIHNwcmludGYocGFnZSwgIiVkXG4iLCBhdG9taWNfcmVh
ZCgmY29uZi0+ZGVhZGxpbmVfbXMpKTsKKyAgZWxzZQorICAgIHJldHVybiAwOwogfQogCiBzdGF0
aWMgc3NpemVfdAorcmFpZDVfc3RvcmVfc3RyaXBlX2RlYWRsaW5lKG1kZGV2X3QgKm1kZGV2LCBj
b25zdCBjaGFyICpwYWdlLCBzaXplX3QgbGVuKQoreworICByYWlkNV9jb25mX3QgKmNvbmYgPSBt
ZGRldl90b19jb25mKG1kZGV2KTsKKyAgY2hhciAqZW5kOworICBpbnQgbmV3OworICBpZiAobGVu
ID49IFBBR0VfU0laRSkKKyAgICByZXR1cm4gLUVJTlZBTDsKKyAgaWYgKCFjb25mKQorICAgIHJl
dHVybiAtRU5PREVWOworICBuZXcgPSBzaW1wbGVfc3RydG91bChwYWdlLCAmZW5kLCAxMCk7Cisg
IGlmICghKnBhZ2UgfHwgKCplbmQgJiYgKmVuZCAhPSAnXG4nKSApCisgICAgcmV0dXJuIC1FSU5W
QUw7CisgIGlmIChuZXcgPCAwIHx8IG5ldyA+IDEwMDAwKQorICAgIHJldHVybiAtRUlOVkFMOwor
ICBhdG9taWNfc2V0KCZjb25mLT5kZWFkbGluZV9tcyxuZXcpOworICByZXR1cm4gbGVuOworfQor
CitzdGF0aWMgc3RydWN0IG1kX3N5c2ZzX2VudHJ5CityYWlkNV9zdHJpcGVfZGVhZGxpbmUgPSBf
X0FUVFIoc3RyaXBlX2RlYWRsaW5lLCBTX0lSVUdPIHwgU19JV1VTUiwKKyAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgcmFpZDVfc2hvd19zdHJpcGVfZGVhZGxpbmUsCisgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgcmFpZDVfc3RvcmVfc3RyaXBlX2RlYWRsaW5lKTsKKworCitz
dGF0aWMgc3NpemVfdAogcmFpZDVfc2hvd19zdHJpcGVfY2FjaGVfc2l6ZShtZGRldl90ICptZGRl
diwgY2hhciAqcGFnZSkKIHsKIAlyYWlkNV9jb25mX3QgKmNvbmYgPSBtZGRldl90b19jb25mKG1k
ZGV2KTsKQEAgLTMyOTcsNiArMzM2Myw5IEBACiAJcmV0dXJuIGxlbjsKIH0KIAorCisKKwogc3Rh
dGljIHN0cnVjdCBtZF9zeXNmc19lbnRyeQogcmFpZDVfc3RyaXBlY2FjaGVfc2l6ZSA9IF9fQVRU
UihzdHJpcGVfY2FjaGVfc2l6ZSwgU19JUlVHTyB8IFNfSVdVU1IsCiAJCQkJcmFpZDVfc2hvd19z
dHJpcGVfY2FjaGVfc2l6ZSwKQEAgLTMzMTgsOCArMzM4NywxMCBAQAogc3RhdGljIHN0cnVjdCBh
dHRyaWJ1dGUgKnJhaWQ1X2F0dHJzW10gPSAgewogCSZyYWlkNV9zdHJpcGVjYWNoZV9zaXplLmF0
dHIsCiAJJnJhaWQ1X3N0cmlwZWNhY2hlX2FjdGl2ZS5hdHRyLAorICAgICZyYWlkNV9zdHJpcGVf
ZGVhZGxpbmUuYXR0ciwKIAlOVUxMLAogfTsKKwogc3RhdGljIHN0cnVjdCBhdHRyaWJ1dGVfZ3Jv
dXAgcmFpZDVfYXR0cnNfZ3JvdXAgPSB7CiAJLm5hbWUgPSBOVUxMLAogCS5hdHRycyA9IHJhaWQ1
X2F0dHJzLApAQCAtMzU2Nyw2ICszNjM4LDggQEAKIAogCWJsa19xdWV1ZV9tZXJnZV9idmVjKG1k
ZGV2LT5xdWV1ZSwgcmFpZDVfbWVyZ2VhYmxlX2J2ZWMpOwogCisJYXRvbWljX3NldCgmY29uZi0+
ZGVhZGxpbmVfbXMsMCk7CisKIAlyZXR1cm4gMDsKIGFib3J0OgogCWlmIChjb25mKSB7Cg==
------=_Part_108472_14699732.1175523223384
Content-Type: text/x-patch; name=raid5_write.h.patch; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f00ytcmk
Content-Disposition: attachment; filename="raid5_write.h.patch"

ZGlmZiAtcnVOIC1YIGxpbnV4LTIuNi4yMC4yL0RvY3VtZW50YXRpb24vZG9udGRpZmYgbGludXgt
Mi42LjIwLjIvaW5jbHVkZS9saW51eC9yYWlkL3JhaWQ1LmggbGludXgtMi42LjIwLjItcmFpZC9p
bmNsdWRlL2xpbnV4L3JhaWQvcmFpZDUuaAotLS0gbGludXgtMi42LjIwLjIvaW5jbHVkZS9saW51
eC9yYWlkL3JhaWQ1LmgJMjAwNy0wMy0wOSAyMDo1ODowNC4wMDAwMDAwMDAgKzAyMDAKKysrIGxp
bnV4LTIuNi4yMC4yLXJhaWQvaW5jbHVkZS9saW51eC9yYWlkL3JhaWQ1LmgJMjAwNy0wMy0zMCAw
MDoyNTozOC4wMDAwMDAwMDAgKzAyMDAKQEAgLTEzNiw2ICsxMzYsNyBAQAogCXNwaW5sb2NrX3QJ
CWxvY2s7CiAJaW50CQkJYm1fc2VxOwkvKiBzZXF1ZW5jZSBudW1iZXIgZm9yIGJpdG1hcCBmbHVz
aGVzICovCiAJaW50CQkJZGlza3M7CQkJLyogZGlza3MgaW4gc3RyaXBlICovCisJdW5zaWduZWQg
bG9uZyAgIAlhY3RpdmVfcHJlcmVhZF9qaWZmaWVzOwogCXN0cnVjdCByNWRldiB7CiAJCXN0cnVj
dCBiaW8JcmVxOwogCQlzdHJ1Y3QgYmlvX3ZlYwl2ZWM7CkBAIC0yNTQsNiArMjU1LDcgQEAKIAkg
KiBGcmVlIHN0cmlwZXMgcG9vbAogCSAqLwogCWF0b21pY190CQlhY3RpdmVfc3RyaXBlczsKKwlh
dG9taWNfdCAgICAgICAgCWRlYWRsaW5lX21zOwogCXN0cnVjdCBsaXN0X2hlYWQJaW5hY3RpdmVf
bGlzdDsKIAl3YWl0X3F1ZXVlX2hlYWRfdAl3YWl0X2Zvcl9zdHJpcGU7CiAJd2FpdF9xdWV1ZV9o
ZWFkX3QJd2FpdF9mb3Jfb3ZlcmxhcDsK
------=_Part_108472_14699732.1175523223384
Content-Type: text/x-c++src; name=random_writev.cpp; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f00z3ssx
Content-Disposition: attachment; filename="random_writev.cpp"

I2RlZmluZSBfTEFSR0VGSUxFNjRfU09VUkMKCiNpbmNsdWRlIDxpb3N0cmVhbT4KI2luY2x1ZGUg
PHN0ZGlvLmg+CiNpbmNsdWRlIDxzdHJpbmc+CiNpbmNsdWRlIDxzdGRkZWYuaD4KI2luY2x1ZGUg
PHN5cy90aW1lLmg+CgojaW5jbHVkZSA8c3RkbGliLmg+CiNpbmNsdWRlIDxzeXMvdHlwZXMuaD4K
I2luY2x1ZGUgPHN5cy9zdGF0Lmg+CiNpbmNsdWRlIDxmY250bC5oPgojaW5jbHVkZSA8dW5pc3Rk
Lmg+CiNpbmNsdWRlIDxsaWJhaW8uaD4KI2luY2x1ZGUgPHRpbWUuaD4KI2luY2x1ZGUgPHN0ZGlv
Lmg+CiNpbmNsdWRlIDxlcnJuby5oPgojaW5jbHVkZSA8c3lzL3Vpby5oPgojaW5jbHVkZSA8dW5p
c3RkLmg+CiNpbmNsdWRlIDxzeXMvdHlwZXMuaD4KI2luY2x1ZGUgPGxpbnV4L3VuaXN0ZC5oPgoj
aW5jbHVkZSA8ZXJybm8uaD4KCnVzaW5nIG5hbWVzcGFjZSBzdGQ7CgppbnQgbWFpbiAoaW50IGFy
Z2MsIGNoYXIgKmFyZ3ZbXSkKewogIGlmIChhcmdjPDYpewoJY291dCA8PCAidXNhZ2UgIDxkZXZp
Y2UgbmFtZT4gIDxzaXplIHRvIHdyaXRlIGluIGtiPiA8b2Zmc2V0IGluIGtiID4gPGRpc2tTaXpl
R0I+IDxsb29wcz4iIDw8IGVuZGw7CglyZXR1cm4gMDsKICB9CgogIGNoYXIqIGRldl9uYW1lID0g
YXJndlsxXTsKCiAgaW50IGZkID0gb3BlbihkZXZfbmFtZSwgT19MQVJHRUZJTEUgfCBPX0RJUkVD
VCB8IE9fV1JPTkxZICwgNzc3ICk7CiAgaWYgKGZkPDApewoJcGVycm9yKCJvcGVuICIpOwoJcmV0
dXJuICgtMSk7CiAgfQoKICBsb25nIGxvbmcgd3JpdGVfc3pfYnl0ZXMgICAgPSAoIChsb25nIGxv
bmcpYXRvaShhcmd2WzJdKSk8PDEwOwogIGxvbmcgbG9uZyBvZmZzZXRfc3pfYnl0ZXMgICA9ICgg
KGxvbmcgbG9uZykgYXRvaShhcmd2WzNdKSApPDwxMDsKICBsb25nIGxvbmcgZGlza1NpemVCeXRl
cyAgICAgICAgPSAoIChsb25nIGxvbmcpYXRvaShhcmd2WzRdKSk8PDMwOwogIGludCBsb29wcyA9
IGF0b2koYXJndls1XSk7CiAKICBzdHJ1Y3QgaW92ZWMgdmVjWzEwXTsKICBpbnQgYmxvY2tzID0g
KHdyaXRlX3N6X2J5dGVzID4+MjApOwoKICBmb3IoIGludCBpID0gMCA7IGkgPCBibG9ja3M7IGkr
Kyl7CiAgCiAgICBjaGFyKiBidWZmZXIgPSAoY2hhciopdmFsbG9jKCgxPDwyMCkpOwogICAgaWYg
KCFidWZmZXIpIHsKCSAgICBwZXJyb3IoImFsbG9jIDogIik7CiAgICAgICAgcmV0dXJuIC0xOwog
ICAgfQogICAgdmVjW2ldLmlvdl9iYXNlID0gYnVmZmVyOwogICAgdmVjW2ldLmlvdl9sZW4gPSAx
MDQ4NTc2OwogICAgbWVtc2V0KGJ1ZmZlciwweDAwLDEwNDg1NzYpOwogIH0KCiAgaW50IHJldD0w
OwogCiAgd2hpbGUoICgtLWxvb3BzKT4wICl7CgogICAgaWYgKCBsc2VlazY0KGZkLG9mZnNldF9z
el9ieXRlcyxTRUVLX1NFVCkgPCAwICApewogICAgICBwcmludGYoIiVzOiBmYWlsZWQgb24gbHNl
ZWsgb2Zmc2V0PSVsbGRcbiIsb2Zmc2V0X3N6X2J5dGVzKTsKICAgICAgcmV0dXJuICgwKTsKICAg
IH0KICAgIAogICAgcmV0ID0gd3JpdGV2KGZkLChzdHJ1Y3QgaW92ZWMqKSZ2ZWMsYmxvY2tzKTsK
ICAgIGlmICggcmV0ICE9IHdyaXRlX3N6X2J5dGVzICkgewogICAgICBwZXJyb3IoImZhaWxlZCB0
byB3cml0ZTogIik7CiAgICAgIHByaW50Zigid3JpdGUgc2l6ZT0lbGxkIG9mZnNldD0lbGxkXG4i
LHdyaXRlX3N6X2J5dGVzLG9mZnNldF9zel9ieXRlcyk7CiAgICAgIHJldHVybiAtMTsKICAgIH0K
CiAgICBvZmZzZXRfc3pfYnl0ZXMgPSAgd3JpdGVfc3pfYnl0ZXMgKiggIHJhbmRvbSgpICUgZGlz
a1NpemVCeXRlcyApOwoKICAgIGxvbmcgbG9uZyBybmQgPSAobG9uZyBsb25nKXJhbmRvbSgpOwog
ICAgb2Zmc2V0X3N6X2J5dGVzID0gIHdyaXRlX3N6X2J5dGVzICogKGxvbmcgbG9uZykoIHJuZCAl
ICBkaXNrU2l6ZUJ5dGVzICk7CgogICAgaWYob2Zmc2V0X3N6X2J5dGVzPmRpc2tTaXplQnl0ZXMp
ewogICAgICAgICAgICBvZmZzZXRfc3pfYnl0ZXMgPSAgKG9mZnNldF9zel9ieXRlcyAtIGRpc2tT
aXplQnl0ZXMgKSAlIGRpc2tTaXplQnl0ZXM7CiAgICAgICAgICAgIG9mZnNldF9zel9ieXRlcyA9
ICAob2Zmc2V0X3N6X2J5dGVzL3dyaXRlX3N6X2J5dGVzKSp3cml0ZV9zel9ieXRlczsKICAgIH0K
CiAgICBwcmludGYoIndyaXRpbmcgJWQgYnl0ZXMgYXQgb2Zmc2V0ICVsbGRcbiIscmV0LG9mZnNl
dF9zel9ieXRlcyk7CiAgfQogIAogIHJldHVybigwKTsKfQoKCg==
------=_Part_108472_14699732.1175523223384--
