From: Song Liu <song@kernel.org>
Subject: Re: Assemblin journaled array fails
Date: Wed, 17 Jun 2020 10:11:07 -0700
Message-ID: <CAPhsuW4BZE-DeESsq-coNx5_KZrfHjP=d9YOjOPqPji5kQBXjg@mail.gmail.com>
References: <f8c61278-1758-66cd-cf25-8a118cb12f58@yandex.pl>
 <1cb6c63f-a74c-a6f4-6875-455780f53fa1@yandex.pl> <CAPhsuW6HdatOPJykqYCQs_7onWL1-AQRo05TygkXdRVSwAy_gQ@mail.gmail.com>
 <7b2b2bca-c1b7-06c5-10c5-2b1cdda21607@yandex.pl> <48e4fa28-4d20-ba80-cd69-b17da719531a@yandex.pl>
 <CAPhsuW69VYgLBZboxvQ6-Fmm-Oa0fGOVBg3SOVkzP_UopH+_wg@mail.gmail.com>
 <1767d7aa-6c60-7efb-bf37-6506f9aaa8a2@yandex.pl> <CAPhsuW4oMKuCrHUU1ucsMKQbSfBQdsNEQWHA1SSbGR5nbvy21w@mail.gmail.com>
 <CAPhsuW4WBDGGLYc=f4xoThxtxuF5K74m3odJ-uA98DuPLJR4nw@mail.gmail.com>
 <0cf6454d-a8b5-4bee-5389-94b23c077050@yandex.pl> <CAPhsuW51u6KWLvUntMXPU7stu7oSA+d-yT6zf7G0zCETzLWwiA@mail.gmail.com>
 <49efa0d2-b44c-ec85-5e44-fb93a15001e7@yandex.pl> <4df42e3d-ad2b-dfc2-3961-49ada4ea7eaf@yandex.pl>
 <CAPhsuW5kk0G9PSfEADc8+rn=QT2z4ogjuV98qWsH_s_WBic-5w@mail.gmail.com>
 <71f58507-314e-4a1d-dd50-41a60d76521b@yandex.pl> <CAPhsuW59Q7mU9WH36RHs9kb-TMk7FmrQL+JCApupf_TZtpWynA@mail.gmail.com>
 <4a03e900-61a8-f150-9be8-739e88ba8ce6@yandex.pl>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="000000000000aac4fe05a84abff1"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4a03e900-61a8-f150-9be8-739e88ba8ce6@yandex.pl>
Sender: linux-raid-owner@vger.kernel.org
To: Michal Soltys <msoltyspl@yandex.pl>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--000000000000aac4fe05a84abff1
Content-Type: text/plain; charset="UTF-8"

