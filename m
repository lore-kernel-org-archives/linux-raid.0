From: =?UTF-8?B?QkVSVFJBTkQgSm/Dq2w=?= <joel.bertrand@systella.fr>
Subject: Re: Abort Task ?
Date: Fri, 19 Oct 2007 16:47:27 +0200
Message-ID: <4718C37F.3050406@systella.fr>
References: <471720F1.40409@systella.fr> <471727F3.2080500@systella.fr>	
	<471734C5.8090405@systella.fr>	
	<E2BB8074E5500C42984D980D4BD78EF9017A2958@MFG-NYC-EXCH2.mfg.prv>	
	<1192721909.3596.15.camel@dhcp-117.ibrix.com>	
	<47178ABF.1040500@systella.fr> <47179492.4000109@systella.fr>	
	<E2BB8074E5500C42984D980D4BD78EF9017A295C@MFG-NYC-EXCH2.mfg.prv>	
	<47186137.2030906@systella.fr>
	<1192802144.3593.2.camel@dhcp-117.ibrix.com>	
	<4718BF6A.6080905@systella.fr>
	<1192804659.3593.7.camel@dhcp-117.ibrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iscsitarget-devel-bounces@lists.sourceforge.net>
In-Reply-To: <1192804659.3593.7.camel@dhcp-117.ibrix.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/iscsitarget-devel>,
	<mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=iscsitarget-devel>
List-Post: <mailto:iscsitarget-devel@lists.sourceforge.net>
List-Help: <mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/iscsitarget-devel>,
	<mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: iscsitarget-devel-bounces@lists.sourceforge.net
Errors-To: iscsitarget-devel-bounces@lists.sourceforge.net
To: blackmagic02881@gmail.com
Cc: iscsitarget-devel@lists.sourceforge.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ming Zhang wrote:
> 
> as Ross pointed out, many io pattern only have 1 outstanding io at any
> time, so there is only one work thread actively to serve it. so it can
> not exploit the multiple core here.
> 
> 
> you see 100% at nullio or fileio? with disk, most time should spend on
> iowait and cpu utilization should not high at all.

	With both nullio and fileio...

-------------------------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc.
Still grepping through log files to find problems?  Stop.
Now Search log events and configuration files using AJAX and a browser.
Download your FREE copy of Splunk now >> http://get.splunk.com/
