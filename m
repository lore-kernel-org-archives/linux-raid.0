From: =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <joel.bertrand@systella.fr>
Subject: Re: [BUG] Raid1/5 over iSCSI trouble
Date: Fri, 19 Oct 2007 23:06:46 +0200
Message-ID: <47191C66.309@systella.fr>
References: <4714BB92.7040701@systella.fr>
	<47161CE3.80909@systella.fr>	<e9c3a7c20710170758p4046ca44labe370e94bca6e93@mail.gmail.com>	<e9c3a7c20710170840u2ed8d6a9x26523eec6700ad11@mail.gmail.com>	<47181CB2.1060602@tmr.com>
	<471864F8.9010209@systella.fr><1192809103.30976.11.camel@dwillia2-linux.ch.intel.com><4718DE66.8000905@tmr.com>
	<471916B5.6080709@systella.fr> <47191855.4020402@systella.fr>
	<E2BB8074E5500C42984D980D4BD78EF9017A296F@MFG-NYC-EXCH2.mfg.prv>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <iscsitarget-devel-bounces@lists.sourceforge.net>
In-Reply-To: <E2BB8074E5500C42984D980D4BD78EF9017A296F@MFG-NYC-EXCH2.mfg.prv>
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
Cc: linux-raid@vger.kernel.org, sparclinux@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, iscsitarget-devel@lists.sourceforge.net, Bill Davidsen <davidsen@tmr.com>
List-Id: linux-raid.ids

Ross S. W. Walker wrote:
> BERTRAND Jo=EBl wrote:
>> BERTRAND Jo=EBl wrote:
>>> Bill Davidsen wrote:
>>>> Dan Williams wrote:
>>>>> On Fri, 2007-10-19 at 01:04 -0700, BERTRAND Jo=EBl wrote:
>>>>>  =

>>>>>>         I run for 12 hours some dd's (read and write in nullio)
>>>>>> between
>>>>>> initiator and target without any disconnection. Thus =

>> iSCSI code seems
>>>>>> to
>>>>>> be robust. Both initiator and target are alone on a =

>> single gigabit
>>>>>> ethernet link (without any switch). I'm investigating...
>>>>>>     =

>>>>> Can you reproduce on 2.6.22?
>>>>>
>>>>> Also, I do not think this is the cause of your failure, =

>> but you have
>>>>> CONFIG_DMA_ENGINE=3Dy in your config.  Setting this to 'n' =

>> will compile
>>>>> out the unneeded checks for offload engines in async_memcpy and
>>>>> async_xor.
>>>> Given that offload engines are far less tested code, I =

>> think this is a =

>>>> very good thing to try!
>>>     I'm trying wihtout CONFIG_DMA_ENGINE=3Dy. istd1 only uses =

>> 40% of one =

>>> CPU when I rebuild my raid1 array. 1% of this array was now =

>>> resynchronized without any hang.
>>>
>>> Root gershwin:[/usr/scripts] > cat /proc/mdstat
>>> Personalities : [raid1] [raid6] [raid5] [raid4]
>>> md7 : active raid1 sdi1[2] md_d0p1[0]
>>>       1464725632 blocks [2/1] [U_]
>>>       [>....................]  recovery =3D  1.0% =

>> (15705536/1464725632) =

>>> finish=3D1103.9min speed=3D21875K/sec
>> 	Same result...
>>
>> connection2:0: iscsi: detected conn error (1011)
>>  =

>>           session2: iscsi: session recovery timed out after 120 secs
>> sd 4:0:0:0: scsi: Device offlined - not ready after error recovery
>> sd 4:0:0:0: scsi: Device offlined - not ready after error recovery
>> sd 4:0:0:0: scsi: Device offlined - not ready after error recovery
>> sd 4:0:0:0: scsi: Device offlined - not ready after error recovery
>> sd 4:0:0:0: scsi: Device offlined - not ready after error recovery
>> sd 4:0:0:0: scsi: Device offlined - not ready after error recovery
>> sd 4:0:0:0: scsi: Device offlined - not ready after error recovery
> =

> I am unsure why you would want to setup an iSCSI RAID1, but before
> doing so I would try to verify that each independant iSCSI session
> is bullet proof.

	I use one and only one iSCSI session. Raid1 array is built between a =

local and iSCSI volume.

	JKB

-------------------------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc.
Still grepping through log files to find problems?  Stop.
Now Search log events and configuration files using AJAX and a browser.
Download your FREE copy of Splunk now >> http://get.splunk.com/
