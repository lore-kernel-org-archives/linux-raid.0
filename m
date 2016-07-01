From: Fam Zheng <famz@redhat.com>
Subject: Re: [PATCH v2 00/12] gendisk: Generate uevent after attribute
	available
Date: Fri, 1 Jul 2016 09:01:13 +0800
Message-ID: <20160701010113.GB10122@ad.usersys.redhat.com>
References: <20160630015953.6888-1-famz@redhat.com>
	<20160630062442.GA19761@infradead.org>
	<20160630063554.GE23296@ad.usersys.redhat.com>
	<20160630063839.GA17205@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <20160630063839.GA17205@infradead.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, "Michael S. Tsirkin" <mst@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-nvme@lists.infradead.org, virtualization@lists.linux-foundation.org, Keith Busch <keith.busch@intel.com>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Shaohua Li <shli@kernel.org>, Nitin Gupta <ngupta@vflare.org>, famz@redhat.com, Jiri Kosina <jikos@kernel.org>, linux-block@vger.kernel.org, dan.j.williams@intel.com, "Ed L. Cashin" <ed.cashin@acm.org>, Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>, linux-mtd@lists.infradead.org, Brian Norris <computersforpeace@gmail.com>, linuxppc-dev@lists.ozlabs.org
List-Id: linux-raid.ids

On Wed, 06/29 23:38, Christoph Hellwig wrote:
> On Thu, Jun 30, 2016 at 02:35:54PM +0800, Fam Zheng wrote:
> > also more code and less flexible IMO.  For example, we need at least two
> > variants, for attribute_group and device_attribute separately, right?
> 
> Yes, or maybe just a calling convention that just passes both.

OK, I can look into that, but I'm not sure about the error handling. Currently
add_disk returns void, do you have any plan on that too? should I change it in
v3 (to at least return the attribute creation failure)?

Fam
