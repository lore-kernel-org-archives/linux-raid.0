From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: `pvmove stuck' in RH bugzilla
Date: Wed, 6 Jul 2011 12:23:59 +0100
Message-ID: <20110706112359.GF5448@agk-dp.fab.redhat.com>
References: <20110706095310.GA3225@swordfish>
Reply-To: LVM2 development <lvm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <lvm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20110706095310.GA3225@swordfish>
List-Unsubscribe: <https://www.redhat.com/mailman/options/lvm-devel>,
	<mailto:lvm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/lvm-devel>
List-Post: <mailto:lvm-devel@redhat.com>
List-Help: <mailto:lvm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/lvm-devel>,
	<mailto:lvm-devel-request@redhat.com?subject=subscribe>
Sender: lvm-devel-bounces@redhat.com
Errors-To: lvm-devel-bounces@redhat.com
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, lvm-devel@redhat.com
List-Id: linux-raid.ids

On Wed, Jul 06, 2011 at 12:53:10PM +0300, Sergey Senozhatsky wrote:
> I think we just trapped into the same trouble with pvmove as described in 
> https://bugzilla.redhat.com/show_bug.cgi?id=602516
> https://bugzilla.redhat.com/show_bug.cgi?id=706036
> 
> Alasdair, could you please point are those patches in vanilla kernel 
> (3.0-rc*) or linux-next, or some RH internal tree? 
> This is not critical, though I'd like to try out patches.
 
This is a userspace bug not a kernel one.
There is a workaround, which is to perform the pvmove one LV at a time
using the --name option.  (For each LV, run pvmove -n <lvname>.)

The patched code is in the upstream lvm2 repository:
  git://sources.redhat.com/git/lvm2
  http://sourceware.org/cgi-bin/cvsweb.cgi/LVM2/doc/?cvsroot=lvm2
  http://sourceware.org/lvm2/

It was only last night that the code incorporating these changes passed
our public testsuite for the first time, so I think it is still
premature to be using this on production systems.  But this means I hope
to be in a position to make the first development release containing a
fix for the problems quite soon.  (I added assertions to catch other
instances of the related problems - it was more than just pvmove
affected.)

Alasdair

--
lvm-devel mailing list
lvm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/lvm-devel
