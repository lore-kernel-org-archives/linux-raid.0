From: Grant Parnell - EverythingLinux <grant@everythinglinux.com.au>
Subject: swiss cheesed raid5 raid recovery?
Date: Wed, 19 May 2004 11:36:26 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0405191108360.4173-201000@beast.in.emusys.com.au>
References: <16553.58422.392717.358945@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463807999-336020127-1084930586=:4173"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16553.58422.392717.358945@cse.unsw.edu.au>
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@cse.unsw.edu.au>
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

---1463807999-336020127-1084930586=:4173
Content-Type: TEXT/PLAIN; charset=US-ASCII

Thanks heaps Neil. There turns out to be quite a lot of combinations to 
try so I thought I'd try programatically all 96 of them. Essentially 
creating an array and seeing if I can extract a directory listing using 
debugfs. I am curious as to whether the order of the devices matters and 
also what are the consequences of getting the layout wrong. All but one 
were originally set to 'left-symmetric', the other was 'left-asymmetric'.

Anyway... the best I got was 24 cases of 'EXT2 directory corrupted'

Attached is the perl script and log output. Other people may find the 
script of use. Hopefully someone has some other ideas for testing the 
filesystem.

On Tue, 18 May 2004, Neil Brown wrote:

> On Tuesday May 18, grant@everythinglinux.com.au wrote:
> > If there's a proper place to ask, please forward this on.
> 
> linux-raid@vger.kernel.org would be the best place.
> 
> > 
> > I've got a very silly client who has no backup of this data and would like 
> > it recovered and doesen't mind the wait. Description was that one of the 
> > physical disks had failed for some time (OK so far) ... then recently 
> > another failed although he thinks the 2nd failure was just a small glitch 
> > and it could be put back into service (sounds OK but not great).
> > 
> > What I'd like is to be able to try various combinations of the partitions 
> > to assemble into an array in a read-only fassion (at the partition level!) 
> > so as not to write to the disks under any circumstances.
> 
> What I would do is 
>  - use "mdadm --examine" on each device so as to have a permanent
>    record of what the superblocks contained.
>  - use "mdadm --create" with various combinations of devices, always
>    specifying one slot as "missing"
> 
> This will over-write the superblocks, but nothing else (as there is a
> missing device, no resync can happen).
> 
> If you manage to find some correct configuration, hot-add a fourth
> drive and be happy.
> 
> This does change the UUID, but it is much easier than any alternative.
> 
> There is no tool (to my knowledge) for generally editing md
> superblocks. 
> 
> > 
> > By looking at /dev/md1 so far with hdd3, hde3, hdg3 it barely looks like 
> > an ext2/3 filesystem. Even debugfs is giving up.
> 
> That would have been the best bet, and what "mdadm --assemble --force"
> would have provided.  
> 
> I don't suppose the customer remembers what they did for hdc3.....
> 
> 
> NeilBrown
> 

-- 
---<GRiP>--- 
Grant Parnell - senior consultant
EverythingLinux services - the consultant's backup & tech support.
Web: http://www.everythinglinux.com.au/support.php
We're also busybits.com.au and linuxhelp.com.au and elx.com.au.
Phone 02 8752 6622 to book service or discuss your needs.

ELX or its employees participate in the following:-
OSIA (Open Source Industry Australia) - http://www.osia.net.au
AUUG (Australian Unix Users Group) - http://www.auug.org.au
SLUG (Sydney Linux Users Group) - http://www.slug.org.au
LA (Linux Australia) - http://www.linux.org.au

---1463807999-336020127-1084930586=:4173
Content-Type: TEXT/PLAIN; charset=US-ASCII; name="combo.pl"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44.0405191136260.4173@beast.in.emusys.com.au>
Content-Description: 
Content-Disposition: attachment; filename="combo.pl"

