From: =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <joel.bertrand@systella.fr>
Subject: Re: Abort Task ?
Date: Fri, 19 Oct 2007 09:48:07 +0200
Message-ID: <47186137.2030906@systella.fr>
References: <471720F1.40409@systella.fr> <471727F3.2080500@systella.fr>	
	<471734C5.8090405@systella.fr>	
	<E2BB8074E5500C42984D980D4BD78EF9017A2958@MFG-NYC-EXCH2.mfg.prv>
	<1192721909.3596.15.camel@dhcp-117.ibrix.com>
	<47178ABF.1040500@systella.fr> <47179492.4000109@systella.fr>
	<E2BB8074E5500C42984D980D4BD78EF9017A295C@MFG-NYC-EXCH2.mfg.prv>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <iscsitarget-devel-bounces@lists.sourceforge.net>
In-Reply-To: <E2BB8074E5500C42984D980D4BD78EF9017A295C@MFG-NYC-EXCH2.mfg.prv>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/iscsitarget-devel>,
	<mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=iscsitarget-devel>
List-Post: <mailto:iscsitarget-devel@lists.sourceforge.net>
List-Help: <mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/iscsitarget-devel>,
	<mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: iscsitarget-devel-bounces@lists.sourceforge.net
Errors-To: iscsitarget-devel-bounces@lists.sourceforge.net
To: "Ross S. W. Walker" <rwalker@medallion.com>
Cc: iscsitarget-devel@lists.sourceforge.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ross S. W. Walker wrote:
> BERTRAND Jo=EBl wrote:
>> BERTRAND Jo=EBl wrote:
>>>     I can format serveral times (mkfs.ext3) a 1.5 TB volume =

>> over iSCSI =

>>> without any trouble. I can read and write on this virtual =

>> disk without =

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
>>>     I'm waitinfor a crash. No one when I write these lines. =

>>    I suspect =

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
> =

> The speed can definitely be improved. Look at your network setup
> and use ping to try and get the network latency to a minimum.
> =

> # ping -A -s 8192 172.16.24.140
> ....
> --- 172.16.24.140 ping statistics ---
> 14058 packets transmitted, 14057 received, 0% packet loss, time 9988ms
> rtt min/avg/max/mdev =3D 0.234/0.268/2.084/0.041 ms, ipg/ewma 0.710/0.260=
 ms

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
rtt min/avg/max/mdev =3D 0.571/0.593/0.693/0.044 ms, ipg/ewma 200.022/0.607=
 ms
gershwin:[~] >

	Both initiator and target are alone on a gigabit NIC (Tigon3). On =

target server, istd1 takes 100% of a CPU (and only one CPU, even my =

T1000 can simultaneous run 32 threads). I think the limitation comes =

from istd1.

> You want your avg ping time for 8192 byte payloads to be 300us or less.
> =

> 1000/.268 =3D 3731 IOPS @ 8k =3D 30 MB/s
> =

> If you use apps that do overlapping asynchronous IO you can see better
> numbers.

	Regards,

	JKB

-------------------------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc.
Still grepping through log files to find problems?  Stop.
Now Search log events and configuration files using AJAX and a browser.
Download your FREE copy of Splunk now >> http://get.splunk.com/
