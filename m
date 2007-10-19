From: "Ross S. W. Walker" <rwalker@medallion.com>
Subject: Re: Abort Task ?
Date: Fri, 19 Oct 2007 08:25:58 -0400
Message-ID: <E2BB8074E5500C42984D980D4BD78EF9017A2961@MFG-NYC-EXCH2.mfg.prv>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0967676551=="
Return-path: <iscsitarget-devel-bounces@lists.sourceforge.net>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/iscsitarget-devel>,
	<mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=iscsitarget-devel>
List-Post: <mailto:iscsitarget-devel@lists.sourceforge.net>
List-Help: <mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/iscsitarget-devel>,
	<mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: iscsitarget-devel-bounces@lists.sourceforge.net
Errors-To: iscsitarget-devel-bounces@lists.sourceforge.net
To: joel.bertrand@systella.fr
Cc: iscsitarget-devel@lists.sourceforge.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.

--===============0967676551==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C8124B.33D38823"
Content-Transfer-Encoding: 7bit

This is a multi-part message in MIME format.

------_=_NextPart_001_01C8124B.33D38823
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Bertrand,

If you are using dd then there will only be 1 outstanding io at a time =
so only istd1 will have work since the initiator will not send the next =
io till istd1 returns the results from the first io and then the next io =
will be issued to istd1 again.

600us is a little slow, try disabling or limiting any interrupt =
coalesence on the network adapters. ISCSI is more sensitive to network =
latency then NFS or CIFS.

-Ross


-----Original Message-----
From: BERTRAND Jo=C3=ABl <joel.bertrand@systella.fr>
To: Ross S. W. Walker
CC: blackmagic02881@gmail.com <blackmagic02881@gmail.com>; =
iscsitarget-devel@lists.sourceforge.net =
<iscsitarget-devel@lists.sourceforge.net>; linux-raid@vger.kernel.org =
<linux-raid@vger.kernel.org>
Sent: Fri Oct 19 03:48:07 2007
Subject: Re: [Iscsitarget-devel] Abort Task ?

Ross S. W. Walker wrote:
> BERTRAND Jo=C3=ABl wrote:
>> BERTRAND Jo=C3=ABl wrote:
>>>     I can format serveral times (mkfs.ext3) a 1.5 TB volume=20
>> over iSCSI=20
>>> without any trouble. I can read and write on this virtual=20
>> disk without=20
>>> any trouble.
>>>
>>>     Now, I have configured ietd with :
>>>
>>> Lun 0 Sectors=3D1464725758,Type=3Dnullio
>>>
>>> and I run on initiator side :
>>>
>>> Root gershwin:[/dev] > dd if=3D/dev/zero of=3D/dev/sdj bs=3D8192
>>> 479482+0 records in
>>> 479482+0 records out
>>> 3927916544 bytes (3.9 GB) copied, 153.222 seconds, 25.6 MB/s
>>>
>>> Root gershwin:[/dev] > dd if=3D/dev/zero of=3D/dev/sdj bs=3D8192
>>>
>>>     I'm waitinfor a crash. No one when I write these lines.=20
>>    I suspect=20
>>> an interaction between raid and iscsi.
>> 	I simultanely run :
>>
>> Root gershwin:[/dev] > dd if=3D/dev/zero of=3D/dev/sdj bs=3D8192
>> 8397210+0 records in
>> 8397210+0 records out
>> 68789944320 bytes (69 GB) copied, 2732.55 seconds, 25.2 MB/s
>>
>> and
>>
>> Root gershwin:[~] > dd if=3D/dev/sdj of=3D/dev/null bs=3D8192
>> 739200+0 records in
>> 739199+0 records out
>> 6055518208 bytes (6.1 GB) copied, 447.178 seconds, 13.5 MB/s
>>
>> 	without any trouble.
>=20
> The speed can definitely be improved. Look at your network setup
> and use ping to try and get the network latency to a minimum.
>=20
> # ping -A -s 8192 172.16.24.140
> ....
> --- 172.16.24.140 ping statistics ---
> 14058 packets transmitted, 14057 received, 0% packet loss, time 9988ms
> rtt min/avg/max/mdev =3D 0.234/0.268/2.084/0.041 ms, ipg/ewma =
0.710/0.260 ms

