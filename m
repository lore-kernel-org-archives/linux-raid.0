From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: 2.6.31-rc5-git2 crash on a idle system.
Date: Fri, 07 Aug 2009 07:51:09 +1000
Message-ID: <1249595469.24311.5.camel@pasglop>
References: <4A78292A.5000607@in.ibm.com>
	<1249421223.18245.36.camel@pasglop> <4A794E26.8080207@in.ibm.com>
	<1249465934.18245.54.camel@pasglop>  <4A7ADBB1.3050906@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <4A7ADBB1.3050906@in.ibm.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org
Errors-To: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org
To: Sachin Sant <sachinp@in.ibm.com>
Cc: neilb@suse.de, linuxppc-dev@ozlabs.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 2009-08-06 at 19:03 +0530, Sachin Sant wrote:
> I added few printks in the initcall debug code patch. The o/p suggests
> that by the time first initicall debug message is printed the code is
> already corrupted. Further debug suggests, when start_kernel() is
> called the code at address(0xc000000000600000) is already corrupted.
> About 28 bytes of code starting from the above address is
> overwritten. 
> 
> I will try to add few more debug statements to find the place where
> this corruption might me happening.

Hrm... start_kernel is very very early... strange. Can you double check
that the actual kernel image contains the right stuff ? Also, what
distro are you using to test that and how are you booting that kernel ?

You can always add something to prom_init.c to test (though beware you
aren't relocated yet so you need to offset the addresses).

Cheers,
Ben.
