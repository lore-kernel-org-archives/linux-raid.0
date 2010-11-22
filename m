From: Mike Viau <viaum@sheridanc.on.ca>
Subject: RE: How to recreate a dmraid RAID array with mdadm
Date: Mon, 22 Nov 2010 13:07:10 -0500
Message-ID: <BAY148-w47CEC117EA632A5DA3987EF3D0@phx.gbl>
References: <BAY148-w65577551281F75C185BEBEF380@phx.gbl>,<20101117141514.759d9eea@notabene.brown>,<BAY148-w18A88E7D84CE0213B44F26EF380@phx.gbl>,<20101118111149.7b5004a2@notabene.brown>,<BAY148-w607755AA342EF4ACCCC9A5EF390@phx.gbl>,<20101118122847.1530d86c@notabene.brown>,<BAY148-w149179108DC6D340247236EF390@phx.gbl>,<20101118133247.7ffa99d1@notabene.brown>,<BAY148-w494B0F5EB60CC742DFC817EF390@phx.gbl>,<20101118141718.44c1837f@notabene.brown>,<BAY148-w508672292A737E86BE8332EF390@phx.gbl>,<20101118163849.7e63b4d0@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_29b761cb-2fd0-4c65-b0af-e851a6d608d6_"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101118163849.7e63b4d0@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, debian-user@lists.debian.org
List-Id: linux-raid.ids

--_29b761cb-2fd0-4c65-b0af-e851a6d608d6_
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable


