From: Adam Hamsik <adam.hamsik@chillisys.com>
Subject: mdadm raid soft lock-ups ubuntu kernel 4.13.0-36
Date: Fri, 8 Jun 2018 15:20:57 +0200
Message-ID: <CAOmBuBNmzD9PpGhKA6PdrqNLMFsXZ9GcbNiL8mxqkUNmGvYmsw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7230033806818592108=="
Return-path: <kernel-team-bounces@lists.ubuntu.com>
List-Unsubscribe: <https://lists.ubuntu.com/mailman/options/kernel-team>,
 <mailto:kernel-team-request@lists.ubuntu.com?subject=unsubscribe>
List-Archive: <https://lists.ubuntu.com/archives/kernel-team>
List-Post: <mailto:kernel-team@lists.ubuntu.com>
List-Help: <mailto:kernel-team-request@lists.ubuntu.com?subject=help>
List-Subscribe: <https://lists.ubuntu.com/mailman/listinfo/kernel-team>,
 <mailto:kernel-team-request@lists.ubuntu.com?subject=subscribe>
Errors-To: kernel-team-bounces@lists.ubuntu.com
Sender: "kernel-team" <kernel-team-bounces@lists.ubuntu.com>
To: linux-raid@vger.kernel.org
Cc: kernel-team@lists.ubuntu.com, =?UTF-8?B?S29yYmVsw6HFmSBKYWt1Yg==?= <j.korbelar@radiokomunikace.cz>, =?UTF-8?B?S291xZlpbCBQxZllbXlzbA==?= <P.Kouril@radiokomunikace.cz>, cra@elitecode.cz
List-Id: linux-raid.ids

--===============7230033806818592108==
Content-Type: multipart/alternative; boundary="0000000000003f19ee056e214503"

--0000000000003f19ee056e214503
Content-Type: text/plain; charset="UTF-8"

Hi,

we're running Ubuntu 16.04.4, mdadm - v3.3 and Kernel 4.13.0-36.
We have created raid10 using 22 960GB SSDs [1] . The problem we're
experiencing is that /usr/share/mdadm/checkarray
(executed by cron, included in a mdadm pkg) results in (soft?)
deadlock - load on the node spikes up to 500-700 and all I/O operations
are blocked for a period of time. We can see traces liek these [2] in
our kernel log.

e.g. it ends up in static state like

test@os-node1:~$ cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md1 : active raid10 dm-23[9] dm-22[8] dm-21[7] dm-20[6] dm-18[4] dm-19[5]
dm-17[3]
                    dm-16[21] dm-15[20] dm-14[2] dm-13[19] dm-12[18]
dm-11[17]
                    dm-10[16] dm-9[15] dm-8[14] dm-7[13] dm-6[12] dm-5[11]
dm-4[10] dm-3[1] dm-2[0]
      10313171968 blocks super 1.2 512K chunks 2 near-copies [22/22]
[UUUUUUUUUUUUUUUUUUUUUU]
      [===>.................]  check = 19.0% (1965748032/10313171968)
finish=1034728.8min speed=134K/sec
      bitmap: 0/39 pages [0KB], 131072KB chunk
unused devices: <none>

and the only solution is to hard reboot the node. What we found out is that
it
doesn't happen on idle raid, we have to generate some significant load
(10 VMs running fio[3] with 500GB HDDs.) to be able to reproduce the issue.

Anyone ever experienced similar issues? Do you have any suggestions how to
better trouble shoot this issue and maybe identify if disks or software
layer
is responsible for this behaviour

[1] http://www.samsung.com/us/dell/pdfs/PM1633a_Flyer_2016_v4.pdf
[2] https://gist.github.com/haad/09213bab1bc30a00c7d255c0bc60897b
[3] https://github.com/axboe/fio





Regards
Adam.

Adam Hamsik
00421 904 937 495
adam.hamsik@chillisys.com
haad@netbsd.org

--0000000000003f19ee056e214503
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi,<br><br>we&#39;re running Ubuntu 16.04.4, mdadm - =
v3.3 and Kernel 4.13.0-36.<br>We have created raid10 using 22 960GB SSDs [1=
] . The problem we&#39;re<br>experiencing is that /usr/share/mdadm/checkarr=
ay<br>(executed by cron, included in a mdadm pkg) results in (soft?)<br>dea=
dlock - load on the node spikes up to 500-700 and all I/O operations<br>are=
 blocked for a period of time. We can see traces liek these [2] in<br>our k=
ernel log.<br><br>e.g. it ends up in static state like<br><br>test@os-node1=
:~$ cat /proc/mdstat<br>Personalities : [linear] [multipath] [raid0] [raid1=
] [raid6] [raid5] [raid4] [raid10]<br>md1 : active raid10 dm-23[9] dm-22[8]=
 dm-21[7] dm-20[6] dm-18[4] dm-19[5] dm-17[3]<br>=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 dm-16[21] dm-15[20] dm-14[2] dm-13[19] dm-12[18] dm-11[17]<=
br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dm-10[16] dm-9[15] dm-8[14] dm-7=
[13] dm-6[12] dm-5[11] dm-4[10] dm-3[1] dm-2[0]<br>=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 10313171968 blocks super 1.2 512K chunks 2 near-copies [22/22] [UUUU=
UUUUUUUUUUUUUUUUUU]<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [=3D=3D=3D&gt;.......=
..........]=C2=A0 check =3D 19.0% (1965748032/10313171968) finish=3D1034728=
.8min speed=3D134K/sec<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bitmap: 0/39 pages=
 [0KB], 131072KB chunk<br>unused devices: &lt;none&gt;<br><br>and the only =
solution is to hard reboot the node. What we found out is that it<br>doesn&=
#39;t happen on idle raid, we have to generate some significant load<br>(10=
 VMs running fio[3] with 500GB HDDs.) to be able to reproduce the issue.<br=
><br>Anyone ever experienced similar issues? Do you have any suggestions ho=
w to<br>better trouble shoot this issue and maybe identify if disks or soft=
ware layer<br>is responsible for this behaviour<br><br>[1] <a href=3D"http:=
//www.samsung.com/us/dell/pdfs/PM1633a_Flyer_2016_v4.pdf">http://www.samsun=
g.com/us/dell/pdfs/PM1633a_Flyer_2016_v4.pdf</a><br>[2] <a href=3D"https://=
gist.github.com/haad/09213bab1bc30a00c7d255c0bc60897b">https://gist.github.=
com/haad/09213bab1bc30a00c7d255c0bc60897b</a><br>[3] <a href=3D"https://git=
hub.com/axboe/fio">https://github.com/axboe/fio</a><br></div><div><br></div=
><div><br></div><div><br></div><div><br></div><div><br></div><div><div clas=
s=3D"gmail_signature">Regards<br>Adam.<br><br>Adam Hamsik<br>00421 904 937 =
495<br><a href=3D"mailto:adam.hamsik@chillisys.com" target=3D"_blank">adam.=
hamsik@chillisys.com</a><br><a href=3D"mailto:haad@netbsd.org" target=3D"_b=
lank">haad@netbsd.org</a></div></div>
</div>

--0000000000003f19ee056e214503--


--===============7230033806818592108==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

LS0gCmtlcm5lbC10ZWFtIG1haWxpbmcgbGlzdAprZXJuZWwtdGVhbUBsaXN0cy51YnVudHUuY29t
Cmh0dHBzOi8vbGlzdHMudWJ1bnR1LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2tlcm5lbC10ZWFtCg==

--===============7230033806818592108==--