IyEvdXNyL2Jpbi9wZXJsDQoNCm15IEBkZXZzID0gcXcgKCAvZGV2L2hkYzMg
L2Rldi9oZGQzIC9kZXYvaGRlMyAvZGV2L2hkZzMgKTsNCg0KZm9yKG15ICRt
aXNzaW5nPTE7ICRtaXNzaW5nPD00OyAkbWlzc2luZysrKQ0Kew0KCWZvciAo
bXkgJGRldjE9MDsgJGRldjE8PTM7ICRkZXYxKyspDQoJew0KCQlmb3IgKG15
ICRkZXYyPTA7ICRkZXYyPD0zOyAkZGV2MisrKQ0KCQl7DQoJCQluZXh0IGlm
ICgkZGV2MiA9PSAkZGV2MSk7DQoJCQlmb3IgKG15ICRkZXYzPTA7ICRkZXYz
PD0zOyAkZGV2MysrKQ0KCQkJew0KCQkJCW5leHQgaWYgKCRkZXYzID09ICRk
ZXYyIHx8ICRkZXYzID09ICRkZXYxKTsNCgkJCQkjcHJpbnQgIm1pc3Npbmc9
JG1pc3NpbmcsIGRldjE9JGRldjEsIGRldjI9JGRldjIsIGRldjM9JGRldjNc
biI7DQoJCQkJbXkgJGRwb3M9MTsNCgkJCQlteSAkZGV2bGlzdD0nJzsNCgkJ
CQlmb3IgKG15ICRwb3M9MTsgJHBvczw9NDsgJHBvcysrKQ0KCQkJCXsNCgkJ
CQkJaWYoJHBvcz09JG1pc3NpbmcpIHsgJGRldmxpc3QuPSJtaXNzaW5nICI7
IH0NCgkJCQkJZWxzaWYoJGRwb3M9PTEpIHsgJGRldmxpc3QuPSIkZGV2c1sk
ZGV2MV0gIjsgJGRwb3MrKzsgfQ0KCQkJCQllbHNpZigkZHBvcz09MikgeyAk
ZGV2bGlzdC49IiRkZXZzWyRkZXYyXSAiOyAkZHBvcysrOyB9DQoJCQkJCWVs
c2lmKCRkcG9zPT0zKSB7ICRkZXZsaXN0Lj0iJGRldnNbJGRldjNdICI7ICRk
cG9zKys7IH0NCgkJCQl9CQ0KCQkJCW15ICRzdGF0dXMgPSBjaGVja19yYWlk
KCRkZXZsaXN0KTsNCgkJCQlwcmludCAiJHN0YXR1c1xuIjsNCgkJCX0NCgkJ
fQ0KCX0NCn0NCg0Kc3ViIGNoZWNrX3JhaWQNCnsNCglteSAoJGRldmxpc3Qp
ID0gQF87DQoJaWYgKCEgJGRldmxpc3QpIHsgcmV0dXJuICJmYWlsZWQgY29t
bWFuZCI7IH0NCgkjIHN0b3AgdGhlIGFycmF5IGlmIHN0YXJ0ZWQNCglteSAk
Y21kID0gIm1kYWRtIC0tbWFuYWdlIC0tc3RvcCAvZGV2L21kMSI7DQoJZG9j
bWQoJGNtZCk7DQoJIyBjcmVhdGUgdGhlIGFycmF5DQoJJGNtZCA9ICJlY2hv
IHkgfCBtZGFkbSAtLWNyZWF0ZSAvZGV2L21kMSAtLWxldmVsPTUgLS1yYWlk
LWRldmljZXM9NCAtLXNwYXJlLWRldmljZXM9MCAkZGV2bGlzdCI7DQoJZG9j
bWQoJGNtZCk7DQoJIyBtYWtlIHJlYWQtb25seQ0KCSRjbWQgPSAibWRhZG0g
LS1taXNjIC0tcmVhZG9ubHkgL2Rldi9tZDEiOw0KCWRvY21kKCRjbWQpOw0K
CSMgZGVidWdmcyB0byBjaGVjaz8NCgkkY21kID0gImRlYnVnZnMgLVIgbHMi
Ow0KCW15ICRyZXN1bHQgPSBkb2NtZCgkY21kKTsNCglwcmludCAicmVzdWx0
OiAkcmVzdWx0XG4iOw0KCSNpZiAoJHJlc3VsdCA9fiAvXC9kZXZcL21kMS8p
IHsgcmV0dXJuICJmYWlsIjsgfSBlbHNlIHsgcmV0dXJuICJvayI7IH0NCglp
ZiAoJHJlc3VsdCA9fiAvOi8pIHsgcmV0dXJuICJmYWlsIjsgfSBlbHNlIHsg
cmV0dXJuICJvayI7IH0NCn0NCg0Kc3ViIGRvY21kDQp7DQoJbXkgKCRjbWQp
ID0gQF87DQoJcHJpbnQgInNoOiAkY21kXG4iOw0KCSNyZXR1cm4gJyc7DQoN
CglvcGVuKENNRCwiJGNtZCAyPiYxfCIpOw0KCW15ICRyZXN1bHQ9Jyc7DQoJ
d2hpbGUoPENNRD4pDQoJew0KCQkkcmVzdWx0Lj0kXzsNCgl9DQoJY2xvc2Uo
Q01EKTsNCglyZXR1cm4gJHJlc3VsdDsNCn0NCg==
---1463807999-336020127-1084930586=:4173
Content-Type: APPLICATION/x-gzip; name="combo.log.gz"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44.0405191136261.4173@beast.in.emusys.com.au>
Content-Description: 
Content-Disposition: attachment; filename="combo.log.gz"