> On Thu=2C 18 Nov 2010 16:38:49 +1100 <neilb@suse.de> wrote:
> > > On Thu=2C 18 Nov 2010 14:17:18 +1100  wrote:
> > > >
> > > > > On Thu=2C 18 Nov 2010 13:32:47 +1100 wrote:
> > > > > > ./mdadm -Ss
> > > > > >
> > > > > > mdadm: stopped /dev/md127
> > > > > >
> > > > > >
> > > > > > ./mdadm -Asvvv
> > > > > >
> > > > > > mdadm: looking for devices for further assembly
> > > > > > mdadm: no RAID superblock on /dev/dm-3
> > > > > > mdadm: /dev/dm-3 has wrong uuid.
> > > > > > want UUID-084b969a:0808f5b8:6c784fb7:62659383
> > > > > > Segmentation fault
> > > > >
> > > > > Try this patch instead please.
> > > >
> > > > Applied new patch and got:
> > > >
> > > > ./mdadm -Ss
> > > >
> > > > mdadm: stopped /dev/md127
> > > >
> > > >
> > > > ./mdadm -Asvvv
> > > > mdadm: looking for devices for further assembly
> > > > mdadm: no RAID superblock on /dev/dm-3
> > > > mdadm: /dev/dm-3 has wrong uuid.
> > > > want UUID-084b969a:0808f5b8:6c784fb7:62659383
> > > > tst=3D0x10dd010 sb=3D(nil)
> > > > Segmentation fault
> > >
> > > Sorry... I guess I should have tested it myself..
> > >
> > > The
> > > if (tst) {
> > >
> > > Should be
> > >
> > > if (tst && content) {
> > >
> >
> > Apply update and got:
> >
> > mdadm: /dev/sdb is identified as a member of /dev/md/imsm0=2C slot -1.
> > mdadm: /dev/sda is identified as a member of /dev/md/imsm0=2C slot -1.
> > mdadm: added /dev/sda to /dev/md/imsm0 as -1
> > mdadm: added /dev/sdb to /dev/md/imsm0 as -1
> > mdadm: Container /dev/md/imsm0 has been assembled with 2 drives
> > mdadm: looking for devices for /dev/md/OneTB-RAID1-PV
>
> So just to clarify.
>
> With the Debian mdadm=2C which is 3.1.4=2C if you
>
> mdadm -Ss
> mdadm -Asvv
>
> it says (among other things) that /dev/sda has wrong uuid.
> and doesn't start the array.

Actually both compiled and Debian do not start the array. Or atleast create=
 the /dev/md/OneTB-RAID1-PV device when running mdadm -I /dev/md/imsm0 does=
.

You are right about seeing a message on /dev/sda about having a wrong uuid =
somewhere though.=A0 I went back to take a look at my output from the Debia=
n mailing list to see that the mdadm did change slightly from this thread h=
as begun.

The old output was copied verbatim on http://lists.debian.org/debian-user/2=
010/11/msg01234.html and says (among other things) that /dev/sda has wrong =
uuid.

The /dev/sd[ab] has wrong uuid messages are missing from the mdadm -Asvv ou=
tput but....

./mdadm -Ivv /dev/md/imsm0=20
mdadm: UUID differs from /dev/md/OneTB-RAID1-PV.
mdadm: match found for member 0
mdadm: Started /dev/md/OneTB-RAID1-PV with 2 devices


I still have this UUID message when still using the mdadm -I command.


I'll attach the output of both the mdadm commands above as they run now on =
the system=2C but I noticed=2C but also that in the same thread link above=
=2C with the old output I was inqurying as to both /dev/sda and /dev/sdb (t=
he drives which make up the raid1 array) do not appear to recognized as hav=
ing a valid container when one is required.

What is take on GeraldCC (gcsgcatling@bigpond.com) assistance about /dev/sd=
[ab] containing a 8e (for LVM) partition type=2C rather than the fd type to=
 denote raid autodetect. If this was the magical fix (which I am not saying=
 it can=92t be) why is mdadm -I /dev/md/imsm0 able to bring up the array fo=
r use as an physical volume for LVM?



>
> But with the mdadm you compiled yourself=2C which is also 3.1.4=2C
> if you
>
> mdadm -Ss
> mdadm -Asvv
>
> then it doesn't give that message=2C and it works.

Again=2C actually both compiled and Debian do not start the array. Or atlea=
st
create the /dev/md/OneTB-RAID1-PV device when running mdadm -I
/dev/md/imsm0 does.

>
> That is very strange. It seems that the Debian mdadm is broken somehow=2C=
 but
> I'm fairly sure Debian hardly changes anything - they are *very* good at
> getting their changes upstream first.
>
> I don't suppose you have an /etc/mdadm.conf as well as /etc/mdadm/mdadm.c=
onf
> do you? If you did and the two were different=2C the Debian's mdadm would
> behave a bit differently to upstream (they prefer different config files)=
 but
> I very much doubt that is the problem.
>

There is no /etc/mdadm.conf on the filesystem only /etc/mdadm/mdadm.conf


> But I guess if the self-compiled one works (even when you take the patch
> out)=2C then just
> make install

I wish this was the case...

>
> and be happy.
>
> NeilBrown
>
>
> >
> >
> > Full output at: http://paste.debian.net/100103/
> > expires:
> >
> > 2010-11-21 06:07:30

Thanks

-M
 		 	   		  =

--_29b761cb-2fd0-4c65-b0af-e851a6d608d6_
Content-Type: text/plain
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="Compiled version.txt"

Q29tcGlsZWQgdmVyc2lvbgoKLi9tZGFkbSAtU3MKCm1kYWRtOiBzdG9wcGVkIC9kZXYvbWQxMjcK
Cj09PQoKLi9tZGFkbSAtQXN2dgoKbWRhZG06IGxvb2tpbmcgZm9yIGRldmljZXMgZm9yIGZ1cnRo
ZXIgYXNzZW1ibHkKbWRhZG06IG5vIFJBSUQgc3VwZXJibG9jayBvbiAvZGV2L2RtLTMKbWRhZG06
IC9kZXYvZG0tMyBoYXMgd3JvbmcgdXVpZC4KIHdhbnQgVVVJRC0wODRiOTY5YTowODA4ZjViODo2
Yzc4NGZiNzo2MjY1OTM4MwogdHN0PTB4OTgyMDEwIHNiPShuaWwpCm1kYWRtOiBubyBSQUlEIHN1
cGVyYmxvY2sgb24gL2Rldi9kbS0yCm1kYWRtOiAvZGV2L2RtLTIgaGFzIHdyb25nIHV1aWQuCiB3
YW50IFVVSUQtMDg0Yjk2OWE6MDgwOGY1Yjg6NmM3ODRmYjc6NjI2NTkzODMKIHRzdD0weDk4MjEy
MCBzYj0obmlsKQptZGFkbTogbm8gUkFJRCBzdXBlcmJsb2NrIG9uIC9kZXYvZG0tMQptZGFkbTog
L2Rldi9kbS0xIGhhcyB3cm9uZyB1dWlkLgogd2FudCBVVUlELTA4NGI5NjlhOjA4MDhmNWI4OjZj
Nzg0ZmI3OjYyNjU5MzgzCiB0c3Q9MHg5ODIxYjAgc2I9KG5pbCkKbWRhZG06IG5vIFJBSUQgc3Vw
ZXJibG9jayBvbiAvZGV2L2RtLTAKbWRhZG06IC9kZXYvZG0tMCBoYXMgd3JvbmcgdXVpZC4KIHdh
bnQgVVVJRC0wODRiOTY5YTowODA4ZjViODo2Yzc4NGZiNzo2MjY1OTM4MwogdHN0PTB4OTkxOWEw
IHNiPShuaWwpCm1kYWRtOiBubyBSQUlEIHN1cGVyYmxvY2sgb24gL2Rldi9sb29wMAptZGFkbTog
L2Rldi9sb29wMCBoYXMgd3JvbmcgdXVpZC4KIHdhbnQgVVVJRC0wODRiOTY5YTowODA4ZjViODo2
Yzc4NGZiNzo2MjY1OTM4MwogdHN0PTB4OTkxYTMwIHNiPShuaWwpCm1kYWRtOiBjYW5ub3Qgb3Bl
biBkZXZpY2UgL2Rldi9zZGM3OiBEZXZpY2Ugb3IgcmVzb3VyY2UgYnVzeQptZGFkbTogL2Rldi9z
ZGM3IGhhcyB3cm9uZyB1dWlkLgogd2FudCBVVUlELTA4NGI5NjlhOjA4MDhmNWI4OjZjNzg0ZmI3
OjYyNjU5MzgzCiB0c3Q9MHg5OTFhYzAgc2I9KG5pbCkKbWRhZG06IGNhbm5vdCBvcGVuIGRldmlj
ZSAvZGV2L3NkYzY6IERldmljZSBvciByZXNvdXJjZSBidXN5Cm1kYWRtOiAvZGV2L3NkYzYgaGFz
IHdyb25nIHV1aWQuCiB3YW50IFVVSUQtMDg0Yjk2OWE6MDgwOGY1Yjg6NmM3ODRmYjc6NjI2NTkz
ODMKIHRzdD0weDk5MWI1MCBzYj0obmlsKQptZGFkbTogY2Fubm90IG9wZW4gZGV2aWNlIC9kZXYv
c2RjNTogRGV2aWNlIG9yIHJlc291cmNlIGJ1c3kKbWRhZG06IC9kZXYvc2RjNSBoYXMgd3Jvbmcg
dXVpZC4KIHdhbnQgVVVJRC0wODRiOTY5YTowODA4ZjViODo2Yzc4NGZiNzo2MjY1OTM4MwogdHN0
PTB4OTkxYmUwIHNiPShuaWwpCm1kYWRtOiBubyBSQUlEIHN1cGVyYmxvY2sgb24gL2Rldi9zZGMy
Cm1kYWRtOiAvZGV2L3NkYzIgaGFzIHdyb25nIHV1aWQuCiB3YW50IFVVSUQtMDg0Yjk2OWE6MDgw
OGY1Yjg6NmM3ODRmYjc6NjI2NTkzODMKIHRzdD0weDk5MWM3MCBzYj0obmlsKQptZGFkbTogY2Fu
bm90IG9wZW4gZGV2aWNlIC9kZXYvc2RjMTogRGV2aWNlIG9yIHJlc291cmNlIGJ1c3kKbWRhZG06
IC9kZXYvc2RjMSBoYXMgd3JvbmcgdXVpZC4KIHdhbnQgVVVJRC0wODRiOTY5YTowODA4ZjViODo2
Yzc4NGZiNzo2MjY1OTM4MwogdHN0PTB4OTkxZDAwIHNiPShuaWwpCm1kYWRtOiBjYW5ub3Qgb3Bl
biBkZXZpY2UgL2Rldi9zZGM6IERldmljZSBvciByZXNvdXJjZSBidXN5Cm1kYWRtOiAvZGV2L3Nk
YyBoYXMgd3JvbmcgdXVpZC4KIHdhbnQgVVVJRC0wODRiOTY5YTowODA4ZjViODo2Yzc4NGZiNzo2
MjY1OTM4MwogdHN0PTB4OTkxZDkwIHNiPShuaWwpCm1kYWRtOiAvZGV2L3NkYiBpcyBpZGVudGlm
aWVkIGFzIGEgbWVtYmVyIG9mIC9kZXYvbWQvaW1zbTAsIHNsb3QgLTEuCm1kYWRtOiAvZGV2L3Nk
YSBpcyBpZGVudGlmaWVkIGFzIGEgbWVtYmVyIG9mIC9kZXYvbWQvaW1zbTAsIHNsb3QgLTEuCm1k
YWRtOiBhZGRlZCAvZGV2L3NkYSB0byAvZGV2L21kL2ltc20wIGFzIC0xCm1kYWRtOiBhZGRlZCAv
ZGV2L3NkYiB0byAvZGV2L21kL2ltc20wIGFzIC0xCm1kYWRtOiBDb250YWluZXIgL2Rldi9tZC9p
bXNtMCBoYXMgYmVlbiBhc3NlbWJsZWQgd2l0aCAyIGRyaXZlcwptZGFkbTogbG9va2luZyBmb3Ig
ZGV2aWNlcyBmb3IgL2Rldi9tZC9PbmVUQi1SQUlEMS1QVgptZGFkbTogbm8gcmVjb2duaXNlYWJs
ZSBzdXBlcmJsb2NrIG9uIC9kZXYvZG0tMwptZGFkbS9kZXYvZG0tMyBpcyBub3QgYSBjb250YWlu
ZXIsIGFuZCBvbmUgaXMgcmVxdWlyZWQuCm1kYWRtOiBubyByZWNvZ25pc2VhYmxlIHN1cGVyYmxv
Y2sgb24gL2Rldi9kbS0yCm1kYWRtL2Rldi9kbS0yIGlzIG5vdCBhIGNvbnRhaW5lciwgYW5kIG9u
ZSBpcyByZXF1aXJlZC4KbWRhZG06IG5vIHJlY29nbmlzZWFibGUgc3VwZXJibG9jayBvbiAvZGV2
L2RtLTEKbWRhZG0vZGV2L2RtLTEgaXMgbm90IGEgY29udGFpbmVyLCBhbmQgb25lIGlzIHJlcXVp
cmVkLgptZGFkbTogbm8gcmVjb2duaXNlYWJsZSBzdXBlcmJsb2NrIG9uIC9kZXYvZG0tMAptZGFk
bS9kZXYvZG0tMCBpcyBub3QgYSBjb250YWluZXIsIGFuZCBvbmUgaXMgcmVxdWlyZWQuCm1kYWRt
OiBubyByZWNvZ25pc2VhYmxlIHN1cGVyYmxvY2sgb24gL2Rldi9sb29wMAptZGFkbS9kZXYvbG9v
cDAgaXMgbm90IGEgY29udGFpbmVyLCBhbmQgb25lIGlzIHJlcXVpcmVkLgptZGFkbTogY2Fubm90
IG9wZW4gZGV2aWNlIC9kZXYvc2RjNzogRGV2aWNlIG9yIHJlc291cmNlIGJ1c3kKbWRhZG0vZGV2
L3NkYzcgaXMgbm90IGEgY29udGFpbmVyLCBhbmQgb25lIGlzIHJlcXVpcmVkLgptZGFkbTogY2Fu
bm90IG9wZW4gZGV2aWNlIC9kZXYvc2RjNjogRGV2aWNlIG9yIHJlc291cmNlIGJ1c3kKbWRhZG0v
ZGV2L3NkYzYgaXMgbm90IGEgY29udGFpbmVyLCBhbmQgb25lIGlzIHJlcXVpcmVkLgptZGFkbTog
Y2Fubm90IG9wZW4gZGV2aWNlIC9kZXYvc2RjNTogRGV2aWNlIG9yIHJlc291cmNlIGJ1c3kKbWRh
ZG0vZGV2L3NkYzUgaXMgbm90IGEgY29udGFpbmVyLCBhbmQgb25lIGlzIHJlcXVpcmVkLgptZGFk
bTogbm8gcmVjb2duaXNlYWJsZSBzdXBlcmJsb2NrIG9uIC9kZXYvc2RjMgptZGFkbS9kZXYvc2Rj
MiBpcyBub3QgYSBjb250YWluZXIsIGFuZCBvbmUgaXMgcmVxdWlyZWQuCm1kYWRtOiBjYW5ub3Qg
b3BlbiBkZXZpY2UgL2Rldi9zZGMxOiBEZXZpY2Ugb3IgcmVzb3VyY2UgYnVzeQptZGFkbS9kZXYv
c2RjMSBpcyBub3QgYSBjb250YWluZXIsIGFuZCBvbmUgaXMgcmVxdWlyZWQuCm1kYWRtOiBjYW5u
b3Qgb3BlbiBkZXZpY2UgL2Rldi9zZGM6IERldmljZSBvciByZXNvdXJjZSBidXN5Cm1kYWRtL2Rl
di9zZGMgaXMgbm90IGEgY29udGFpbmVyLCBhbmQgb25lIGlzIHJlcXVpcmVkLgptZGFkbTogY2Fu
bm90IG9wZW4gZGV2aWNlIC9kZXYvc2RiOiBEZXZpY2Ugb3IgcmVzb3VyY2UgYnVzeQptZGFkbS9k
ZXYvc2RiIGlzIG5vdCBhIGNvbnRhaW5lciwgYW5kIG9uZSBpcyByZXF1aXJlZC4KbWRhZG06IGNh
bm5vdCBvcGVuIGRldmljZSAvZGV2L3NkYTogRGV2aWNlIG9yIHJlc291cmNlIGJ1c3kKbWRhZG0v
ZGV2L3NkYSBpcyBub3QgYSBjb250YWluZXIsIGFuZCBvbmUgaXMgcmVxdWlyZWQuCm1kYWRtOiBs
b29raW5nIGZvciBkZXZpY2VzIGZvciAvZGV2L21kL09uZVRCLVJBSUQxLVBWCm1kYWRtOiBubyBy
ZWNvZ25pc2VhYmxlIHN1cGVyYmxvY2sgb24gL2Rldi9kbS0zCm1kYWRtL2Rldi9kbS0zIGlzIG5v
dCBhIGNvbnRhaW5lciwgYW5kIG9uZSBpcyByZXF1aXJlZC4KbWRhZG06IG5vIHJlY29nbmlzZWFi
bGUgc3VwZXJibG9jayBvbiAvZGV2L2RtLTIKbWRhZG0vZGV2L2RtLTIgaXMgbm90IGEgY29udGFp
bmVyLCBhbmQgb25lIGlzIHJlcXVpcmVkLgptZGFkbTogbm8gcmVjb2duaXNlYWJsZSBzdXBlcmJs
b2NrIG9uIC9kZXYvZG0tMQptZGFkbS9kZXYvZG0tMSBpcyBub3QgYSBjb250YWluZXIsIGFuZCBv
bmUgaXMgcmVxdWlyZWQuCm1kYWRtOiBubyByZWNvZ25pc2VhYmxlIHN1cGVyYmxvY2sgb24gL2Rl
di9kbS0wCm1kYWRtL2Rldi9kbS0wIGlzIG5vdCBhIGNvbnRhaW5lciwgYW5kIG9uZSBpcyByZXF1
aXJlZC4KbWRhZG06IG5vIHJlY29nbmlzZWFibGUgc3VwZXJibG9jayBvbiAvZGV2L2xvb3AwCm1k
YWRtL2Rldi9sb29wMCBpcyBub3QgYSBjb250YWluZXIsIGFuZCBvbmUgaXMgcmVxdWlyZWQuCm1k
YWRtOiBjYW5ub3Qgb3BlbiBkZXZpY2UgL2Rldi9zZGM3OiBEZXZpY2Ugb3IgcmVzb3VyY2UgYnVz
eQptZGFkbS9kZXYvc2RjNyBpcyBub3QgYSBjb250YWluZXIsIGFuZCBvbmUgaXMgcmVxdWlyZWQu
Cm1kYWRtOiBjYW5ub3Qgb3BlbiBkZXZpY2UgL2Rldi9zZGM2OiBEZXZpY2Ugb3IgcmVzb3VyY2Ug
YnVzeQptZGFkbS9kZXYvc2RjNiBpcyBub3QgYSBjb250YWluZXIsIGFuZCBvbmUgaXMgcmVxdWly
ZWQuCm1kYWRtOiBjYW5ub3Qgb3BlbiBkZXZpY2UgL2Rldi9zZGM1OiBEZXZpY2Ugb3IgcmVzb3Vy
Y2UgYnVzeQptZGFkbS9kZXYvc2RjNSBpcyBub3QgYSBjb250YWluZXIsIGFuZCBvbmUgaXMgcmVx
dWlyZWQuCm1kYWRtOiBubyByZWNvZ25pc2VhYmxlIHN1cGVyYmxvY2sgb24gL2Rldi9zZGMyCm1k
YWRtL2Rldi9zZGMyIGlzIG5vdCBhIGNvbnRhaW5lciwgYW5kIG9uZSBpcyByZXF1aXJlZC4KbWRh
ZG06IGNhbm5vdCBvcGVuIGRldmljZSAvZGV2L3NkYzE6IERldmljZSBvciByZXNvdXJjZSBidXN5
Cm1kYWRtL2Rldi9zZGMxIGlzIG5vdCBhIGNvbnRhaW5lciwgYW5kIG9uZSBpcyByZXF1aXJlZC4K
bWRhZG06IGNhbm5vdCBvcGVuIGRldmljZSAvZGV2L3NkYzogRGV2aWNlIG9yIHJlc291cmNlIGJ1
c3kKbWRhZG0vZGV2L3NkYyBpcyBub3QgYSBjb250YWluZXIsIGFuZCBvbmUgaXMgcmVxdWlyZWQu
Cm1kYWRtOiBjYW5ub3Qgb3BlbiBkZXZpY2UgL2Rldi9zZGI6IERldmljZSBvciByZXNvdXJjZSBi
dXN5Cm1kYWRtL2Rldi9zZGIgaXMgbm90IGEgY29udGFpbmVyLCBhbmQgb25lIGlzIHJlcXVpcmVk
LgptZGFkbTogY2Fubm90IG9wZW4gZGV2aWNlIC9kZXYvc2RhOiBEZXZpY2Ugb3IgcmVzb3VyY2Ug
YnVzeQptZGFkbS9kZXYvc2RhIGlzIG5vdCBhIGNvbnRhaW5lciwgYW5kIG9uZSBpcyByZXF1aXJl
ZC4KCg==

--_29b761cb-2fd0-4c65-b0af-e851a6d608d6_
Content-Type: text/plain
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="DEBIAN version.txt"

REVCSUFOIG1kYWRtCgptZGFkbSAtU3MKCm1kYWRtOiBzdG9wcGVkIC9kZXYvbWQxMjcKCj09PQoK
bWRhZG0gLUFzdnYKCm1kYWRtOiBsb29raW5nIGZvciBkZXZpY2VzIGZvciBmdXJ0aGVyIGFzc2Vt
Ymx5Cm1kYWRtOiBubyBSQUlEIHN1cGVyYmxvY2sgb24gL2Rldi9kbS0zCm1kYWRtOiAvZGV2L2Rt
LTMgaGFzIHdyb25nIHV1aWQuCm1kYWRtOiBubyBSQUlEIHN1cGVyYmxvY2sgb24gL2Rldi9kbS0y
Cm1kYWRtOiAvZGV2L2RtLTIgaGFzIHdyb25nIHV1aWQuCm1kYWRtOiBubyBSQUlEIHN1cGVyYmxv
Y2sgb24gL2Rldi9kbS0xCm1kYWRtOiAvZGV2L2RtLTEgaGFzIHdyb25nIHV1aWQuCm1kYWRtOiBu
byBSQUlEIHN1cGVyYmxvY2sgb24gL2Rldi9kbS0wCm1kYWRtOiAvZGV2L2RtLTAgaGFzIHdyb25n
IHV1aWQuCm1kYWRtOiBubyBSQUlEIHN1cGVyYmxvY2sgb24gL2Rldi9sb29wMAptZGFkbTogL2Rl
di9sb29wMCBoYXMgd3JvbmcgdXVpZC4KbWRhZG06IGNhbm5vdCBvcGVuIGRldmljZSAvZGV2L3Nk
Yzc6IERldmljZSBvciByZXNvdXJjZSBidXN5Cm1kYWRtOiAvZGV2L3NkYzcgaGFzIHdyb25nIHV1
aWQuCm1kYWRtOiBjYW5ub3Qgb3BlbiBkZXZpY2UgL2Rldi9zZGM2OiBEZXZpY2Ugb3IgcmVzb3Vy
Y2UgYnVzeQptZGFkbTogL2Rldi9zZGM2IGhhcyB3cm9uZyB1dWlkLgptZGFkbTogY2Fubm90IG9w
ZW4gZGV2aWNlIC9kZXYvc2RjNTogRGV2aWNlIG9yIHJlc291cmNlIGJ1c3kKbWRhZG06IC9kZXYv
c2RjNSBoYXMgd3JvbmcgdXVpZC4KbWRhZG06IG5vIFJBSUQgc3VwZXJibG9jayBvbiAvZGV2L3Nk
YzIKbWRhZG06IC9kZXYvc2RjMiBoYXMgd3JvbmcgdXVpZC4KbWRhZG06IGNhbm5vdCBvcGVuIGRl
dmljZSAvZGV2L3NkYzE6IERldmljZSBvciByZXNvdXJjZSBidXN5Cm1kYWRtOiAvZGV2L3NkYzEg
aGFzIHdyb25nIHV1aWQuCm1kYWRtOiBjYW5ub3Qgb3BlbiBkZXZpY2UgL2Rldi9zZGM6IERldmlj
ZSBvciByZXNvdXJjZSBidXN5Cm1kYWRtOiAvZGV2L3NkYyBoYXMgd3JvbmcgdXVpZC4KbWRhZG06
IC9kZXYvc2RiIGlzIGlkZW50aWZpZWQgYXMgYSBtZW1iZXIgb2YgL2Rldi9tZC9pbXNtMCwgc2xv
dCAtMS4KbWRhZG06IC9kZXYvc2RhIGlzIGlkZW50aWZpZWQgYXMgYSBtZW1iZXIgb2YgL2Rldi9t
ZC9pbXNtMCwgc2xvdCAtMS4KbWRhZG06IGFkZGVkIC9kZXYvc2RhIHRvIC9kZXYvbWQvaW1zbTAg
YXMgLTEKbWRhZG06IGFkZGVkIC9kZXYvc2RiIHRvIC9kZXYvbWQvaW1zbTAgYXMgLTEKbWRhZG06
IENvbnRhaW5lciAvZGV2L21kL2ltc20wIGhhcyBiZWVuIGFzc2VtYmxlZCB3aXRoIDIgZHJpdmVz
Cm1kYWRtOiBsb29raW5nIGZvciBkZXZpY2VzIGZvciAvZGV2L21kL09uZVRCLVJBSUQxLVBWCm1k
YWRtOiBubyByZWNvZ25pc2VhYmxlIHN1cGVyYmxvY2sgb24gL2Rldi9kbS0zCm1kYWRtL2Rldi9k
bS0zIGlzIG5vdCBhIGNvbnRhaW5lciwgYW5kIG9uZSBpcyByZXF1aXJlZC4KbWRhZG06IG5vIHJl
Y29nbmlzZWFibGUgc3VwZXJibG9jayBvbiAvZGV2L2RtLTIKbWRhZG0vZGV2L2RtLTIgaXMgbm90
IGEgY29udGFpbmVyLCBhbmQgb25lIGlzIHJlcXVpcmVkLgptZGFkbTogbm8gcmVjb2duaXNlYWJs
ZSBzdXBlcmJsb2NrIG9uIC9kZXYvZG0tMQptZGFkbS9kZXYvZG0tMSBpcyBub3QgYSBjb250YWlu
ZXIsIGFuZCBvbmUgaXMgcmVxdWlyZWQuCm1kYWRtOiBubyByZWNvZ25pc2VhYmxlIHN1cGVyYmxv
Y2sgb24gL2Rldi9kbS0wCm1kYWRtL2Rldi9kbS0wIGlzIG5vdCBhIGNvbnRhaW5lciwgYW5kIG9u
ZSBpcyByZXF1aXJlZC4KbWRhZG06IG5vIHJlY29nbmlzZWFibGUgc3VwZXJibG9jayBvbiAvZGV2
L2xvb3AwCm1kYWRtL2Rldi9sb29wMCBpcyBub3QgYSBjb250YWluZXIsIGFuZCBvbmUgaXMgcmVx
dWlyZWQuCm1kYWRtOiBjYW5ub3Qgb3BlbiBkZXZpY2UgL2Rldi9zZGM3OiBEZXZpY2Ugb3IgcmVz
b3VyY2UgYnVzeQptZGFkbS9kZXYvc2RjNyBpcyBub3QgYSBjb250YWluZXIsIGFuZCBvbmUgaXMg
cmVxdWlyZWQuCm1kYWRtOiBjYW5ub3Qgb3BlbiBkZXZpY2UgL2Rldi9zZGM2OiBEZXZpY2Ugb3Ig
cmVzb3VyY2UgYnVzeQptZGFkbS9kZXYvc2RjNiBpcyBub3QgYSBjb250YWluZXIsIGFuZCBvbmUg
aXMgcmVxdWlyZWQuCm1kYWRtOiBjYW5ub3Qgb3BlbiBkZXZpY2UgL2Rldi9zZGM1OiBEZXZpY2Ug
b3IgcmVzb3VyY2UgYnVzeQptZGFkbS9kZXYvc2RjNSBpcyBub3QgYSBjb250YWluZXIsIGFuZCBv
bmUgaXMgcmVxdWlyZWQuCm1kYWRtOiBubyByZWNvZ25pc2VhYmxlIHN1cGVyYmxvY2sgb24gL2Rl
di9zZGMyCm1kYWRtL2Rldi9zZGMyIGlzIG5vdCBhIGNvbnRhaW5lciwgYW5kIG9uZSBpcyByZXF1
aXJlZC4KbWRhZG06IGNhbm5vdCBvcGVuIGRldmljZSAvZGV2L3NkYzE6IERldmljZSBvciByZXNv
dXJjZSBidXN5Cm1kYWRtL2Rldi9zZGMxIGlzIG5vdCBhIGNvbnRhaW5lciwgYW5kIG9uZSBpcyBy
ZXF1aXJlZC4KbWRhZG06IGNhbm5vdCBvcGVuIGRldmljZSAvZGV2L3NkYzogRGV2aWNlIG9yIHJl
c291cmNlIGJ1c3kKbWRhZG0vZGV2L3NkYyBpcyBub3QgYSBjb250YWluZXIsIGFuZCBvbmUgaXMg
cmVxdWlyZWQuCm1kYWRtOiBjYW5ub3Qgb3BlbiBkZXZpY2UgL2Rldi9zZGI6IERldmljZSBvciBy
ZXNvdXJjZSBidXN5Cm1kYWRtL2Rldi9zZGIgaXMgbm90IGEgY29udGFpbmVyLCBhbmQgb25lIGlz
IHJlcXVpcmVkLgptZGFkbTogY2Fubm90IG9wZW4gZGV2aWNlIC9kZXYvc2RhOiBEZXZpY2Ugb3Ig
cmVzb3VyY2UgYnVzeQptZGFkbS9kZXYvc2RhIGlzIG5vdCBhIGNvbnRhaW5lciwgYW5kIG9uZSBp
cyByZXF1aXJlZC4KbWRhZG06IGxvb2tpbmcgZm9yIGRldmljZXMgZm9yIC9kZXYvbWQvT25lVEIt
UkFJRDEtUFYKbWRhZG06IG5vIHJlY29nbmlzZWFibGUgc3VwZXJibG9jayBvbiAvZGV2L2RtLTMK
bWRhZG0vZGV2L2RtLTMgaXMgbm90IGEgY29udGFpbmVyLCBhbmQgb25lIGlzIHJlcXVpcmVkLgpt
ZGFkbTogbm8gcmVjb2duaXNlYWJsZSBzdXBlcmJsb2NrIG9uIC9kZXYvZG0tMgptZGFkbS9kZXYv
ZG0tMiBpcyBub3QgYSBjb250YWluZXIsIGFuZCBvbmUgaXMgcmVxdWlyZWQuCm1kYWRtOiBubyBy
ZWNvZ25pc2VhYmxlIHN1cGVyYmxvY2sgb24gL2Rldi9kbS0xCm1kYWRtL2Rldi9kbS0xIGlzIG5v
dCBhIGNvbnRhaW5lciwgYW5kIG9uZSBpcyByZXF1aXJlZC4KbWRhZG06IG5vIHJlY29nbmlzZWFi
bGUgc3VwZXJibG9jayBvbiAvZGV2L2RtLTAKbWRhZG0vZGV2L2RtLTAgaXMgbm90IGEgY29udGFp
bmVyLCBhbmQgb25lIGlzIHJlcXVpcmVkLgptZGFkbTogbm8gcmVjb2duaXNlYWJsZSBzdXBlcmJs
b2NrIG9uIC9kZXYvbG9vcDAKbWRhZG0vZGV2L2xvb3AwIGlzIG5vdCBhIGNvbnRhaW5lciwgYW5k
IG9uZSBpcyByZXF1aXJlZC4KbWRhZG06IGNhbm5vdCBvcGVuIGRldmljZSAvZGV2L3NkYzc6IERl
dmljZSBvciByZXNvdXJjZSBidXN5Cm1kYWRtL2Rldi9zZGM3IGlzIG5vdCBhIGNvbnRhaW5lciwg
YW5kIG9uZSBpcyByZXF1aXJlZC4KbWRhZG06IGNhbm5vdCBvcGVuIGRldmljZSAvZGV2L3NkYzY6
IERldmljZSBvciByZXNvdXJjZSBidXN5Cm1kYWRtL2Rldi9zZGM2IGlzIG5vdCBhIGNvbnRhaW5l
ciwgYW5kIG9uZSBpcyByZXF1aXJlZC4KbWRhZG06IGNhbm5vdCBvcGVuIGRldmljZSAvZGV2L3Nk
YzU6IERldmljZSBvciByZXNvdXJjZSBidXN5Cm1kYWRtL2Rldi9zZGM1IGlzIG5vdCBhIGNvbnRh
aW5lciwgYW5kIG9uZSBpcyByZXF1aXJlZC4KbWRhZG06IG5vIHJlY29nbmlzZWFibGUgc3VwZXJi
bG9jayBvbiAvZGV2L3NkYzIKbWRhZG0vZGV2L3NkYzIgaXMgbm90IGEgY29udGFpbmVyLCBhbmQg
b25lIGlzIHJlcXVpcmVkLgptZGFkbTogY2Fubm90IG9wZW4gZGV2aWNlIC9kZXYvc2RjMTogRGV2
aWNlIG9yIHJlc291cmNlIGJ1c3kKbWRhZG0vZGV2L3NkYzEgaXMgbm90IGEgY29udGFpbmVyLCBh
bmQgb25lIGlzIHJlcXVpcmVkLgptZGFkbTogY2Fubm90IG9wZW4gZGV2aWNlIC9kZXYvc2RjOiBE
ZXZpY2Ugb3IgcmVzb3VyY2UgYnVzeQptZGFkbS9kZXYvc2RjIGlzIG5vdCBhIGNvbnRhaW5lciwg
YW5kIG9uZSBpcyByZXF1aXJlZC4KbWRhZG06IGNhbm5vdCBvcGVuIGRldmljZSAvZGV2L3NkYjog
RGV2aWNlIG9yIHJlc291cmNlIGJ1c3kKbWRhZG0vZGV2L3NkYiBpcyBub3QgYSBjb250YWluZXIs
IGFuZCBvbmUgaXMgcmVxdWlyZWQuCm1kYWRtOiBjYW5ub3Qgb3BlbiBkZXZpY2UgL2Rldi9zZGE6
IERldmljZSBvciByZXNvdXJjZSBidXN5Cm1kYWRtL2Rldi9zZGEgaXMgbm90IGEgY29udGFpbmVy
LCBhbmQgb25lIGlzIHJlcXVpcmVkLgoK

--_29b761cb-2fd0-4c65-b0af-e851a6d608d6_--
