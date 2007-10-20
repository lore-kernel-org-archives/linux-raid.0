From: =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <joel.bertrand@systella.fr>
Subject: Re: [BUG] Raid1/5 over iSCSI trouble
Date: Sat, 20 Oct 2007 09:45:14 +0200
Message-ID: <4719B20A.9070903@systella.fr>
References: <4714BB92.7040701@systella.fr>
	<47161CE3.80909@systella.fr>	<e9c3a7c20710170758p4046ca44labe370e94bca6e93@mail.gmail.com>	<e9c3a7c20710170840u2ed8d6a9x26523eec6700ad11@mail.gmail.com>	<47181CB2.1060602@tmr.com>
	<471864F8.9010209@systella.fr><1192809103.30976.11.camel@dwillia2-linux.ch.intel.com><4718DE66.8000905@tmr.com>
	<471916B5.6080709@systella.fr> <47191855.4020402@systella.fr>
	<E2BB8074E5500C42984D980D4BD78EF9017A296F@MFG-NYC-EXCH2.mfg.prv>
	<47191C66.309@systella.fr>
	<E2BB8074E5500C42984D980D4BD78EF9017A2971@MFG-NYC-EXCH2.mfg.prv>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iscsitarget-devel-bounces@lists.sourceforge.net>
In-Reply-To: <E2BB8074E5500C42984D980D4BD78EF9017A2971@MFG-NYC-EXCH2.mfg.prv>
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
> Oh, in that case you will be much better served with DRBD, which
> would provide you with what you want without creating a Frankenstein
> setup...

	OK. I didn't know DRDB project, but it cannot be used in my case. 
Indeed, I'm trying in a first time to replicate two raid5 arrays. But 
ultimate goal is to create a raid5 array over iSCSI. At this time, I 
only test with raid1 because I have to begin with a simple configuration.

	Regards,

	JKB

-------------------------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc.
Still grepping through log files to find problems?  Stop.
Now Search log events and configuration files using AJAX and a browser.
Download your FREE copy of Splunk now >> http://get.splunk.com/
