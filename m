From: Steve Thompson <smt-o5kEEyLrCppWk0Htik3J/w@public.gmane.org>
Subject: Re: Possible to use multiple disk to bypass I/O wait?
Date: Thu, 9 Jun 2011 15:06:02 -0400 (EDT)
Message-ID: <alpine.LRH.0.9999.1106091502270.31317@helios.vgersoft.com>
References: <BANLkTimFOaJoMnwid1F+ghVwkBgJi2FymQ@mail.gmail.com>
Reply-To: CentOS mailing list <centos-IFYaIzF+flcdnm+yROfE0A@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <centos-bounces-IFYaIzF+flcdnm+yROfE0A@public.gmane.org>
In-Reply-To: <BANLkTimFOaJoMnwid1F+ghVwkBgJi2FymQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <http://lists.centos.org/mailman/listinfo/centos>,
	<mailto:centos-request-IFYaIzF+flcdnm+yROfE0A@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.centos.org/pipermail/centos>
List-Post: <mailto:centos-IFYaIzF+flcdnm+yROfE0A@public.gmane.org>
List-Help: <mailto:centos-request-IFYaIzF+flcdnm+yROfE0A@public.gmane.org?subject=help>
List-Subscribe: <http://lists.centos.org/mailman/listinfo/centos>,
	<mailto:centos-request-IFYaIzF+flcdnm+yROfE0A@public.gmane.org?subject=subscribe>
Sender: centos-bounces-IFYaIzF+flcdnm+yROfE0A@public.gmane.org
Errors-To: centos-bounces-IFYaIzF+flcdnm+yROfE0A@public.gmane.org
To: CentOS mailing list <centos-IFYaIzF+flcdnm+yROfE0A@public.gmane.org>
Cc: linux-raid <linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-raid.ids

On Thu, 9 Jun 2011, Emmanuel Noobadmin wrote:

> I'm trying to resolve an I/O problem on a CentOS 5.6 server. The
> process basically scans through Maildirs, checking for space usage and
> quota. Because there are hundred odd user folders and several 10s of
> thousands of small files, this sends the I/O wait % way high. The
> server hits a very high load level and stops responding to other
> requests until the crawl is done.

If the server is reduced to a crawl, it's possible that you are hitting 
the dirty_ratio limit due to writes and the server has entered synchronous 
I/O mode. As others have mentioned, setting noatime could have a 
significant effect, especially if there are many files and the server 
doesn't have much memory. You can try increasing dirty_ratio to see if it 
has an effect, eg:

 	# sysctl vm.dirty_ratio
 	# sysctl -w vm.dirty_ratio=50

Steve