On Wed, Jun 17, 2020 at 5:53 AM Michal Soltys <msoltyspl@yandex.pl> wrote:
>
> On 6/17/20 2:48 AM, Song Liu wrote:
> > On Tue, Jun 9, 2020 at 2:51 PM Michal Soltys <msoltyspl@yandex.pl> wrote:
> >>
> >> On 20/06/09 20:36, Song Liu wrote:
> >>> On Tue, Jun 9, 2020 at 2:36 AM Michal Soltys <msoltyspl@yandex.pl> wrote:
> >>>>
> >>>> On 6/5/20 2:26 PM, Michal Soltys wrote:
> >>>>> On 6/4/20 12:07 AM, Song Liu wrote:
> >>>>>>
> >>>>>> The hang happens at expected place.
> >>>>>>
> >>>>>>> [Jun 3 09:02] INFO: task mdadm:2858 blocked for more than 120 seconds.
> >>>>>>> [  +0.060545]       Tainted: G            E
> >>>>>>> 5.4.19-msl-00001-gbf39596faf12 #2
> >>>>>>> [  +0.062932] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> >>>>>>> disables this message.
> >>>>>>
> >>>>>> Could you please try disable the timeout message with
> >>>>>>
> >>>>>> echo 0 > /proc/sys/kernel/hung_task_timeout_secs
> >>>>>>
> >>>>>> And during this wait (after message
> >>>>>> "r5c_recovery_flush_data_only_stripes before wait_event"),
> >>>>>> checks whether the raid disks (not the journal disk) are taking IOs
> >>>>>> (using tools like iostat).
> >>>>>>
> >>>>>
> >>>>> No activity on component drives.
> >>>>
> >>>> To expand on that - while there is no i/o activity whatsoever at the component drives (as well as journal), the cpu is of course still fully loaded (5 days so far):
> >>>>
> >>>> UID        PID  PPID  C    SZ   RSS PSR STIME TTY          TIME CMD
> >>>> root      8129  6755 15   740  1904  10 Jun04 pts/2    17:42:34 mdadm -A /dev/md/r5_big /dev/md/r1_journal_big /dev/sdj1 /dev/sdi1 /dev/sdg1 /dev/sdh1
> >>>> root      8147     2 84     0     0  30 Jun04 ?        4-02:09:47 [md124_raid5]
> >>>
> >>> I guess the md thread stuck at some stripe. Does the kernel have
> >>> CONFIG_DYNAMIC_DEBUG enabled? If so, could you please try enable some pr_debug()
> >>> in function handle_stripe()?
> >>>
> >>> Thanks,
> >>> Song
> >>>
> >>
> >> Massive spam in dmesg with messages like these:
> >>
> >> [464836.603033] handling stripe 1551540328, state=0x41 cnt=1, pd_idx=3,
> >> qd_idx=-1
> >>                   , check:0, reconstruct:0
> >> <cut>
> >>
> >
> > I am really sorry for the delay. A few questions:
> >
>
> No worries.
>
> > 1. There are two pr_debug() calls in handle_stripe():
> >         pr_debug("handling stripe %llu, state=%#lx cnt=%d, "
> >         pr_debug("locked=%d uptodate=%d to_read=%d"
> >
> >      Did you enable all of them? Or only the first one?
>
> I enabled all of them (I think), to be precise:
>
> echo -n 'func handle_stripe +p' >/sys/kernel/debug/dynamic_debug/control
>
> Haven't seen any `locked` lines though.

That's a little weird, and probably explains why we stuck. Could you
please try the attached patch?

Thanks,
Song

--000000000000aac4fe05a84abff1
Content-Type: application/octet-stream;
	name="0001-Debug-raid5-recovery-hang.patch"
Content-Disposition: attachment;
	filename="0001-Debug-raid5-recovery-hang.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kbjm3lpa0>
X-Attachment-Id: f_kbjm3lpa0

RnJvbSA0YzYwYTY5MmZmZmMxZWI1MWE0ODExZDM2ZWVjNjA3NmI3NzljNmM2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTb25nIExpdSA8c29uZ2xpdWJyYXZpbmdAZmIuY29tPgpEYXRl
OiBXZWQsIDE3IEp1biAyMDIwIDA5OjU2OjA2IC0wNzAwClN1YmplY3Q6IFtQQVRDSF0gRGVidWcg
cmFpZDUgcmVjb3ZlcnkgaGFuZwoKLS0tCiBkcml2ZXJzL21kL3JhaWQ1LmMgfCAxOCArKysrKysr
KysrKysrKy0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9u
cygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvcmFpZDUuYyBiL2RyaXZlcnMvbWQvcmFpZDUu
YwppbmRleCBhYjgwNjdmOWNlOGM2Li5jYTc0NzZmYWMzZTlkIDEwMDY0NAotLS0gYS9kcml2ZXJz
L21kL3JhaWQ1LmMKKysrIGIvZHJpdmVycy9tZC9yYWlkNS5jCkBAIC00NzI2LDYgKzQ3MjYsMjAg
QEAgc3RhdGljIHZvaWQgaGFuZGxlX3N0cmlwZShzdHJ1Y3Qgc3RyaXBlX2hlYWQgKnNoKQogCWlm
ICh0ZXN0X2JpdChTVFJJUEVfTE9HX1RSQVBQRUQsICZzaC0+c3RhdGUpKQogCQlnb3RvIGZpbmlz
aDsKIAorCXByX2RlYnVnKCJsb2NrZWQ9JWQgdXB0b2RhdGU9JWQgdG9fcmVhZD0lZCIKKwkgICAg
ICAgIiB0b193cml0ZT0lZCBmYWlsZWQ9JWQgZmFpbGVkX251bT0lZCwlZFxuIiwKKwkgICAgICAg
cy5sb2NrZWQsIHMudXB0b2RhdGUsIHMudG9fcmVhZCwgcy50b193cml0ZSwgcy5mYWlsZWQsCisJ
ICAgICAgIHMuZmFpbGVkX251bVswXSwgcy5mYWlsZWRfbnVtWzFdKTsKKworCXByX2RlYnVnKCJo
YW5kbGVfYmFkX2Jsb2Nrcz0lZCBNRF9TQl9DSEFOR0VfUEVORElORz0lZCBibG9ja2VkX3JkZXY9
JXB4XG4iLAorCQkgcy5oYW5kbGVfYmFkX2Jsb2NrcywKKwkJIHRlc3RfYml0KE1EX1NCX0NIQU5H
RV9QRU5ESU5HLCAmY29uZi0+bWRkZXYtPnNiX2ZsYWdzKSwKKwkJIHMuYmxvY2tlZF9yZGV2KTsK
KworCXByX2RlYnVnKCJzeW5jaW5nPSVkIGV4cGFuZGluZz0lZCBleHBhbmRlZD0lZCIKKwkgICAg
ICAgIiByZXBsYWNpbmc9JWQgd3JpdHRlbj0lZFxuIiwKKwkJIHMuc3luY2luZywgcy5leHBhbmRp
bmcsIHMuZXhwYW5kZWQsIHMucmVwbGFjaW5nLCBzLndyaXR0ZW4pOworCiAJaWYgKHMuaGFuZGxl
X2JhZF9ibG9ja3MgfHwKIAkgICAgdGVzdF9iaXQoTURfU0JfQ0hBTkdFX1BFTkRJTkcsICZjb25m
LT5tZGRldi0+c2JfZmxhZ3MpKSB7CiAJCXNldF9iaXQoU1RSSVBFX0hBTkRMRSwgJnNoLT5zdGF0
ZSk7CkBAIC00NzQ4LDEwICs0NzYyLDYgQEAgc3RhdGljIHZvaWQgaGFuZGxlX3N0cmlwZShzdHJ1
Y3Qgc3RyaXBlX2hlYWQgKnNoKQogCQlzZXRfYml0KFNUUklQRV9CSU9GSUxMX1JVTiwgJnNoLT5z
dGF0ZSk7CiAJfQogCi0JcHJfZGVidWcoImxvY2tlZD0lZCB1cHRvZGF0ZT0lZCB0b19yZWFkPSVk
IgotCSAgICAgICAiIHRvX3dyaXRlPSVkIGZhaWxlZD0lZCBmYWlsZWRfbnVtPSVkLCVkXG4iLAot
CSAgICAgICBzLmxvY2tlZCwgcy51cHRvZGF0ZSwgcy50b19yZWFkLCBzLnRvX3dyaXRlLCBzLmZh
aWxlZCwKLQkgICAgICAgcy5mYWlsZWRfbnVtWzBdLCBzLmZhaWxlZF9udW1bMV0pOwogCS8qCiAJ
ICogY2hlY2sgaWYgdGhlIGFycmF5IGhhcyBsb3N0IG1vcmUgdGhhbiBtYXhfZGVncmFkZWQgZGV2
aWNlcyBhbmQsCiAJICogaWYgc28sIHNvbWUgcmVxdWVzdHMgbWlnaHQgbmVlZCB0byBiZSBmYWls
ZWQuCi0tIAoyLjI0LjEKCg==
--000000000000aac4fe05a84abff1--
