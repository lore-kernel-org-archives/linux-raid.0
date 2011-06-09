From: Emmanuel Noobadmin <centos.admin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Possible to use multiple disk to bypass I/O wait?
Date: Thu, 9 Jun 2011 17:24:23 +0800
Message-ID: <BANLkTimFOaJoMnwid1F+ghVwkBgJi2FymQ@mail.gmail.com>
Reply-To: CentOS mailing list <centos-IFYaIzF+flcdnm+yROfE0A@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <centos-bounces-IFYaIzF+flcdnm+yROfE0A@public.gmane.org>
List-Unsubscribe: <http://lists.centos.org/mailman/listinfo/centos>,
	<mailto:centos-request-IFYaIzF+flcdnm+yROfE0A@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.centos.org/pipermail/centos>
List-Post: <mailto:centos-IFYaIzF+flcdnm+yROfE0A@public.gmane.org>
List-Help: <mailto:centos-request-IFYaIzF+flcdnm+yROfE0A@public.gmane.org?subject=help>
List-Subscribe: <http://lists.centos.org/mailman/listinfo/centos>,
	<mailto:centos-request-IFYaIzF+flcdnm+yROfE0A@public.gmane.org?subject=subscribe>
Sender: centos-bounces-IFYaIzF+flcdnm+yROfE0A@public.gmane.org
Errors-To: centos-bounces-IFYaIzF+flcdnm+yROfE0A@public.gmane.org
To: CentOS mailing list <centos-IFYaIzF+flcdnm+yROfE0A@public.gmane.org>, linux-raid <linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-raid.ids

I'm trying to resolve an I/O problem on a CentOS 5.6 server. The
process basically scans through Maildirs, checking for space usage and
quota. Because there are hundred odd user folders and several 10s of
thousands of small files, this sends the I/O wait % way high. The
server hits a very high load level and stops responding to other
requests until the crawl is done.

I am wondering if I add another disk and symlink the sub-directories
to that, would that free up the server to respond to other requests
despite the wait on that disk?

Alternatively, if I mdraid mirror the existing disk, would md be smart
enough to read using the other disk while the first's tied up with the
first process?