H4sICCeyqkAAA2NvbWJvLmxvZwDt3E1r20AQxvG7oN9hj+1BjR03l0AOvRR6
K730rGonskAvxisHDP3wVVpiR6vs2LoF5n8TsvzCj/EzMzI4bO9d6wvfujxv
i66oZDwIQ79zN16eblq/zsJ4iZTb3h3dn9O15V6KQU4XjWcaeZLm4W482he1
z8cH6lLCw5fn19sVezmdWbm2DqHuqv/P3vpy83LkT0eycf/e+PTZ6lA+v7QU
vu+a4/TTefl9qB6Dy3+6JmR7CYdmOJ9df97c5b++/3Afb9f510OV365Wm09Z
E+7dt7qRcAyDtK7rB9fvpPuQZY9F3Uzf/B3BVMC8hpHXRMC8BUPFTGAqKuYS
DOE7idwSmEswZEw8vZyJgHkLhoqJxzoqRochfONkYY7RYciYeEMiY3QYKiZu
0lSMDkP4xnUCjA7DHBN/gcgYHYaKiRcBKkaHsRm+56rQbkAAk9izgUksB8Ak
ZmBgEo0bmER/sgvjZzDWV4IrYExnzBzG+uR7BQwVk74BAQxdKYIRJXxNzzEa
jOmMmcNYv4N3BQwVQ1daBmM6fCu60nIY03PMHIaudBGGimG7XgZjOnwnPWhO
BExizwYmsRwAk5iBgUk0bmAS/ckuzGTOBeY6GNMZ45XwNT35ajBUTPoGBDB0
pfmtzWT4mp5jNBjTGSPKEmk6YzQYKoautAzGdPhWdKXlMKbnmIqutByGimG7
XgZjOnwT/3/3QgRMYs8GJrEcAJOYgYFJNG5gEv3JLszk5xNgdBgyJp5e5usk
MHQl7ecTKkaHIXzjZGGO0WHImHhDImN0GCombtJUjA5D+MZ1AowOwxwTf4HI
GB2GiokXASpGh3k34fsX2aNQyGBpAAA=
---1463807999-336020127-1084930586=:4173--
