From: =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <joel.bertrand@systella.fr>
Subject: Re: [BUG] Raid1/5 over iSCSI trouble
Date: Sat, 27 Oct 2007 21:35:44 +0200
Message-ID: <47239310.6060801@systella.fr>
References: <4714BB92.7040701@systella.fr> <4718DE66.8000905@tmr.com>	
	<471916B5.6080709@systella.fr> <47191855.4020402@systella.fr>	
	<47191BCF.2000908@systella.fr>	
	<1192828331.30976.26.camel@dwillia2-linux.ch.intel.com>	
	<4719B6DE.9040403@systella.fr> <471EF07A.5040007@systella.fr>	
	<e9c3a7c20710241649qb26c36by5733a93cff394c40@mail.gmail.com>	
	<47233D37.6070409@systella.fr>
	<e9c3a7c20710271127p24635207p4b5cc03047118f36@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <iscsitarget-devel-bounces@lists.sourceforge.net>
In-Reply-To: <e9c3a7c20710271127p24635207p4b5cc03047118f36@mail.gmail.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/iscsitarget-devel>,
	<mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=iscsitarget-devel>
List-Post: <mailto:iscsitarget-devel@lists.sourceforge.net>
List-Help: <mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/iscsitarget-devel>,
	<mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: iscsitarget-devel-bounces@lists.sourceforge.net
Errors-To: iscsitarget-devel-bounces@lists.sourceforge.net
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, sparclinux@vger.kernel.org, iscsitarget-devel@lists.sourceforge.net, Bill Davidsen <davidsen@tmr.com>
List-Id: linux-raid.ids

Dan Williams wrote:
> On 10/27/07, BERTRAND Jo=EBl <joel.bertrand@systella.fr> wrote:
>> Dan Williams wrote:
>>> Can you collect some oprofile data, as Ming suggested, so we can maybe
>>> see what md_d0_raid5 and istd1 are fighting about?  Hopefully it is as
>>> painless to run on sparc as it is on IA:
>>>
>>> opcontrol --start --vmlinux=3D/path/to/vmlinux
>>> <wait>
>>> opcontrol --stop
>>> opreport --image-path=3D/lib/modules/`uname -r` -l
>>         Done.
>>
> =

> [..]
> =

>>         Is it enough ?
> =

> I would expect md_d0_raid5 and istd1 to show up pretty high in the
> list if they are constantly pegged at a 100% CPU utilization like you
> showed in the failure case.  Maybe this was captured after the target
> has disconnected?

	No, I have launched opcontrol before starting raid1 creation, and =

stopped after disconnection. Don't forget that this server has 32 CPU's.

	Regards,

	JKB

-------------------------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc.
Still grepping through log files to find problems?  Stop.
Now Search log events and configuration files using AJAX and a browser.
Download your FREE copy of Splunk now >> http://get.splunk.com/