gershwin:[~] > ping -A -s 8192 192.168.0.2
PING 192.168.0.2 (192.168.0.2) 8192(8220) bytes of data.
8200 bytes from 192.168.0.2: icmp_seq=3D1 ttl=3D64 time=3D0.693 ms
8200 bytes from 192.168.0.2: icmp_seq=3D2 ttl=3D64 time=3D0.595 ms
8200 bytes from 192.168.0.2: icmp_seq=3D3 ttl=3D64 time=3D0.583 ms
8200 bytes from 192.168.0.2: icmp_seq=3D4 ttl=3D64 time=3D0.589 ms
8200 bytes from 192.168.0.2: icmp_seq=3D5 ttl=3D64 time=3D0.580 ms
8200 bytes from 192.168.0.2: icmp_seq=3D6 ttl=3D64 time=3D0.594 ms
8200 bytes from 192.168.0.2: icmp_seq=3D7 ttl=3D64 time=3D0.580 ms
8200 bytes from 192.168.0.2: icmp_seq=3D8 ttl=3D64 time=3D0.592 ms
8200 bytes from 192.168.0.2: icmp_seq=3D9 ttl=3D64 time=3D0.589 ms
8200 bytes from 192.168.0.2: icmp_seq=3D10 ttl=3D64 time=3D0.571 ms
8200 bytes from 192.168.0.2: icmp_seq=3D11 ttl=3D64 time=3D0.588 ms
8200 bytes from 192.168.0.2: icmp_seq=3D12 ttl=3D64 time=3D0.580 ms
8200 bytes from 192.168.0.2: icmp_seq=3D13 ttl=3D64 time=3D0.587 ms

--- 192.168.0.2 ping statistics ---
13 packets transmitted, 13 received, 0% packet loss, time 2400ms
rtt min/avg/max/mdev =3D 0.571/0.593/0.693/0.044 ms, ipg/ewma =
200.022/0.607 ms
gershwin:[~] >

	Both initiator and target are alone on a gigabit NIC (Tigon3). On=20
target server, istd1 takes 100% of a CPU (and only one CPU, even my=20
T1000 can simultaneous run 32 threads). I think the limitation comes=20
from istd1.

> You want your avg ping time for 8192 byte payloads to be 300us or =
less.
>=20
> 1000/.268 =3D 3731 IOPS @ 8k =3D 30 MB/s
>=20
> If you use apps that do overlapping asynchronous IO you can see better
> numbers.

	Regards,

	JKB

______________________________________________________________________
This e-mail, and any attachments thereto, is intended only for use by
the addressee(s) named herein and may contain legally privileged
and/or confidential information. If you are not the intended recipient
of this e-mail, you are hereby notified that any dissemination,
distribution or copying of this e-mail, and any attachments thereto,
is strictly prohibited. If you have received this e-mail in error,
please immediately notify the sender and permanently delete the
original and any copy or printout thereof.


------_=_NextPart_001_01C8124B.33D38823
Content-Type: text/html;
	charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Dutf-8">
<META NAME=3D"Generator" CONTENT=3D"MS Exchange Server version =
6.5.7652.24">
<TITLE>Re: [Iscsitarget-devel] Abort Task ?</TITLE>
</HEAD>
<BODY>
<!-- Converted from text/plain format -->
<BR>

<P><FONT SIZE=3D2>Bertrand,<BR>
<BR>
If you are using dd then there will only be 1 outstanding io at a time =
so only istd1 will have work since the initiator will not send the next =
io till istd1 returns the results from the first io and then the next io =
will be issued to istd1 again.<BR>
<BR>
600us is a little slow, try disabling or limiting any interrupt =
coalesence on the network adapters. ISCSI is more sensitive to network =
latency then NFS or CIFS.<BR>
<BR>
-Ross<BR>
<BR>
<BR>
-----Original Message-----<BR>
From: BERTRAND Jo=C3=ABl &lt;joel.bertrand@systella.fr&gt;<BR>
To: Ross S. W. Walker<BR>
CC: blackmagic02881@gmail.com &lt;blackmagic02881@gmail.com&gt;; =
iscsitarget-devel@lists.sourceforge.net =
&lt;iscsitarget-devel@lists.sourceforge.net&gt;; =
linux-raid@vger.kernel.org &lt;linux-raid@vger.kernel.org&gt;<BR>
Sent: Fri Oct 19 03:48:07 2007<BR>
Subject: Re: [Iscsitarget-devel] Abort Task ?<BR>
<BR>
Ross S. W. Walker wrote:<BR>
&gt; BERTRAND Jo=C3=ABl wrote:<BR>
&gt;&gt; BERTRAND Jo=C3=ABl wrote:<BR>
&gt;&gt;&gt;&nbsp;&nbsp;&nbsp;&nbsp; I can format serveral times =
(mkfs.ext3) a 1.5 TB volume<BR>
&gt;&gt; over iSCSI<BR>
&gt;&gt;&gt; without any trouble. I can read and write on this =
virtual<BR>
&gt;&gt; disk without<BR>
&gt;&gt;&gt; any trouble.<BR>
&gt;&gt;&gt;<BR>
&gt;&gt;&gt;&nbsp;&nbsp;&nbsp;&nbsp; Now, I have configured ietd with =
:<BR>
&gt;&gt;&gt;<BR>
&gt;&gt;&gt; Lun 0 Sectors=3D1464725758,Type=3Dnullio<BR>
&gt;&gt;&gt;<BR>
&gt;&gt;&gt; and I run on initiator side :<BR>
&gt;&gt;&gt;<BR>
&gt;&gt;&gt; Root gershwin:[/dev] &gt; dd if=3D/dev/zero of=3D/dev/sdj =
bs=3D8192<BR>
&gt;&gt;&gt; 479482+0 records in<BR>
&gt;&gt;&gt; 479482+0 records out<BR>
&gt;&gt;&gt; 3927916544 bytes (3.9 GB) copied, 153.222 seconds, 25.6 =
MB/s<BR>
&gt;&gt;&gt;<BR>
&gt;&gt;&gt; Root gershwin:[/dev] &gt; dd if=3D/dev/zero of=3D/dev/sdj =
bs=3D8192<BR>
&gt;&gt;&gt;<BR>
&gt;&gt;&gt;&nbsp;&nbsp;&nbsp;&nbsp; I'm waitinfor a crash. No one when =
I write these lines.<BR>
&gt;&gt;&nbsp;&nbsp;&nbsp; I suspect<BR>
&gt;&gt;&gt; an interaction between raid and iscsi.<BR>
&gt;&gt; &nbsp;&nbsp;&nbsp;&nbsp; I simultanely run :<BR>
&gt;&gt;<BR>
&gt;&gt; Root gershwin:[/dev] &gt; dd if=3D/dev/zero of=3D/dev/sdj =
bs=3D8192<BR>
&gt;&gt; 8397210+0 records in<BR>
&gt;&gt; 8397210+0 records out<BR>
&gt;&gt; 68789944320 bytes (69 GB) copied, 2732.55 seconds, 25.2 =
MB/s<BR>
&gt;&gt;<BR>
&gt;&gt; and<BR>
&gt;&gt;<BR>
&gt;&gt; Root gershwin:[~] &gt; dd if=3D/dev/sdj of=3D/dev/null =
bs=3D8192<BR>
&gt;&gt; 739200+0 records in<BR>
&gt;&gt; 739199+0 records out<BR>
&gt;&gt; 6055518208 bytes (6.1 GB) copied, 447.178 seconds, 13.5 =
MB/s<BR>
&gt;&gt;<BR>
&gt;&gt; &nbsp;&nbsp;&nbsp;&nbsp; without any trouble.<BR>
&gt;<BR>
&gt; The speed can definitely be improved. Look at your network =
setup<BR>
&gt; and use ping to try and get the network latency to a minimum.<BR>
&gt;<BR>
&gt; # ping -A -s 8192 172.16.24.140<BR>
&gt; ....<BR>
&gt; --- 172.16.24.140 ping statistics ---<BR>
&gt; 14058 packets transmitted, 14057 received, 0% packet loss, time =
9988ms<BR>
&gt; rtt min/avg/max/mdev =3D 0.234/0.268/2.084/0.041 ms, ipg/ewma =
0.710/0.260 ms<BR>
<BR>
gershwin:[~] &gt; ping -A -s 8192 192.168.0.2<BR>
PING 192.168.0.2 (192.168.0.2) 8192(8220) bytes of data.<BR>
8200 bytes from 192.168.0.2: icmp_seq=3D1 ttl=3D64 time=3D0.693 ms<BR>
8200 bytes from 192.168.0.2: icmp_seq=3D2 ttl=3D64 time=3D0.595 ms<BR>
8200 bytes from 192.168.0.2: icmp_seq=3D3 ttl=3D64 time=3D0.583 ms<BR>
8200 bytes from 192.168.0.2: icmp_seq=3D4 ttl=3D64 time=3D0.589 ms<BR>
8200 bytes from 192.168.0.2: icmp_seq=3D5 ttl=3D64 time=3D0.580 ms<BR>
8200 bytes from 192.168.0.2: icmp_seq=3D6 ttl=3D64 time=3D0.594 ms<BR>
8200 bytes from 192.168.0.2: icmp_seq=3D7 ttl=3D64 time=3D0.580 ms<BR>
8200 bytes from 192.168.0.2: icmp_seq=3D8 ttl=3D64 time=3D0.592 ms<BR>
8200 bytes from 192.168.0.2: icmp_seq=3D9 ttl=3D64 time=3D0.589 ms<BR>
8200 bytes from 192.168.0.2: icmp_seq=3D10 ttl=3D64 time=3D0.571 ms<BR>
8200 bytes from 192.168.0.2: icmp_seq=3D11 ttl=3D64 time=3D0.588 ms<BR>
8200 bytes from 192.168.0.2: icmp_seq=3D12 ttl=3D64 time=3D0.580 ms<BR>
8200 bytes from 192.168.0.2: icmp_seq=3D13 ttl=3D64 time=3D0.587 ms<BR>
<BR>
--- 192.168.0.2 ping statistics ---<BR>
13 packets transmitted, 13 received, 0% packet loss, time 2400ms<BR>
rtt min/avg/max/mdev =3D 0.571/0.593/0.693/0.044 ms, ipg/ewma =
200.022/0.607 ms<BR>
gershwin:[~] &gt;<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Both initiator and target are =
alone on a gigabit NIC (Tigon3). On<BR>
target server, istd1 takes 100% of a CPU (and only one CPU, even my<BR>
T1000 can simultaneous run 32 threads). I think the limitation comes<BR>
from istd1.<BR>
<BR>
&gt; You want your avg ping time for 8192 byte payloads to be 300us or =
less.<BR>
&gt;<BR>
&gt; 1000/.268 =3D 3731 IOPS @ 8k =3D 30 MB/s<BR>
&gt;<BR>
&gt; If you use apps that do overlapping asynchronous IO you can see =
better<BR>
&gt; numbers.<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Regards,<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; JKB<BR>
</FONT>
</P>


<P></P>
<HR WIDTH=3D"100%">
This e-mail, and any attachments thereto, is intended only for use by
the addressee(s) named herein and may contain legally privileged
and/or confidential information. If you are not the intended recipient
of this e-mail, you are hereby notified that any dissemination,
distribution or copying of this e-mail, and any attachments thereto,
is strictly prohibited. If you have received this e-mail in error,
please immediately notify the sender and permanently delete the
original and any copy or printout thereof.

</BODY>
</HTML>
------_=_NextPart_001_01C8124B.33D38823--


--===============0967676551==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-------------------------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc.
Still grepping through log files to find problems?  Stop.
Now Search log events and configuration files using AJAX and a browser.
Download your FREE copy of Splunk now >> http://get.splunk.com/
--===============0967676551==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Iscsitarget-devel mailing list
Iscsitarget-devel@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/iscsitarget-devel

--===============0967676551==--
